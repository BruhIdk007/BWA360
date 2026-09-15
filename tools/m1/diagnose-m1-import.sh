#!/usr/bin/env bash
set -uo pipefail
OX="${OX:-/opt/openxechain/sysroot}"
XENIA="${XENIA:-}"
OUT="$PWD/diagnostics-import"
SRC="$PWD/hello360.c"
mkdir -p "$OUT"
BACKUP="$OUT/hello360.original.c"
[[ -n "$XENIA" && -x "$XENIA" ]] || { echo 'ERROR: export XENIA=/path/to/xenia_canary'; exit 1; }
cp "$SRC" "$BACKUP"
restore(){ cp "$BACKUP" "$SRC"; }
kill_xenia(){ pkill -9 -f "$XENIA" 2>/dev/null || true; }
trap 'kill_xenia; restore' EXIT INT TERM
run_probe(){
  local name="$1" marker="$2"
  ./build.sh >"$OUT/$name-build.log" 2>&1 || { cat "$OUT/$name-build.log"; return 1; }
  "$OX/bin/llvm-objdump" -d --section=.text hello360.exe >"$OUT/$name-disasm.txt"
  set +e
  timeout --signal=TERM --kill-after=2s 6s "$XENIA" --log_file=stdout "$PWD/default.xex" >"$OUT/$name-xenia.log" 2>&1
  local status=$?
  set -e
  kill_xenia
  local bad=0 found=0
  grep -Fq 'Invalid handling of constant' "$OUT/$name-xenia.log" && bad=1
  [[ -n "$marker" ]] && grep -Fq "$marker" "$OUT/$name-xenia.log" && found=1
  printf '%s,%s,%s,%s\n' "$name" "$status" "$bad" "$found" >>"$OUT/results.csv"
}
echo 'probe,status,invalid_constant,marker_found' >"$OUT/results.csv"
cat >"$SRC" <<'C'
__attribute__((noreturn)) int main(void){for(;;){__asm__ volatile("crclr 6");__asm__ volatile("nop");}}
C
run_probe probe-a-crclr ''
cat >"$SRC" <<'C'
__attribute__((noinline)) static void local_target(void){__asm__ volatile("nop");}
__attribute__((noreturn)) int main(void){void (*volatile target)(void)=local_target;for(;;){target();}}
C
run_probe probe-b-local-ctr ''
cat >"$SRC" <<'C'
extern void DbgPrint(const char *text);
__attribute__((noreturn)) int main(void){DbgPrint("HELLO360_NONVAR: DbgPrint import works!\n");for(;;){__asm__ volatile("nop");}}
C
run_probe probe-c-dbgprint-nonvar 'HELLO360_NONVAR: DbgPrint import works!'
cat >"$SRC" <<'C'
extern void DbgPrint(const char *format, ...);
__attribute__((noreturn)) int main(void){DbgPrint("PROBE_VARARG: DbgPrint variadic call works!\n");for(;;){__asm__ volatile("nop");}}
C
run_probe probe-d-dbgprint-vararg 'PROBE_VARARG: DbgPrint variadic call works!'
restore
./build.sh >/dev/null
cat "$OUT/results.csv"
