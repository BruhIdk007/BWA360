#!/usr/bin/env bash
set -euo pipefail

XENIA="${XENIA:-}"

if [[ -z "$XENIA" ]]; then
    echo "ERROR: set XENIA to the native Xenia Canary executable."
    echo
    echo "Example:"
    echo '  export XENIA=/path/to/xenia_canary'
    exit 1
fi

if [[ ! -x "$XENIA" ]]; then
    echo "ERROR: Xenia executable not found: $XENIA"
    exit 1
fi

if [[ ! -f default.xex ]]; then
    echo "ERROR: default.xex missing; run ./build.sh first"
    exit 1
fi

echo "Using Xenia:"
echo "$XENIA"
echo

exec "$XENIA" --log_file=stdout "$PWD/default.xex"
