# Changelog

All notable project-level milestones are recorded here.

## [Unreleased]

### Planned

- Renamed M39 to **LexMod SDK Foundation** and clarified support for public gameplay/content extension points.
- Added **M42 — LexMod SDK Showcase: LexMath**, an educational arithmetic conversion used as the final integration test and reference project for the public modding API.
- Added a long-term architecture requirement that engine extension boundaries remain content-agnostic while Classic BWA remains strictly word-faithful.
- Added **M43 — LexAR 360**, an Xbox 360 + Kinect augmented-reality research/showcase target built as a presentation/input backend.
- Added **M44 — LexVR Research**, covering portable VR plus Xbox 360 stereoscopic/head-tracking and optional bridge research without making HMD support a core console requirement.
- Clarified that future AR/VR work must preserve simulation/presentation separation and must not expand M2 scope.
- Added **M45 — Multiplayer & Challenge Modes**, covering local/network Co-op and Versus, Boss Raid, Hot Potato, LexMath multiplayer, optional Kinect asymmetric play and reusable solo challenge variants.
- Defined Xbox networking priority as local + LAN/System Link first, with Aurora LiNK compatibility research where applicable and an optional Xbox Live/Xbox Network session backend as a separate research tier.
- Kept Xbox Live research transport-independent and non-mandatory: no multiplayer feature may require stealth/anti-ban services or platform-enforcement bypasses.
- Clarified that M21 rewind/snapshots are useful rollback primitives but full rollback requires separate fixed-tick, prediction, resimulation, checksum and side-effect-reconciliation work.
- Added **M46 — Lexicon Pad Custom Controller**, a wired-first purpose-built BWA360/LexEngine controller with mechanical alphabet entry, LexMath number/operator controls, dedicated gameplay actions, optional analog rewind control, firmware profiles and haptic/status feedback.
- Defined M46 around a capability-driven `LexInputDevice` boundary so stock Xbox controllers, host input, Kinect and mixed-device M45 multiplayer remain supported.
- Required real-hardware validation of the Xbox 360 device/interface path without making platform-enforcement bypasses or redistributed proprietary firmware project dependencies.

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
