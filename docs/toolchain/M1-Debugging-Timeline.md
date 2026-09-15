# M1 Debugging Timeline

This is the condensed technical history of the M1 bring-up. It preserves the reasoning trail so future work does not repeat the same investigations.

## 1. Toolchain location mismatch

Early scripts assumed a user-local OpenXeChain installation. The actual validated installation was:

```text
/opt/openxechain/sysroot
```

Clang reported:

```text
ppc32-unknown-xbox360
```

The validation logic was updated to accept both the short and canonicalized target spelling rather than requiring only `ppc32-xbox360`.

## 2. First successful PE/XEX build

`hello360.c` compiled and linked successfully. The final PE showed:

```text
Machine: 0x1F2
Magic: 0x10B
ImageBase: 0x82000000
Subsystem: IMAGE_SUBSYSTEM_XBOX (0xE)
```

SynthXEX accepted the PE and generated a valid `XEX2` container.

## 3. Xenia rejected the first XEX with load code 3

The PE was otherwise valid. The DOS header began:

```text
4D 5A 78 00
```

The M1 Xenia path expected:

```text
4D 5A 90 00
```

Normalizing DOS `e_cblp` before SynthXEX packaging allowed Xenia to load the module and launch the guest thread.

## 4. Guest launch reached a new warning

After the loader issue was fixed, Xenia reached:

```text
KernelState: Launching module...
Main XThread
```

but the original `DbgPrint` test emitted:

```text
reg - Invalid handling of constant! Report this to developers!
```

## 5. No-import isolation probe

A minimal infinite loop with no imports ran without the warning.

Conclusion:

- XEX loader works;
- guest entry works;
- basic generated PPC works;
- stack/load/store/branch operations are not the root cause;
- imported-call path is implicated.

## 6. Import-path test matrix

### Probe A — `crclr 6` only

Result: **no warning**.

This excluded the condition-register instruction used by variadic PPC calls.

### Probe B — local indirect `mtctr` / `bctrl`

Result: **no warning**.

This excluded generic indirect-call/CTR translation.

### Probe C — deliberately non-variadic `DbgPrint`

Result: **warning reproduced**.

This excluded varargs ABI setup as the root cause.

### Probe D — normal variadic `DbgPrint`

Result: **warning reproduced**.

The common factor was therefore the Xbox kernel import path.

## 7. XEX import metadata inspection

The linked PE contained:

```text
DbgPrint ordinal: 3
IAT: 0x8202006C
```

and an LLD-generated executable stub:

```asm
82010054: lis   r11, 0x8202
82010058: lwz   r11, 0x6c(r11)
8201005c: mtctr r11
82010060: bctr
```

But the generated XEX described only:

```text
imports: 1
0x8202006C → type 0 → ordinal 3
```

The type-1 function thunk record was absent.

## 8. SynthXEX source finding

SynthXEX's own data-storage comment described the desired address sequence as the IAT entry followed by branch-stub address for functions, but the v0.0.5 optional-header generation path only populated IAT addresses.

## 9. M1 remediation

The local source change:

- tracks ordinal and thunk address per PE import;
- locates the OpenXeChain/LLD import stub matching the concrete IAT address;
- rewrites the first thunk word as a type-1 XEX import descriptor;
- emits both IAT and thunk addresses in the XEX import library table.

Corrected result:

```text
imports: 2
0x8202006C → type 0 → ordinal 3
0x82010054 → type 1 → ordinal 3
```

## 10. Final success

Xenia then emitted:

```text
i> F8000008 (DbgPrint) HELLO360: LexEngine bring-up successful!
```

M1 was closed and M2 became active.
