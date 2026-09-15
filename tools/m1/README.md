# M1 tooling

These scripts preserve the bring-up/debugging path that led to the first successful native Xbox 360 guest call.

- `verify-m1.sh` — bounded Xenia regression test; succeeds only when the HELLO360 marker is observed.
- `inspect-import-layout.sh` — parses PE/XEX import metadata and displays type-0/type-1 records.
- `diagnose-m1-jit.sh` — compares the original DbgPrint build with a no-import PowerPC probe.
- `diagnose-m1-import.sh` — isolates CRCLR, local CTR calls and imported DbgPrint behavior.

Set `OX`, `SYNTHXEX`, and `XENIA` in the environment rather than hard-coding machine-specific paths.
