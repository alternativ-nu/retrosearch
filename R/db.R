#' Path to sqlite3 database
#' 
#' @return character string to sqlite3 db file
#' @export
db_path <- function() {
  fpath <- 
    system.file("extdata", "retro.sqlite", 
      package = "retrosearch")
  fpath  
}

#' Path to data in Excel
#' 
#' @return character string to sqlite3 db file
#' @export
path_excel <- function() {
  system.file("extdata", "Artiklar.xlsx", 
      package = "retrosearch")
}

#' Get TOC - table of contents
#' 
#' @importFrom tibble as_tibble
#' @importFrom RSQLite SQLite dbGetQuery
#' @import dplyr
#' @export
retrosearch_toc <- function() {
  tibble::as_tibble(dbGetQuery(dbConnect(RSQLite::SQLite(), 
   db_path()), "select * from retro;")) %>% 
    filter(!desc == "NA") %>%
    mutate(Titel = paste0("<a target='_blank' href='", 
      url, "'>", title, "</a>")) %>%
    mutate(Kvartal = paste0("Q", quarter)) %>%
    select(-c(url, short)) %>% arrange(desc(year, quarter)) %>%
    select(Titel, Sammanfattning = desc, År = year, 
           Kvartal, `Författare` = author, Sida = page)  
}

#' Search content from Åter
#' @param term search term
#' @return tibble with search result
#' @importFrom tibble as_tibble
#' @importFrom RSQLite SQLite dbGetQuery
#' @import dplyr
#' @export
retrosearch_search <- function(term) {
  
  if (missing(term)) {
    query <- "select * from pages;" 
  } else {
    query <- sprintf("select * from pages where pages match '%s';", term)
  }
  
  as_tibble(dbGetQuery(dbConnect(RSQLite::SQLite(), db_path()), query)) %>%
    mutate(Artikel = paste0("<a target='_blank' href='", 
      issue, "'>", title, "</a>")) %>%
    select(-c(issue, title)) %>%
    select(Artikel, everything()) %>%
    setNames(c("Artikel", "Författare", "Sammanfattning"))
}

#' Returns data provided in Excel format from the magazine
#' 
#' @return tibble with structured article metadata
#' @importFrom readxl read_xlsx
#' @export
retrosearch_excel <- function() {
  e <- read_xlsx(path_excel())
  setNames(e, c(
    "group", "category", "year", "nr", "publication",
    "availability", "page", "page_n", "series", "part",
    "title", "subtitle", "author", "ingress"))
}

#' Retrieve image url for magazine
#' 
#' @param q quarter (one digit)
#' @param y year (two digits)
#' @return image url
#' @importFrom httr content
#' @importFrom xml2 xml_find_all xml_attr
#' @export
retrosearch_img <- function(q, y) {
  #stopifnot(q %in% 1:4 & y %in% c(98, 99, 00, 01:20))
  url <- paste0("http://www.alternativ.nu/butik/åter/åter-", q, y, ".html")
  u <- httr::GET(url)
  
  res <- 
    content(u) %>% 
    xml_find_all("//head//meta[@property='og:image']") %>%
    xml_attr("content")
  
  if (length(res) < 1) 
    return (NA)
  
  res
}

