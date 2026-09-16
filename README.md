# BWA360 / LexEngine

**BWA360** is an independent source-reconstruction and preservation-oriented project that aims to rebuild **Bookworm Adventures** as a native Xbox 360 title on top of a purpose-built C/C++ runtime called **LexEngine**.

The project has two strict layers:

- **Classic Mode** — reconstruct original Bookworm Adventures behavior, balance, data flow and presentation as faithfully as practical.
- **Enhanced / Collection layers** — optional modern systems built on top of the reconstructed game without silently changing Classic gameplay.

The long-term collection plan includes native LexEngine modules for **Bookworm Adventures Volume 2** and **Bookworm Deluxe**. A later **LexMod SDK** will expose supported extension points for external mods; its reference showcase, **LexMath**, will replace word challenges with child-friendly arithmetic questions while reusing the same engine/combat pipeline. Post-mainline research targets also include **LexAR 360** (Xbox 360 + Kinect augmented-reality presentation), **LexVR Research** (portable VR plus Xbox 360 stereo/head-tracking experiments), **M45 Multiplayer & Challenge Modes**, **M46 Lexicon Pad**, **M47 Secret Avatar Room**, **M48 Lexicon Portal & Smart-Tile Ecosystem**, **M49 Oracle Trials & Advanced Gameplay Rule Lab**, and **M50 NeuroLex / BCI Research**.

> **Current state:** M1 — Hello360 is complete. Native PowerPC guest code produced with OpenXeChain has been packaged as XEX2, loaded by Xenia, and has successfully called `xboxkrnl!DbgPrint`.

## Current milestone

**M2 — LexEngine Platform Bring-up**

M2 turns the M1 proof-of-life into the first reusable Xbox 360 platform layer: entry/runtime structure, logging/asserts, timing, memory, filesystem access, controller input, visible rendering and an audio probe.

See:

- [`STATUS.md`](STATUS.md)
- [`ROADMAP.md`](ROADMAP.md)
- [`RELEASES.md`](RELEASES.md)
- [`docs/milestones/M1-Hello360.md`](docs/milestones/M1-Hello360.md)
- [`docs/milestones/M2-LexEngine-Platform-Bringup.md`](docs/milestones/M2-LexEngine-Platform-Bringup.md)

## M1 proof of life

The validated path is:

```text
hello360.c
    ↓
OpenXeChain Clang 20.1.5
Target: ppc32-unknown-xbox360
    ↓
PowerPC COFF / Machine 0x01F2
    ↓
Xbox PE32 / subsystem 0x0E
    ↓
SynthXEX
    ↓
XEX2
    ↓
Xenia
    ↓
xboxkrnl!DbgPrint
    ↓
HELLO360: LexEngine bring-up successful!
```

M1 uncovered and documented two bring-up compatibility problems:

1. Current Xenia's initial executable check expected the DOS header prefix `4D 5A 90 00`; LLD emitted `4D 5A 78 00`. The M1 build normalizes the DOS `e_cblp` field before XEX packaging.
2. SynthXEX v0.0.5 emitted only the type-0 IAT import record for imported functions and omitted the type-1 executable thunk record. A local source patch reconstructs the missing thunk metadata. With the corrected pair, Xenia resolves `DbgPrint` and guest execution succeeds.

Full technical notes are in [`docs/toolchain/M1-OpenXeChain-Xenia-Bringup.md`](docs/toolchain/M1-OpenXeChain-Xenia-Bringup.md).

## Architecture direction

```text
Original Bookworm Adventures.exe (x86 / Windows)
                   ↓
       RE + behavioral analysis
                   ↓
       reconstructed game C++
                   ↓
              LexEngine
       ┌───────────┼───────────┐
       ↓           ↓           ↓
     Linux       Windows    Xbox 360
                              ↓
                         OpenXeChain
                              ↓
                             XEX2
```

Core rules:

