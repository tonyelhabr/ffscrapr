#### MFL CONNECT ####

## CONNECT ## ----

#' Connect to MFL League
#'
#' This function creates a connection object which stores parameters and gets a login-cookie if available
#' @param season Season to access on MFL - if missing, will guess based on system date (current year if March or later, otherwise previous year)
#' @param league_id league_id Numeric ID parameter for each league, typically found in the URL
#' @param APIKEY APIKEY - optional - allows access to private leagues. Key is unique for each league and accessible from Developer's API page (currently assuming one league at a time)
#' @param user_name MFL user_name - optional - when supplied in conjunction with a password, will attempt to retrieve authentication token
#' @param password MFL password - optional - when supplied in conjunction with user_name, will attempt to retrieve authentication token
#' @param user_agent A string representing the user agent to be used to identify calls - may find improved rate_limits if verified token
#' @param rate_limit TRUE by default, pass FALSE to turn off rate limiting
#' @param rate_limit_number number of calls per \code{rate_limit_seconds}, suggested is 60 calls per 60 seconds
#' @param rate_limit_seconds number of seconds as denominator for rate_limit
#'
#' @export mfl_connect
#'
#' @examples
#' library(ffscrapr)
#' mfl_connect(season = 2020, league_id = 54040)
#' mfl_connect(season = 2019, league_id = 54040, rate_limit = FALSE)
#'
#' @return a list that stores MFL connection objects

mfl_connect <- function(season = NULL,
                        league_id=NULL,
                        APIKEY = NULL,
                        user_name = NULL,
                        password = NULL,
                        user_agent = NULL,
                        rate_limit = NULL,
                        rate_limit_number = 60,
                        rate_limit_seconds = 60){

  ## LEAGUE ID ##


  ## USER AGENT ##
  # Self-identifying is mostly about being polite, although MFL has a program to give verified clients more bandwidth!
  # See: https://www03.myfantasyleague.com/2020/csetup?C=APICLI

  if(is.null(user_agent)){
    user_agent <- glue::glue("ffscrapr/",
                             "{utils::packageVersion('ffscrapr')}",
                             " API client package",
                             " https://github.com/dynastyprocess/ffscrapr")}

  user_agent <- httr::user_agent(user_agent)

  ## RATE LIMIT ##
  # For more info, see: https://api.myfantasyleague.com/2020/api_info

  if(is.null(rate_limit)){rate_limit <- TRUE}

  if(!is.logical(rate_limit)){stop("rate_limit should be logical")}

  .get <- .fn_get(rate_limit,rate_limit_number,rate_limit_seconds)

  ## SEASON ##
  # MFL organizes things by league year and tends to roll over around February.
  # Sensible default seems to be calling the current year if in March or later, otherwise previous year if in Jan/Feb

  if(is.null(season) || is.na(season)){
    season <- .fn_choose_season()
    message(glue::glue("No season supplied - choosing {season} based on system date."))
  }

  ## Username/Password Login ##
  m_cookie <- NULL

  if(!is.null(user_name) && is.null(password)){message("User_name supplied but no password - skipping login cookie call!")}
  if(!is.null(password) && is.null(user_name)){message("Password supplied but no user_name - skipping login cookie call!")}

  if(!is.null(user_name) && !is.null(password)){
    m_cookie <- .mfl_logincookie(.get,user_name,password,season,user_agent)}

  ## Collect all of the connection pieces and store in an S3 object ##

  structure(
    list(
      platform = "MFL",
      get = .get,
      season = season,
      league_id = as.character(league_id),
      APIKEY = APIKEY,
      user_agent = user_agent,

      auth_cookie = m_cookie),
    class = 'mfl_conn')
}

## Print Method for Conn Obj ##

#' @noRd
#' @export
print.mfl_conn <- function(x, ...) {
  cat("<MFL connection ",x$season,"_",x$league_id, ">\n", sep = "")
  str(x)
  invisible(x)
}

## LOGIN ## ----
# Do Not Export
#
#' Get MFL Login Cookie
#'
#' Gets login cookie for MFL based on user_name/password
#' Docs: https://api.myfantasyleague.com/2020/api_info#login_info
#'
#' @param user_name MFL user_name (as string)
#' @param password MFL password (as string)
#' @param season Season
#'
#' @keywords internal
#' @noRd
#'
#' @return a login cookie, which should be included as a parameter in an httr GET request

.mfl_logincookie <- function(fn_get,user_name,password,season,user_agent){

  m_cookie <- fn_get(
    glue::glue(
      "https://api.myfantasyleague.com/{season}/login?",
      "USERNAME={user_name}&PASSWORD={utils::URLencode(password,reserved=TRUE)}&XML=1"),
    user_agent)

  m_cookie <- purrr::pluck(m_cookie,'cookies','value')

  if(is.null(m_cookie)){stop("No login cookie available - please recheck user_name/password/season variables again!")}

  return(httr::set_cookies("MFL_USER_ID"=m_cookie[[1]],"MFL_PW_SEQ"=m_cookie[[2]]))
}