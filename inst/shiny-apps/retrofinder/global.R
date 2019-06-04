library(retrosearch)

options(shiny.fullstacktrace = TRUE)
enableBookmarking(store = "url")

cat(file = stderr(), "updating data...", "\n")
retrosearch_update()

cat(file = stderr(), "loading data...", "\n")
articles <- retrosearch_articles()
subscriberdata <- retrosearch_data()$transactions