- recover first, reinvent second;
- Classic gameplay remains isolated from Enhanced adaptation;
- simulation and presentation are separate;
- determinism is a first-class engineering constraint;
- real Xbox 360 hardware is the eventual authority; Xenia is the rapid-iteration environment;
- proprietary game assets and original executables never belong in Git.

## Repository layout

```text
BWA360/
├── README.md
├── STATUS.md
├── ROADMAP.md
├── RELEASES.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── docs/
│   ├── architecture/
│   ├── evidence/
│   ├── milestones/
│   ├── repository/
│   ├── references/
│   └── toolchain/
├── patches/
│   └── synthxex/
├── tests/
│   └── hello360/
└── tools/
    └── m1/
```

Generated `.obj`, `.exe`, `.xex`, `.basefile`, logs, diagnostics and proprietary game data are intentionally ignored.

## Long-term modding direction

The roadmap separates modding into two milestones:

- **M39 — LexMod SDK Foundation:** manifests, packaging, safe loading, versioned APIs and gameplay/content extension points.
- **M42 — LexMod SDK Showcase: LexMath:** a complete educational arithmetic conversion built through the public SDK.

LexMath is intentionally more than a cosmetic content pack. It is the architecture test that LexEngine can support a different challenge domain without hard-coding a second game into the engine. Classic Bookworm gameplay remains word-based and unchanged.

Conceptually:

```text
Classic BWA  → Word rule provider       → ChallengeResult
LexMath      → Arithmetic rule provider → ChallengeResult
                                           ↓
                               combat / progression / VFX
```

The exact API will be designed later; M2 must remain a small platform bring-up and should not prematurely implement the modding layer.

## Long-term AR/VR research direction

Two post-mainline milestones extend the same simulation/presentation separation:

- **M43 — LexAR 360:** Xbox 360 + Kinect is the primary experimental target. Camera/depth/pose input feeds an AR presentation backend while gameplay simulation remains unchanged.
- **M44 — LexVR Research:** a portable VR backend for suitable host hardware plus Xbox 360 research into stereo rendering, Kinect-derived head/pose tracking and optional PC/HMD bridge experiments.

Neither milestone expands M2 scope. M2 should only establish clean platform, input, timing and presentation boundaries that do not prevent future AR/VR backends.

## Long-term multiplayer and challenge direction

**M45 — Multiplayer & Challenge Modes** adds a reusable session/game-mode layer for both **Co-op and Versus**, first locally and then through supported network transports. Planned families include Word Duel, shared/parallel-board Co-op, Boss Raid, Hot Potato, LexMath Duel and optional Kinect asymmetric play. Selected rules also gain solo counterparts such as Time Bomb, Boss Raid Solo and Ghost Challenge.

The network architecture is transport-independent. Xbox 360 work prioritizes local play and LAN/System Link-style connectivity, with Aurora LiNK compatibility investigated where applicable. A separate **Xbox Live / Xbox Network research backend** may investigate native session creation, discovery/matchmaking, host/join, invites and presence where those facilities are legitimately and technically available to the tested environment. It is a stretch/research transport, not a requirement for M45 completion. Stealth/anti-ban services and platform-enforcement bypasses are not engine dependencies.

Earlier deterministic replay/snapshot work can support networking, but the project explicitly does **not** equate rewind with finished rollback netcode: rollback requires fixed ticks, input history/prediction, resimulation, state hashes and careful presentation reconciliation.

## Long-term custom controller direction

**M46 — Lexicon Pad Custom Controller** is a dedicated hardware project for BWA360/LexEngine after the software ecosystem is mature. The goal is a wired-first Xbox 360 controller optimized for word construction, LexMath and the project's later challenge/multiplayer systems.

The initial design direction combines:

