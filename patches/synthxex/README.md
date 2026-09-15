# SynthXEX M1 Function-Thunk Remediation

## Why this exists

During M1, SynthXEX v0.0.5 converted the PE IAT entry into a type-0 XEX import record but did not also expose the LLD-generated executable import thunk as a type-1 record.

For `xboxkrnl!DbgPrint` the validated addresses were:

```text
IAT:   0x8202006C → type 0 → ordinal 3
Thunk: 0x82010054 → type 1 → ordinal 3
```

Without the type-1 record, Xenia reached guest execution but failed on the imported call path. With the corrected pair, the guest `DbgPrint` call succeeded.

## Current M1 remediation

The local M1 source modification:

1. stores each import ordinal;
2. scans the mapped PE/basefile for the LLD four-instruction function stub matching the concrete IAT address;
3. writes a type-1 import descriptor at the thunk RVA;
4. adds the thunk address to the XEX import-library address array after the type-0 IAT address.

Pattern observed from OpenXeChain/LLD:

```asm
lis   r11, IAT@ha
lwz   r11, IAT@l(r11)
mtctr r11
bctr
```

## Important limitation

This is an M1 bring-up remediation, not yet an upstream-quality general solution. Before relying on it broadly:

- test several imported functions;
- test multiple import libraries;
- distinguish function and data imports without heuristic scanning;
- replace pattern scanning with authoritative linker/import metadata where possible;
- validate on real Xbox 360 hardware.

## Distribution

Do not commit a patched SynthXEX binary. Commit source patches or reproducible transformation scripts and preserve upstream licensing requirements.

## Reproduction helper

`apply-m1-function-thunk-fix.sh` reproduces the validated M1 remediation against the local SynthXEX source checkout. It intentionally builds a separate `build-m1-import-thunks/` binary rather than overwriting the installed toolchain binary.
