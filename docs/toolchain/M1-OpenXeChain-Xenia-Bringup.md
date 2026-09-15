# M1 OpenXeChain / SynthXEX / Xenia Bring-up Notes

This document records the validated M1 environment and the failures encountered while reaching native guest execution.

## Validation environment

```text
OpenXeChain sysroot: /opt/openxechain/sysroot
Clang: 20.1.5
Clang target: ppc32-unknown-xbox360
SynthXEX: v0.0.5
Xenia: native Linux Canary build
```

Host-specific user paths are not required by the repository scripts; use environment variables instead.

## Known-good PE characteristics

```text
Machine: 0x1F2
IMAGE_FILE_EXECUTABLE_IMAGE
IMAGE_FILE_32BIT_MACHINE
Magic: 0x10B
ImageBase: 0x82000000
AddressOfEntryPoint: 0x10000
Subsystem: IMAGE_SUBSYSTEM_XBOX (0xE)
SectionAlignment: 65536
FileAlignment: 512
```

## Failure 1 — Xenia XEX load code 3

The generated PE was structurally valid, but Xenia rejected the reconstructed image before execution.

The LLD DOS header started:

```text
4d 5a 78 00
```

M1 normalized bytes 2–3 to:

```text
4d 5a 90 00
```

After repackaging, Xenia successfully loaded and launched the module.

This is treated as an emulator/toolchain compatibility normalization rather than a semantic PE-code change.

## Failure 2 — `reg - Invalid handling of constant!`

After XEX loading succeeded, the original `DbgPrint` test produced:

```text
reg - Invalid handling of constant! Report this to developers!
```

Isolation tests proved:

- basic PowerPC execution works;
- stack access works;
- `crclr 6` works;
- local `mtctr/bctrl` indirect calls work;
- removing all imports removes the warning;
- both variadic and deliberately non-variadic `DbgPrint` declarations reproduce the warning.

Therefore the problem was in imported-function resolution rather than generic PPC translation or varargs ABI handling.

## Root cause — missing XEX function thunk record

Original SynthXEX output:

```text
Library #0: xboxkrnl.exe
imports: 1
[0] address=0x8202006C type=0 ordinal=3
```

But the linked PE contained this import branch stub:

```asm
82010054: 3d 60 82 02   lis   11, -32254
82010058: 81 6b 00 6c   lwz   11, 108(11)
8201005c: 7d 69 03 a6   mtctr 11
82010060: 4e 80 04 20   bctr
```

The patched XEX metadata became:

```text
Library #0: xboxkrnl.exe
imports: 2
[0] address=0x8202006C value=0x00000003 type=0 ordinal=3
[1] address=0x82010054 value=0x01000003 type=1 ordinal=3
```

After that correction:

```text
i> F8000008 (DbgPrint) HELLO360: LexEngine bring-up successful!
```

## M1 patch quality note

The current M1 remediation detects the four-instruction LLD import thunk pattern in the mapped basefile and creates type-1 records from it. This is intentionally a bring-up solution.

Before treating it as a general/upstream solution, replace heuristic machine-code discovery with authoritative linker/import metadata or otherwise prove compatibility across multiple function imports, modules and data imports.
