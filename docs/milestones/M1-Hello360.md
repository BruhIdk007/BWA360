# M1 — Hello360

**Status: COMPLETE**  
**Completed:** 2026-09-15  
**Release:** v0.0.1 — Toolchain Bring-up

## Objective

Prove the complete native Xbox 360 guest-code pipeline before any LexEngine subsystem work begins:

```text
C
→ OpenXeChain Clang
→ PowerPC COFF
→ Xbox 360 PE
→ SynthXEX
→ XEX2
→ Xenia
→ xboxkrnl!DbgPrint
```

Required guest marker:

```text
HELLO360: LexEngine bring-up successful!
```

## Completion checklist

### Toolchain

- [x] OpenXeChain located at `/opt/openxechain/sysroot` on the validation host.
- [x] Clang target accepted as canonical Xbox 360 PPC: `ppc32-unknown-xbox360`.
- [x] `llvm-readobj`, `llvm-objdump` and `synthxex` available.

### Compilation / PE

- [x] `hello360.c` compiles to 32-bit PowerPC COFF.
- [x] Machine ID is `0x01F2`.
- [x] PE is executable and 32-bit.
- [x] Optional-header magic is PE32 `0x10B`.
- [x] Subsystem is Xbox `0x0E`.
- [x] Image base is `0x82000000`.
- [x] Entry RVA is `0x10000`.
- [x] `DbgPrint` import resolves to ordinal `3`.

### XEX

- [x] SynthXEX builds `default.xex`.
- [x] Container begins with `XEX2`.
- [x] Xenia-compatible DOS-header normalization applied before packaging.
- [x] Function import contains type-0 IAT record.
- [x] Function import contains type-1 thunk record.

### Runtime

- [x] Xenia loads the module.
- [x] Xenia maps code/RODATA sections.
- [x] Main guest XThread launches.
- [x] `xboxkrnl!DbgPrint` is reported implemented.
- [x] Guest marker observed.

## Final validated import pair

```text
Library: xboxkrnl.exe
Ordinal: 3 (DbgPrint)

Type 0 / IAT:
  0x8202006C

Type 1 / function thunk:
  0x82010054
```

## Final runtime evidence

```text
i> F8000008 (DbgPrint) HELLO360: LexEngine bring-up successful!
```

## Important discoveries

### Xenia DOS-header compatibility

LLD produced:

```text
4D 5A 78 00
```

The current Xenia sanity path used during M1 required:

```text
4D 5A 90 00
```

M1 normalizes only the DOS `e_cblp` field before SynthXEX packaging. The PowerPC code, PE section layout, imports and entry point are unchanged.

### SynthXEX v0.0.5 function-import metadata

The unmodified SynthXEX build emitted only the type-0 IAT record for `DbgPrint`:

```text
imports: 1
0x8202006C → type 0 → ordinal 3
```

The LLD-generated executable also contained a branch stub:

```asm
82010054: lis   r11, 0x8202
82010058: lwz   r11, 0x6c(r11)
8201005c: mtctr r11
82010060: bctr
```

XEX function-import metadata must also describe that executable thunk as type 1. After the local source remediation:

```text
imports: 2
0x8202006C → type 0 → ordinal 3
0x82010054 → type 1 → ordinal 3
```

Xenia then successfully resolved and executed `DbgPrint`.

## Reference build hash

One successful M1 XEX produced:

```text
bfc4403684adbf01d9864bc1cb134a7f016e4e292d3e46f5ff7a01c729672da0  default.xex
```

This is **evidence**, not a reproducible-build contract: PE/XEX timestamps can change the final hash between otherwise-equivalent builds.

## Definition of Done

**Satisfied.** M1 is closed and M2 is active.
