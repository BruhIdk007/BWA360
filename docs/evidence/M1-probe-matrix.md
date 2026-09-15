# M1 Import Isolation Probe Matrix

| Probe | Key behavior | Imports | `Invalid handling of constant` | Interpretation |
|---|---|---:|---:|---|
| Original | `DbgPrint` via normal header | 1 function | Yes | Failure reproduced |
| No-import loop | stack + load/store + branch + `nop` | 0 | No | Generic guest PPC path works |
| A | `crclr 6` loop | 0 | No | `crclr` is not the trigger |
| B | local indirect call via `mtctr` / `bctrl` | 0 | No | CTR/indirect call path works |
| C | deliberately non-variadic `DbgPrint` | 1 function | Yes | varargs ABI is not the root cause |
| D | variadic `DbgPrint` | 1 function | Yes | imported function path remains common factor |
| Corrected XEX | `DbgPrint` with type-0 + type-1 records | 1 function / 2 records | No | `DbgPrint` succeeds |

## Probe B representative disassembly

```asm
lis   r3, ...
addi  r3, r3, ...
lwz   r3, ...
mtctr r3
bctrl
```

The absence of the warning here was important because it ruled out the generic `mtctr/bctrl` translation path.

## Corrected import metadata

```text
[0] address=0x8202006C value=0x00000003 type=0 ordinal=3
[1] address=0x82010054 value=0x01000003 type=1 ordinal=3
```
