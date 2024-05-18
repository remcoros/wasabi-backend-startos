#!/bin/sh

echo
echo "Initialising Wasabi Backend..."
echo

cd /app
dotnet WalletWasabi.Backend.dll