- a compact mechanical alphabet key matrix for direct letter entry;
- a numeric/operator layer for LexMath;
- standard navigation/game controls so menus and encounters remain practical;
- dedicated `Submit`, `Undo`, `Clear`, `Shuffle` and configurable action keys;
- rumble/status feedback;
- an optional analog control intended for future rewind/time-manipulation mechanics;
- firmware-side remapping/profiles and a capability-based `LexInputDevice` integration.

Lexicon Pad is **optional hardware**, not a compatibility requirement. Standard Xbox 360 controllers, host keyboard/gamepad input and other supported devices must remain first-class paths. Xbox 360 device/authentication details must be validated on real hardware; M46 may use a compliant/donor interface or another documented legal hardware path rather than making protocol-enforcement bypasses part of LexEngine.


## Final post-mainline ecosystem milestones

The roadmap closes at **M50** with four capability-gated projects that deliberately remain optional:

- **M47 — Secret Avatar Room:** research the Xbox 360 Avatar/profile ecosystem and, where supported by the validated runtime, place the signed-in player's Avatar inside the 3D Library Hub and multiplayer lobby scenes. A fallback character path is mandatory.
- **M48 — Lexicon Portal & Smart-Tile Ecosystem:** tangible NFC/RFID letter/number/operator tiles and figurines, connected through a documented bridge/device layer. Tags identify content; normal save storage remains authoritative.
- **M49 — Oracle Trials & Advanced Gameplay Rule Lab:** semantic word-combo strings, deterministic environmental grid hazards, anagram shields and curated advanced challenge-rule combinations. These are optional rulesets, not Classic changes.
- **M50 — NeuroLex / BCI Research:** non-invasive EEG/BCI experiments that translate classifier output into coarse `LexInputDevice` actions, preferably through a host bridge. It is an accessibility/research input path, not a "mind-reading" requirement.

These milestones complete the conceptual roadmap without expanding M2. They all reuse boundaries established earlier: presentation services, profile/capability services, `LexInputDevice`, deterministic challenge/rule providers and host/platform bridges.

## Community research and inspiration

For creature/enemy inspiration, terminology and general Bookworm Adventures research, the project will also consult the community-maintained **Bookworm Adventures Wikia / Fandom**:

https://bookwormadvs.fandom.com/wiki/Bookworm_Adventures_Wikia

It is worth visiting directly as a community knowledge base, and BWA360 should link back to it rather than mirror its material. The wiki is a discovery/inspiration source, not executable-level authority: Classic reconstruction claims are still verified against original game behavior, binaries/data, traces and reproducible tests. See [`docs/references/COMMUNITY-REFERENCES.md`](docs/references/COMMUNITY-REFERENCES.md).

## Legal / preservation boundary

This project is independent and is not affiliated with or endorsed by PopCap Games, Electronic Arts, Microsoft or the Xenia/OpenXeChain projects.

Do **not** commit or redistribute original Bookworm executables, `main.pak`, music, textures, fonts or other proprietary game content. Import/verification tooling should operate on files supplied by the user from their own copy.

The project-wide source license has intentionally not been selected in this snapshot. Select one before accepting outside contributions. Modifications derived from SynthXEX must continue to respect SynthXEX's upstream license terms; see [`docs/repository/LICENSING.md`](docs/repository/LICENSING.md).

## Repository metadata

Recommended GitHub description:

> Native Xbox 360 source-reconstruction of Bookworm Adventures, powered by LexEngine and OpenXeChain. Classic fidelity first; enhanced systems optional.

Recommended topics:

`xbox360` · `homebrew` · `powerpc` · `openxechain` · `xenia` · `reverse-engineering` · `cpp` · `game-engine` · `game-preservation`

## Canonical M1 evidence

The final runtime proof is preserved in [`docs/evidence/M1-final-runtime.txt`](docs/evidence/M1-final-runtime.txt). The clean-history bootstrap procedure is documented in [`docs/repository/FRESH-REPOSITORY-RESET.md`](docs/repository/FRESH-REPOSITORY-RESET.md).
