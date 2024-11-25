#!/bin/bash

# Check if at least one coin symbol is provided
if [ $# -eq 0 ]; then
    set -- "BTC" # Default to BTC if no arguments are provided
fi

# Join all symbols into a comma-separated string
symbols=$(IFS=','; echo "$*")

API_URL="https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"

# Make a single API request for all symbols
response=$(curl -s -H "X-CMC_PRO_API_KEY: $CMC_PRO_API_KEY" -H "Accept: application/json" \
    -G "$API_URL" --data-urlencode "symbol=$symbols")

# Process each symbol
for symbol in "$@"; do
    COIN_SYMBOL=$(echo "$symbol" | tr '[:lower:]' '[:upper:]')

    # Extract price and 24h percentage change using jq
    price=$(echo "$response" | jq -r ".data.$COIN_SYMBOL.quote.USD.price")
    percent_change_24h=$(echo "$response" | jq -r ".data.$COIN_SYMBOL.quote.USD.percent_change_24h")

    # Check if the price was successfully retrieved
    if [ "$price" == "null" ] || [ "$percent_change_24h" == "null" ]; then
        echo "Failed to retrieve data for $COIN_SYMBOL. Check the symbol or API key."
        continue
    fi

    LC_NUMERIC="en_US.UTF-8"

    # Format price based on value
    if (( $(echo "$price >= 1" | bc -l) )); then
        formatted_price=$(printf "%.2f" "$price")
    else
        formatted_price=$(printf "%.6f" "$price")
    fi

    # Format percentage change with color
    if (( $(echo "$percent_change_24h >= 0" | bc -l) )); then
        # Positive change: green color
        formatted_change="\033[32m+$(printf "%.2f" "$percent_change_24h")%\033[0m"
    else
        # Negative change: red color
        formatted_change="\033[31m$(printf "%.2f" "$percent_change_24h")%\033[0m"
    fi

    # Print the price and percentage change
    echo -e "The current price of $COIN_SYMBOL is \$${formatted_price} ${formatted_change}"
done