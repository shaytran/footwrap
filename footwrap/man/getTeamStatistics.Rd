% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zerui_script.R
\name{getTeamStatistics}
\alias{getTeamStatistics}
\title{Retrieve Team Statistics}
\usage{
getTeamStatistics(league, season, team, apikey)
}
\arguments{
\item{league}{The league's ID.}

\item{season}{The season year.}

\item{team}{The team's name.}

\item{apikey}{Your API key for API-Sports.io.}
}
\value{
Data frame with statistics: Played, Wins, Draws, Loses, Goals For/Against, and Averages.
}
\description{
Fetches and returns team statistics as a data frame for specified league, season, and team.
}
\examples{
getTeamStatistics(39, 2019, "Manchester United", "<your_api_key>")

}
