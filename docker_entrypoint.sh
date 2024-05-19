#!/bin/sh

echo
echo "Initialising Wasabi Backend..."

if [ ! -f /root/.walletwasabi/backend/Config.json ]; then
  echo "No Wasabi config file found, creating default"
  mkdir -p /root/.walletwasabi/backend/
  cp /defaults/Config.json /root/.walletwasabi/backend/Config.json
fi
if [ ! -f /root/.walletwasabi/backend/WabiSabiConfig.json ]; then
  echo "No WabiSabi config file found, creating default"
  mkdir -p /root/.walletwasabi/backend/
  cp /defaults/WabiSabiConfig.json /root/.walletwasabi/backend/WabiSabiConfig.json
fi

echo "- Configuring Wasabi Backend for your Bitcoin node"

# remove UTF8 BOM character, because yq does not like this
sed -i '1s/^\xEF\xBB\xBF//' /root/.walletwasabi/backend/Config.json
sed -i '1s/^\xEF\xBB\xBF//' /root/.walletwasabi/backend/WabiSabiConfig.json

BITCOIND_USER=$(yq e '.bitcoinrpcuser' /root/start9/config.yaml)
BITCOIND_PASS=$(yq e '.bitcoinrpcpassword' /root/start9/config.yaml)

yq e -i "
  .MainNetBitcoinP2pEndPoint = \"bitcoind.embassy:8333\" |
  .MainNetBitcoinCoreRpcEndPoint = \"bitcoind.embassy:8332\" |
  .BitcoinRpcConnectionString = \"$BITCOIND_USER:$BITCOIND_PASS\"" -o=json /root/.walletwasabi/backend/Config.json

if [ $(yq e '.enablecoordinator' /root/start9/config.yaml) = "true" ]; then
  coordinatorExtPubKey=$(yq e '.coordinator.coordinatorExtPubKey' /root/start9/config.yaml)
  coordinatorExtPubKeyCurrentDepth=$(yq e '.coordinator.coordinatorExtPubKeyCurrentDepth' /root/start9/config.yaml)
  coordinationFeeRate=$(yq e '.coordinator.coordinationFeeRate' /root/start9/config.yaml)
  plebsDontPayThreshold=$(yq e '.coordinator.plebsDontPayThreshold' /root/start9/config.yaml)
  standardInputRegistrationTimeout=$(yq e '.coordinator.standardInputRegistrationTimeout' /root/start9/config.yaml)
  maxInputCountByRound=$(yq e '.coordinator.maxInputCountByRound' /root/start9/config.yaml)
  minInputCountByRoundMultiplier=$(yq e '.coordinator.minInputCountByRoundMultiplier' /root/start9/config.yaml)
  minInputCountByBlameRoundMultiplier=$(yq e '.coordinator.minInputCountByBlameRoundMultiplier' /root/start9/config.yaml)

  yq e -i "
    .CoordinatorExtPubKey = \"$coordinatorExtPubKey\" |
    .CoordinatorExtPubKeyCurrentDepth = $coordinatorExtPubKeyCurrentDepth |
    .CoordinationFeeRate.Rate = $coordinationFeeRate |
    .CoordinationFeeRate.PlebsDontPayThreshold = $plebsDontPayThreshold |
    .StandardInputRegistrationTimeout = \"$standardInputRegistrationTimeout\" |
    .MaxInputCountByRound = $maxInputCountByRound |
    .MinInputCountByRoundMultiplier = $minInputCountByRoundMultiplier |
    .MinInputCountByBlameRoundMultiplier = $minInputCountByBlameRoundMultiplier |
    .IsCoordinationEnabled = true" -o=json /root/.walletwasabi/backend/WabiSabiConfig.json
  echo "- Enabled Coordinator"
else
  yq e -i ".IsCoordinationEnabled = false" -o=json /root/.walletwasabi/backend/WabiSabiConfig.json
  echo "- Disabled Coordinator"
fi

WEBAPI_TOR_ADDRESS="$(yq e '.webapi-tor-address' /root/start9/config.yaml)"
WEBAPI_ADDRESS=${WEBAPI_TOR_ADDRESS%".onion"}.local

cat << EOF >>/root/start9/stats.yaml
  "Web API Url (Tor)":
    type: string
    value: "http://$WEBAPI_TOR_ADDRESS"
    description: "Web API Url (Tor)"
    copyable: true
    qr: false
    masked: false
  "Web API Url (LAN)":
    type: string
    value: "https://$WEBAPI_ADDRESS"
    description: "Web API Url (LAN)"
    copyable: true
    qr: false
    masked: false
EOF

# yq /root/.walletwasabi/backend/WabiSabiConfig.json -o json

echo
echo "Starting Wasabi Backend..."

cd /app
dotnet WalletWasabi.Backend.dll
