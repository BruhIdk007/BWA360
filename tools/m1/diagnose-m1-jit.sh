#!/usr/bin/env bash
set -uo pipefail

OX="${OX:-/opt/openxechain/sysroot}"
XENIA_ROOT="${XENIA_ROOT:-${HOME}/tools/xenia}"
XENIA="${XENIA:-$XENIA_ROOT/build/bin/Linux/Release/xenia_canary}"
DIAG_DIR="$PWD/diagnostics"
ORIGINAL_SOURCE="$PWD/hello360.c"
BACKUP_SOURCE="$DIAG_DIR/hello360.original.c"
mkdir -p "$DIAG_DIR"

section(){ echo; echo "============================================================"; echo "$1"; echo "============================================================"; }
restore_source(){ [[ -f "$BACKUP_SOURCE" ]] && cp "$BACKUP_SOURCE" "$ORIGINAL_SOURCE"; }
kill_xenia(){ pkill -9 -f "$XENIA" 2>/dev/null || true; }
cleanup(){ kill_xenia; restore_source; }
trap cleanup EXIT INT TERM

section "Environment"
for tool in clang llvm-objdump llvm-readobj synthxex; do
  [[ -x "$OX/bin/$tool" ]] || { echo "ERROR: missing $OX/bin/$tool"; exit 1; }
done
[[ -x "$XENIA" ]] || { echo "ERROR: Xenia missing: $XENIA"; exit 1; }
[[ -f "$ORIGINAL_SOURCE" ]] || { echo "ERROR: hello360.c missing"; exit 1; }
"$OX/bin/clang" -dumpmachine
cp "$ORIGINAL_SOURCE" "$BACKUP_SOURCE"

section "Original build"
restore_source
./build.sh 2>&1 | tee "$DIAG_DIR/original-build.log"
"$OX/bin/llvm-objdump" -d --section=.text hello360.exe | tee "$DIAG_DIR/original-disassembly.txt"

section "Original Xenia run"
set +e
timeout --signal=TERM --kill-after=2s 8s "$XENIA" --log_file=stdout "$PWD/default.xex" > "$DIAG_DIR/original-xenia.log" 2>&1
ORIGINAL_STATUS=$?
set -e
kill_xenia

grep -E 'Loading module|Launching module|Main XThread|HELLO360|Invalid handling|unimplemented|exception|assert|trap' "$DIAG_DIR/original-xenia.log" || true

section "Minimal no-import probe"
cat > "$ORIGINAL_SOURCE" <<'C'
__attribute__((noreturn))
int main(void)
{
    volatile unsigned int counter = 0;
    for (;;) {
        counter++;
        __asm__ volatile("nop");
    }
}
C
./build.sh 2>&1 | tee "$DIAG_DIR/probe-build.log"
"$OX/bin/llvm-objdump" -d --section=.text hello360.exe | tee "$DIAG_DIR/probe-disassembly.txt"
set +e
timeout --signal=TERM --kill-after=2s 8s "$XENIA" --log_file=stdout "$PWD/default.xex" > "$DIAG_DIR/probe-xenia.log" 2>&1
PROBE_STATUS=$?
set -e
kill_xenia

grep -E 'Loading module|Launching module|Main XThread|Invalid handling|unimplemented|exception|assert|trap' "$DIAG_DIR/probe-xenia.log" || true

section "Result"
printf 'Original status: %s\n' "$ORIGINAL_STATUS"
printf 'Probe status:    %s\n' "$PROBE_STATUS"
printf 'Original invalid-constant: '; grep -Fc 'Invalid handling of constant' "$DIAG_DIR/original-xenia.log" || true
printf 'Probe invalid-constant:    '; grep -Fc 'Invalid handling of constant' "$DIAG_DIR/probe-xenia.log" || true
printf 'HELLO360:                  '; grep -Fc 'HELLO360: LexEngine bring-up successful!' "$DIAG_DIR/original-xenia.log" || true
restore_source
./build.sh >/dev/null
