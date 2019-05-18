ps_products <- function() {

#/api/manufacturers/?display=[name]&filter[name]=[appl]%
  
  userpass <- Sys.getenv("PRESTASHOP_TOKEN")
  
  res <- 
    GET("http://alternativ.nu/butik/api/products?output_format=JSON",
      authenticate(userpass, userpass))
  
  content(res) %>% 
  xml_find_all("//p") %>% 
  xml_text() %>% 
  fromJSON() %>%
  as_tibble %>%
  pull(1) %>%
  pull("id")
  
}

ps_product <- function(id) {

#  param_id <- id
#  if (length(id) > 1) param_id <- paste(id, collapse = "|")
  
#    GET(sprintf("http://alternativ.nu/butik/api/products?output_format=JSON&display=full&filter[id]=[%s]", param_id), authenticate(userpass, userpass))

  userpass <- Sys.getenv("PRESTASHOP_TOKEN")
  
  res <- 
    GET(sprintf("http://alternativ.nu/butik/api/products/%s/?output_format=JSON", id), authenticate(userpass, userpass))
  
  data <- content(res) %>% xml_text() %>% fromJSON()
  
  tibble(
    id = id,
    name = data$product$name,
    link = data$product$link_rewrite,
    active = data$product$active,
    available = data$product$available_for_order,
    desc = data$product$description, 
    desc_short = data$product$description_short
  )
}

#' Retrieve prestashop webshop links for publications 
#' 
#' The Prestashop API allows for getting webshop links
#' 
#' @return a tibble with product data from prestashop
#' @importFrom httr GET authenticate
#' @import xml2 jsonlite dplyr stringr
#' @export
ps_pubs <- function() {
  
  userpass <- Sys.getenv("PRESTASHOP_TOKEN")

  url <- paste0(
    "http://alternativ.nu/butik/api/products?output_format=JSON",
    "&display=[id,name,link_rewrite,active,available_for_order,",
    "description_short]&filter[active]=[0|1]"
  )
  
  res <- 
    GET(sprintf(url), authenticate(userpass, userpass))

  data <- content(res) %>% xml_text() %>% fromJSON()
  
  as_tibble(data$products) %>% 
    select(id, name, link = link_rewrite, 
           active, available = available_for_order, 
           desc = description_short) %>% 
  mutate(is_publication = str_detect(name, "^Åter")) %>%
  mutate(publication = ifelse(is_publication, str_extract(name, "\\d+/\\d+"), NA)) %>%
  mutate(shop_url = sprintf("https://www.alternativ.nu/butik/cart?add=1&id_product=%s", id))
}

# retrosearch::retrosearch_excel() %>% 
#   left_join(ps_pubs()) %>% 
#   select(publication, shop_url) %>% 
#   View()

# ps_product(115)
# ids <- ps_products()
