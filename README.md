# DATA 534 API Wrapper Project with Football RAPID-API
![R CI](https://github.com/shaytran/DATA534_Project_Group8/actions/workflows/r.yaml/badge.svg)

## Table of Contents 📜
- [About footwrap](#footwrap)
  - [Usage](#usage)
  - [Features](#features)
  - [Our Functions (a concise overview)](#our-functions-a-concise-overview)
  - [Contributing](#contributing)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)

# footwrap

`footwrap` is an R package designed to facilitate easy access to football data through the RAPID-API. It serves as an API wrapper, simplifying the process of fetching detailed information on football leagues, teams, fixtures, player statistics, and much more. Whether you're an enthusiast looking to analyze your favorite league, or a data scientist seeking to perform comprehensive football data analyses, `footwrap` provides the necessary tools to gather the data you need. We understand that one of the most challenging parts of the data analytics and model building process is the data wrangling. Thus, as a tool made by data scientsts for data scientists, we hope that you will see the ease of use of our `footwrap` and its potential as a key pipelining tool in the football analytics and model creation process.

## Usage

The package is publically available and so you will need to install in R appropriately using `remotes::install_github("shaytran/footwrap@package-installation")`. Additionally, before using `footwrap`, ensure you have obtained an API key from RAPID-API. This key is essential for making requests and accessing the wealth of football data available. Once you obtain your API key, you can either save it as a variable inside of your developing environment, or save it to your global environment using:
1. For Mac/Linux Users: `export variable_name=variable_value`
2. For Windows Users: `[Environment]::SetEnvironmentVariable('variable_name', 'variable_value', 'User')`

Here's a simple example to get you started. Note that more detailed information can be found below or in our vignettes on each of our functions and how to use them:

```r
# downloading package
# install.packages(remotes) # if you do not have remotes installed yet 
library(remotes)
remotes::install_github("shaytran/footwrap@package-installation")

# load footwarap package
library(footwrap)

your_api_key <- 'your key'

# Fetch top scorers from the Premier League for the 2020 season
topScorers <- getTopScorers(39, 2020, "your_api_key")
print(topScorers)
```
In this situation, you are saving a dataframe of a league's top scorers for a given season and printing the values from the dataframe. 

## Features

- **Comprehensive Data Access**: Fetch data on top scorers, assist providers, fixtures, standings, and team transfers with ease.
- **User-Friendly**: Designed with simplicity in mind, enabling users to access complex data through straightforward R functions.
- **Customizable Queries**: Tailor your data retrieval to specific leagues, seasons, and teams, according to your analytical needs.
- **Wrangled Data**: Data is presented in a wrangled state ready for any data analysis, predictie modelling, or machine learning techniques you wish to employ.

## Our Functions (a concise overview)

All of our functions are currently built on top of Rapid-API. Thus, this is a reminder that you will need to obtain a Rapid-API key to use these functions.

**1. Get Largest Venues by Country**

Use `GetBiggestVenues` to retrieve and visualize the largest venues in a given country.
```{r}
# Example: Get the 5 largest venues in England using mock data
GetBiggestVenues("England", 5, "<your_api_key>")
```

**2. Get Coach Information**

Fetch information about a team's coach with `GetCoachInfo`.
```{r}
# Example: Get coach information for a team using mock data
GetCoachInfo("team_id_example", "<your_api_key>")
```

**3. Compare Trophies Between Two Players**

Compare the number of trophies won by two players with `CompareTrophies`.
```{r}
# Example: Compare trophies between two players using mock data
CompareTrophies("player1_id", "player2_id", "<your_api_key>")
```

**4. Retrieve Team Statistics**

Access detailed team statistics for a specific league and season with `getTeamStatistics`.
```{r}
# Example: Retrieve statistics for Manchester United for the 2019 season
getTeamStatistics(39, 2019, "Manchester United", "<your_api_key>")
```

**5. Search Player Information**

Search for detailed information about a player by name and team with `searchPlayer`.
```{r}
# Example: Search for information about Ronaldo playing for Juventus
searchPlayer(name = "Ronaldo", team = "Juventus", apikey = "<your_api_key>")
```

**6. Retrieving Top Scorers**

`getTopScorers` provides an easy way to access the top scorers of any given league and season.
```{r}
# Example: Top Scorers in the Premier League for the 2020 Season
topScorers <- getTopScorers(39, 2020, "<your_api_key>")
```

**7. Fetching Top Assist Providers **

Similarly, `getTopAssists` focuses on the creative talents in the league, fetching data about players who provided the most assists.
```{r}
#Example: Premier League Top Assists in 2020
topAssists <- getTopAssists(39, 2020, "<your_api_key>")
```

**8. Accessing Football Fixtures**

With `getFootballFixtures`, users can retrieve detailed fixture lists for leagues, including match venues, dates, and scores, enabling fans and analysts to keep track of upcoming and past matches.

```{r}
# Example: Fetching Fixtures for the Premier League
fixtures <- getFootballFixtures(39, 2020, "<your_api_key>")
```

**9. Examining League Standings**

`getFootballStandings` offers a comprehensive view of the standings in any given league and season, providing insights into team performances, points, and rankings.
```{r}
# Example: Viewing Premier League Standings for 2020
standings <- getFootballStandings(39, 2020, "<your_api_key>")
```

**10. Analyzing Team Transfers **

Lastly, `getTeamTransfers` delves into the transfer market, offering data on player movements across teams, which is crucial for understanding team strategies and player careers.
```{r}
# Example: Checking Transfers for Manchester United
transfers <- getTeamTransfers(33, "<your_api_key>")
```

**11. Retrieve Player Statistics**

Utilize `getPlayerStatistics` to obtain an in-depth analysis of a player's performance across various metrics for a specified season, presented in a detailed gt table format.
```{r}
# Example: Retrieve statistics for a player (ID: 276) for the 2019 season
getPlayerStatistics(276, 2019, "<your_api_key>")
```

**12. Retrieve League Information by Name**

Use `getLeagueInfo` to effortlessly access details about any football league, including its ID and relevant attributes, by specifying its name, showcased in a concise dataframe format.

```{r}
# Example: Retrieve information about the Premier League
getLeagueInfo("Premier League", "<your_api_key>")
```

We are always working towards expanding the number of callable functions and potentially are looking into more applied features for predictive modelling or machine learning functions.

## Contributing

We welcome contributions to `footwrap`! Whether it's adding new features, fixing bugs, or improving documentation, your help is appreciated. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests to us.

## Code of Conduct

Participation in the `footwrap` project is governed by our `Code of Conduct`. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) to understand what actions will and will not be tolerated.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.

## Acknowledgments

- Thanks to RAPID-API for providing the football data API.
- Appreciation to all contributors who have helped in building and refining the `footwrap` package.
