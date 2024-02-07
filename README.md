# DATA 534 API Wrapper Project with Football RAPID-API
[![R CI](.github/workflows/r.yaml)

# footwrap

`footwrap` is an R package designed to facilitate easy access to football data through the RAPID-API. It serves as an API wrapper, simplifying the process of fetching detailed information on football leagues, teams, fixtures, player statistics, and much more. Whether you're an enthusiast looking to analyze your favorite league, or a data scientist seeking to perform comprehensive football data analyses, `footwrap` provides the necessary tools to gather the data you need.

## Usage

Before using `footwrap`, ensure you have obtained an API key from RAPID-API. This key is essential for making requests and accessing the wealth of football data available.

Here's a simple example to get you started:

```r
library(footwrap)

# Fetch top scorers from the Premier League for the 2020 season
topScorers <- getTopScorers(39, 2020, "your_api_key")
print(topScorers)
```

## Features

- **Comprehensive Data Access**: Fetch data on top scorers, assist providers, fixtures, standings, and team transfers with ease.
- **User-Friendly**: Designed with simplicity in mind, enabling users to access complex data through straightforward R functions.
- **Customizable Queries**: Tailor your data retrieval to specific leagues, seasons, and teams, according to your analytical needs.

## Contributing

We welcome contributions to `footwrap`! Whether it's adding new features, fixing bugs, or improving documentation, your help is appreciated. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests to us.

## Code of Conduct

Participation in the `footwrap` project is governed by our `Code of Conduct`. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) to understand what actions will and will not be tolerated.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.

## Acknowledgments

- Thanks to RAPID-API for providing the football data API.
- Appreciation to all contributors who have helped in building and refining the `footwrap` package.
