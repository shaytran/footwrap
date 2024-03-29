% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shay_script.R
\name{CompareTrophies}
\alias{CompareTrophies}
\title{Compare Trophies Between Two Players}
\usage{
CompareTrophies(player_id_1, player_id_2, api_key)
}
\arguments{
\item{player_id_1}{The ID of the first player.}

\item{player_id_2}{The ID of the second player.}

\item{api_key}{The API key used for making the API call.}
}
\value{
A ggplot object visualizing the number of trophies won by each player.
}
\description{
Compares the number of trophies won by two players. This function can operate
with actual API calls.
}
\examples{
CompareTrophies("player1_id", "player2_id", "mock_api_key")
}
