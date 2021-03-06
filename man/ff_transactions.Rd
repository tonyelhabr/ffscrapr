% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/0_generics.R, R/flea_transactions.R,
%   R/mfl_transactions.R, R/sleeper_transactions.R
\name{ff_transactions}
\alias{ff_transactions}
\alias{ff_transactions.flea_conn}
\alias{ff_transactions.mfl_conn}
\alias{ff_transactions.sleeper_conn}
\title{Get League Transactions}
\usage{
ff_transactions(conn, ...)

\method{ff_transactions}{flea_conn}(conn, franchise_id = NULL, ...)

\method{ff_transactions}{mfl_conn}(conn, custom_players = FALSE, ...)

\method{ff_transactions}{sleeper_conn}(conn, week = 1:17, ...)
}
\arguments{
\item{conn}{the list object created by \code{ff_connect()}}

\item{...}{additional args for other methods}

\item{franchise_id}{fleaflicker returns transactions grouped by franchise id, pass a list here to filter}

\item{custom_players}{TRUE or FALSE - fetch custom players}

\item{week}{A week filter for transactions - 1 returns all offseason transactions. Default 1:17 returns all transactions.}
}
\value{
A tidy dataframe of transaction data
}
\description{
This function returns a tidy dataframe of transactions - generally one row per player per transaction per team.
Each trade is represented twice, once per each team.
}
\section{Methods (by class)}{
\itemize{
\item \code{flea_conn}: Fleaflicker: returns all transactions, including free agents, waivers, and trades.

\item \code{mfl_conn}: MFL: returns all transactions, including auction, free agents, IR, TS, waivers, and trades.

\item \code{sleeper_conn}: Sleeper: returns all transactions, including free agents, waivers, and trades.
}}

\examples{
\donttest{
conn <- fleaflicker_connect(season = 2020, league_id = 312861)
ff_transactions(conn)
}

\donttest{
dlf_conn <- mfl_connect(2019, league_id = 37920)
ff_transactions(dlf_conn)
}
\donttest{
jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
x <- ff_transactions(jml_conn, week = 1:17)
}

}
