#### Sleeper Player Scores ####

#' Sleeper PlayerScores
#'
#' Unfortunately, Sleeper has deprecated their player stats endpoint from their supported/open API.
#' Adding some nflfastr-based ideas to the pipeline for future iterations.
#'
#' @param conn the list object created by \code{ff_connect()}
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_playerscores Sleeper: Deprecated their open API endpoint for player scores
#'
#' @export

ff_playerscores.sleeper_conn <- function(conn, ...) {
  warning(glue::glue("Sleeper has deprecated their stats endpoint, no player stats data can be returned at this time."))
}
