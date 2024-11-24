# CMC Price Script

This project is a simple Bash script that retrieves the current price and 24-hour percentage change of a specified cryptocurrency using the CoinMarketCap API.

## Prerequisites

- Bash
- `curl`
- `jq`
- `bc`

## Setup

1. Clone the repository or download the [`cmc-price.sh`](cmc-price.sh) script.
2. Obtain an API key from [CoinMarketCap](https://pro.coinmarketcap.com/signup).
3. Set the `CMC_PRO_API_KEY` environment variable with your API key:
    ```sh
    export CMC_PRO_API_KEY="your_api_key_here"
    ```

## Usage

Run the script with the desired cryptocurrency symbol as an argument. If no symbol is provided, it defaults to `BTC`.

[cmc-price.sh](cmc-price.sh) [COIN_SYMBOL]

### Examples

- To get the price of Bitcoin (default):
    ```sh
    ./cmc-price.sh
    ```

- To get the price of Ethereum:
    ```sh
    ./cmc-price.sh ETH
    ```

## Output

The script will output the current price and 24-hour percentage change of the specified cryptocurrency. Positive changes are displayed in green, and negative changes are displayed in red.

### Example Output

````
The current price of BTC is $45000.00 +2.34%
````

## License

This project is licensed under the MIT License. See the LICENSE file for details.