#' Subscriber ids
#' @return vector of ids
#' @export
subscriber_pnrs <- function() {
  subscriberdata %>% distinct(id) %>% pull(id)
}

#' Subscriber issues given id
#' @param pnr subscriber id
#' @return vector of issue strings
#' @export
subscriber_issues <- function(pnr) {
  subscriberdata %>% filter(id == pnr) %>% pull(issue) %>% unique
}

#' Subscriber issues not bought given id
#' @param pnr subscriber id
#' @return vector of issue strings
#' @export
subscriber_issues_missing <- function(pnr) {
  issues <- subscriberdata %>% pull(issue) %>% unique
  #issues <- trimws(unique(retrosearch:::available_pubs$publication))
  setdiff(issues, subscriber_issues(pnr))
}

#' Subscriber credit given id
#' @param pnr subscriber id
#' @return number with total credits left
#' @export
subscriber_credit <- function(pnr) {
  subscriberdata %>% filter(id == pnr) %>% pull(credits) %>% unique
}