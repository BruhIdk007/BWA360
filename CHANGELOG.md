# Changelog

All notable project-level milestones are recorded here.

## [Unreleased]

### Planned

- Renamed M39 to **LexMod SDK Foundation** and clarified support for public gameplay/content extension points.
- Added **M42 — LexMod SDK Showcase: LexMath**, an educational arithmetic conversion used as the final integration test and reference project for the public modding API.
- Added a long-term architecture requirement that engine extension boundaries remain content-agnostic while Classic BWA remains strictly word-faithful.

## [0.0.1] — Toolchain Bring-up — 2026-09-15

### Added

- Initial BWA360 / LexEngine repository structure.
- OpenXeChain PowerPC/Xbox 360 bring-up test.
- `hello360.c` guest program using `xboxkrnl!DbgPrint`.
- Xbox PE and XEX2 validation scripts.
- M1 evidence and toolchain postmortem documentation.
- Local SynthXEX function-import thunk remediation tooling.

### Validated

- OpenXeChain target: `ppc32-unknown-xbox360`.
- PE machine: `0x01F2`.
- PE format: PE32 / Xbox subsystem `0x0E`.
- XEX load address: `0x82000000`.
- Entry point: `0x82010000`.
- `DbgPrint` ordinal: `3`.
- Correct XEX import pair:
  - type 0 IAT record at `0x8202006C`;
  - type 1 function thunk record at `0x82010054`.
- Xenia guest output:

  ```text
  i> F8000008 (DbgPrint) HELLO360: LexEngine bring-up successful!
  ```

### Fixed / worked around

- Normalized LLD's DOS `e_cblp` field so the PE passes the current Xenia executable sanity check.
- Identified SynthXEX v0.0.5 omission of type-1 function thunk records and produced an M1 source-level remediation.

### Known issues

- Linux Xenia currently uses Mesa `llvmpipe` instead of the physical Vulkan GPU.
- The current SynthXEX remediation discovers LLD import thunks from their machine-code pattern; this is sufficient for M1 but should be replaced by authoritative linker/import metadata before being treated as an upstream-quality general solution.
