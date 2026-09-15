#!/usr/bin/env bash
set -euo pipefail

OX="${OX:-/opt/openxechain/sysroot}"
SYNTHXEX="${SYNTHXEX:-$OX/bin/synthxex}"

unset C_INCLUDE_PATH || true
unset CPLUS_INCLUDE_PATH || true
unset LIBRARY_PATH || true

for tool in clang llvm-readobj; do
    if [[ ! -x "$OX/bin/$tool" ]]; then
        echo "ERROR: missing $OX/bin/$tool"
        exit 1
    fi
done

if [[ ! -x "$SYNTHXEX" ]]; then
    echo "ERROR: missing SynthXEX: $SYNTHXEX"
    exit 1
fi

echo "[0/7] Target"
"$OX/bin/clang" -dumpmachine

rm -f hello360.obj hello360.exe default.xex default.xex.basefile

echo
echo "[1/7] Compile PowerPC object"
"$OX/bin/clang" -c hello360.c -o hello360.obj

echo
echo "[2/7] Inspect PowerPC object"
"$OX/bin/llvm-readobj" --file-headers hello360.obj

echo
echo "[3/7] Link Xbox 360 PE"
"$OX/bin/clang" \
    hello360.obj \
    -Wl,/entry:main \
    -Wl,/subsystem:xbox360 \
    -Wl,/base:0x82000000 \
    -o hello360.exe

echo
echo "[4/7] Normalize DOS header for current Xenia compatibility"

echo "Before:"
xxd -l 4 hello360.exe

# Current M1 validation required MZ 90 00 rather than LLD's MZ 78 00.
# Only DOS e_cblp is changed; executable code/PE layout are untouched.
printf '\x90\x00' | \
    dd of=hello360.exe bs=1 seek=2 count=2 conv=notrunc status=none

echo "After:"
xxd -l 4 hello360.exe

if [[ "$(xxd -p -l 4 hello360.exe)" != "4d5a9000" ]]; then
    echo "ERROR: DOS-header normalization failed"
    exit 1
fi

echo
echo "[5/7] Inspect final Xbox PE"
"$OX/bin/llvm-readobj" \
    --file-headers \
    --coff-imports \
    hello360.exe

echo
echo "[6/7] Build XEX2"
"$SYNTHXEX" -i hello360.exe -o default.xex -t title

echo
echo "[7/7] Validate XEX2"

if [[ "$(head -c 4 default.xex)" != "XEX2" ]]; then
    echo "ERROR: expected XEX2 magic"
    exit 1
fi

if [[ ! -f default.xex.basefile ]]; then
    echo "ERROR: SynthXEX basefile was not generated"
    exit 1
fi

if [[ "$(xxd -p -l 4 default.xex.basefile)" != "4d5a9000" ]]; then
    echo "ERROR: basefile does not contain normalized PE header"
    exit 1
fi

echo
echo "SUCCESS: default.xex created"
sha256sum default.xex
