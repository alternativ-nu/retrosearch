#' Summary of articles grouped by publication
#' 
#' @param articles tibble with articles
#' @return tibble with summary to be displayed by data table
#' @export
#' @import htmltools
pub_summary <- function(articles) {
  
  coll <- function(x, sep = ", ") paste(collapse = sep, na.omit(unique(x)))
  li <- function(text) paste0("<li>", text, "</li>")

  articles %>%
#  View()
  group_by(year, nr, publication, Thumb, availability) %>%
  summarise(
#    t = coll(sep = "<br/>", li(title)),
    t = coll(sep = ", ", title),
    u = coll(shop_a, sep = "<br/>")
  ) %>%
#  filter(availability != "Slut") %>%
  arrange(desc(year), desc(nr)) %>%
#  mutate(thumb = NA) %>%
#  mutate(desc = paste0(paste0("<h4>Åter nr ", publication, "</h4><br/>", t)))  %>%
  mutate(desc = paste0(u, "<br/>", "<p>", t, "</p>"))  %>%
  #mutate(img = sprintf("<a href='%s'><img src='%s'/>/a>", NA, thumb)) %>%
  ungroup() %>% select(Publikation = Thumb, Innehåll = desc)

}
