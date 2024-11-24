#!/bin/bash

# Check if a coin symbol is provided
if [ -z "$1" ]; then
    set -- "BTC"
fi

COIN_SYMBOL=$(echo "$1" | tr '[:lower:]' '[:upper:]')
API_URL="https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"

# Make API request
response=$(curl -s -H "X-CMC_PRO_API_KEY: $CMC_PRO_API_KEY" -H "Accept: application/json" \
    -G "$API_URL" --data-urlencode "symbol=$COIN_SYMBOL")

# Extract price using jq
price=$(echo "$response" | jq -r ".data.$COIN_SYMBOL.quote.USD.price")
percent_change_24h=$(echo "$response" | jq -r ".data.$COIN_SYMBOL.quote.USD.percent_change_24h")

# Check if the price was successfully retrieved
if [ "$price" == "null" ] || [ "$percent_change_24h" == "null" ]; then
    echo "Failed to retrieve data for $COIN_SYMBOL. Check the symbol or API key."
    exit 1
fi

LC_NUMERIC="en_US.UTF-8"

if (( $(echo "$price >= 1" | bc -l) )); then
    # Price >= 0.01: Show 2 decimal places
    formatted_price=$(printf "%.2f" "$price")
else
    # Price < 0.01: Show 6 decimal places
    formatted_price=$(printf "%.6f" "$price")
fi

if (( $(echo "$percent_change_24h >= 0" | bc -l) )); then
    # Positive change: green color
    formatted_change="\033[32m+$(printf "%.2f" "$percent_change_24h")%\033[0m"
else
    # Negative change: red color
    formatted_change="\033[31m$(printf "%.2f" "$percent_change_24h")%\033[0m"
fi

# Print the price and percentage change
echo -e "The current price of $COIN_SYMBOL is \$${formatted_price} ${formatted_change}"