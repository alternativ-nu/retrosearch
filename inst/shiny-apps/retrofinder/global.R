library(dplyr)
library(retrosearch)

enableBookmarking(store = "url")

articles <- function() {
  
  available_pubs <- retrosearch:::available_pubs
  
  topics0 <- 
    retrosearch_excel() %>%
    count() %>%
    mutate(topic = paste0("Alla ämnesgrupper - Allt (", n, ")"))
  
  topics1 <- 
    retrosearch_excel() %>% 
    count(group) %>%
    mutate(topic = paste0(group, " - Allt (", n, ")")) 
  
  topics2 <- 
    retrosearch_excel() %>% 
    count(group, category) %>%
    mutate(topic = paste0(group, " - ", category, " (", n, ")")) 
  
  articles <- 
    bind_rows(
      retrosearch_excel() %>% mutate(topic = topics0$topic),
      topics1 %>% right_join(retrosearch_excel()),
      topics2 %>% right_join(retrosearch_excel())
    ) %>% 
    filter(!is.na(availability)) %>%
    arrange(-desc(topic)) %>%
    left_join(available_pubs, by = c("publication")) %>%
    mutate(Thumb = ifelse(!is.na(thumb), 
          paste0("<a target='_blank' href='", "https://www.alternativ.nu/butik/åter/åter-", q, y, ".html","'><img height=120 src='", thumb, "'/></a>"),
          NA)) %>%
    mutate(Source = ifelse(!is.na(thumb),
          paste0("<a target='_blank' href='", "https://www.alternativ.nu/butik/åter/åter-", q, y, ".html","'>", paste0(title, " av ", author, " (", paste(publication, page), ")"), "</a>"), 
          NA))
  
  articles
  
}

articles <- articles()
