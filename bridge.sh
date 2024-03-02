#!/bin/bash

OS=$(uname -s)
ARCH=$(uname -m)
case $OS in
    "Darwin")
        case $ARCH in
            "arm64") BINARY_POSTFIX="darwin-arm64" ;;
            "x86_64") BINARY_POSTFIX="darwin-amd64" ;;
            *) echo "Unsupported architecture"; exit 1 ;;
        esac
        ;;
    "Linux")
        case $ARCH in
            "arm64") BINARY_POSTFIX="linux-arm64" ;;
            "x86_64") BINARY_POSTFIX="linux-amd64" ;;
            *) echo "Unsupported architecture"; exit 1 ;;
        esac
        ;;
    *)
        echo "Unsupported operating system"
        exit 1
        ;;
esac

FILE="mev-commit-bridge-user-cli-${BINARY_POSTFIX}.tar.gz"
MEV_COMMIT_BRIDGE_VERISON="v0.0.7"
BASE_URL="https://github.com/primevprotocol/mev-commit-bridge/releases/download/$MEV_COMMIT_BRIDGE_VERISON"
curl -f -s -L "${BASE_URL}/${FILE}" -o "${FILE}"
if [ ! -f "${FILE}" ]; then
    echo "Failed to download the file."
    exit 1
fi
echo "Downloaded ${FILE}. Extracting..."  
tar -xzf "${FILE}" -C ./

export PRIVATE_KEY="0xe82a054e06f89598485134b4f2ce8a612ce7f7f7e14e650f9f20b30efddd0e57"
export LOG_LEVEL="debug"
export L1_RPC_URL="https://ethereum-holesky.publicnode.com"
export SETTLEMENT_RPC_URL="https://chainrpc.testnet.mev-commit.xyz"
export L1_CHAIN_ID="17000"
export SETTLEMENT_CHAIN_ID="17864"
export L1_CONTRACT_ADDR="0xceff0a364f63f621ff6a8b5ce56569ec6f3c6220"
export SETTLEMENT_CONTRACT_ADDR="0xf60f8e762a3fe90fd4d8c005872b6f6e12eda8ca"

BIN_NAME="user-cli-${BINARY_POSTFIX}"
./$BIN_NAME bridge-to-settlement --amount 62 --dest-addr "0xd9cd8E5DE6d55f796D980B818D350C0746C25b97" --cancel-pending
./$BIN_NAME bridge-to-l1 --amount 31 --dest-addr "0x3f5CE5FBFe3E9af3971dD833D26bA9b5C936f0bE" --cancel-pending
