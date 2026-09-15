#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="${1:-$(pwd)/tests/hello360}"
XENIA="${XENIA:-}"

if [[ -z "$XENIA" ]]; then
    echo "ERROR: set XENIA=/path/to/xenia_canary"
    exit 1
fi

cd "$TEST_DIR"
./build.sh

LOG="m1-verify.log"
set +e
timeout --signal=TERM --kill-after=2s 8s \
    "$XENIA" --log_file=stdout "$PWD/default.xex" >"$LOG" 2>&1
status=$?
set -e

echo "Xenia bounded-run status: $status"

if grep -Fq 'HELLO360: LexEngine bring-up successful!' "$LOG"; then
    grep -F 'HELLO360: LexEngine bring-up successful!' "$LOG"
    echo "M1 VERIFIED"
    rm -f "$LOG"
    exit 0
fi

echo "M1 FAILED: marker not found"
tail -80 "$LOG"
exit 1
