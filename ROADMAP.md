# BWA360 / LexEngine — Master Roadmap

This file is the canonical high-level roadmap for the project.

## Status convention

- `[ ]` Planned / not complete
- `[x]` Complete
- Detailed work for the active milestone lives in `docs/milestones/`.
- A milestone is checked only when its **Definition of Done** has been met.
- Features may move between milestones as implementation evidence changes, but removals or major scope changes should be documented in commit history.

---

# Master Milestone Checklist

## Foundation, reconstruction and Classic Edition

- [x] **M1 — Hello360**
  - OpenXeChain/LLVM PowerPC bring-up, Xbox PE, SynthXEX, XEX2, Xenia debug execution.
  - **DoD:** `HELLO360: LexEngine bring-up successful!` is emitted from guest code and captured in the Xenia log.

- [ ] **M2 — LexEngine Platform Bring-up**
  - Minimal Xbox 360 platform layer: timing, memory basics, filesystem probe, controller input, basic visible output, font/text experiment, audio probe.
  - Establish platform interfaces rather than game-specific code.
  - **DoD:** one interactive Xbox 360 demo accepts controller input, renders visible content, plays one sound and reads one packaged file.

- [ ] **M3 — Golden Bookworm Reference**
  - Identify exact Bookworm Adventures build.
  - SHA-256 fingerprints for executable and `main.pak`.
  - Reproducible Wine launch, runtime notes and reference captures.
  - Preserve original files read-only outside Git.
  - **DoD:** original build can be reproduced and identified unambiguously.

- [ ] **M4 — Reverse-Engineering Map**
  - PE layout, imports, entry path, CRT, compiler clues, strings/XREFs, globals, RTTI, vtables, constructors/destructors and subsystem boundaries.
  - Build address/symbol/confidence database.
  - **DoD:** startup path and major subsystems are mapped with documented confidence.

- [ ] **M5 — SexyApp/PopCap Framework Reconstruction**
  - Identify the framework lineage against available public SexyApp/PopCap sources.
  - Reconstruct only what BWA needs: application, widgets, resources, images, fonts, audio abstractions, filesystem, timing.
  - **DoD:** minimal reconstructed framework boots on host PC.

- [ ] **M6 — Bookworm Core Source Recovery**
  - Recover/reimplement with evidence: BookwormApp, Board, Tile, Dictionary, Player, Enemy, Battle, Treasure, Books/Chapters and progression.
  - Preserve recovered OOP/class layout where it matters.
  - **DoD:** one complete battle runs in the reconstructed host build.

- [ ] **M7 — Behavioral Parity Framework**
  - Deterministic RNG abstraction.
  - Differential tests against original behavior where observable.
  - Golden-state tests for board generation, scoring, damage, statuses and enemy turns.
  - **DoD:** reference battle/state sequences match expected original behavior.

- [ ] **M8 — Original Data, Resources and Scripting**
  - `main.pak` reader/importer.
  - XML/properties, fonts, images, sounds, dictionary and Lua/custom bytecode research.
  - Explicit endian-safe readers.
  - **DoD:** reconstructed host build uses original data from a user-owned installation.

- [ ] **M9 — Portable Game Core**
  - Remove Win32 assumptions from game logic.
  - Platform API: renderer, audio, input, filesystem, storage, timer.
  - Event bus, command input layer and deterministic simulation/presentation split.
  - **DoD:** same game core runs on Linux and Windows host targets.

- [ ] **M10 — Xbox 360 Backend**
  - PowerPC portability and endianness.
  - Xbox renderer/audio/input/storage/time/memory backends.
  - Memory arenas, pools, handles and profiling hooks.
  - **DoD:** original BWA title/menu scene appears through the Xbox 360 build in Xenia.

- [ ] **M11 — First Native Xbox 360 Battle**
  - Board interaction, dictionary lookup, word submission, enemy turn, audio, rumble and VFX on Xbox backend.
  - **DoD:** a complete original-style battle is playable in Xenia and then verified on real modified hardware.

- [ ] **M12 — Full Classic Campaign**
  - Books, chapters, enemies, bosses, treasures, progression, cutscenes, saves and all required original mechanics.
  - **DoD:** Adventure Mode is completable end-to-end on Xbox 360.

- [ ] **M13 — Xbox Profiles, Saves and Achievements**
  - Versioned/atomic saves.
  - Local profile research and title metadata.
  - Achievement database, local notification path, XDBF/GPD/XAM research.
  - Goal: achievements visible in local Xbox/Xenia profile without pretending to be an official Xbox Live release.
  - **DoD:** stable saves and the best-supported local profile/achievement integration demonstrated on target environments.

- [ ] **M14 — BWA360 Classic Edition 1.0**
  - Controller UX, stability, importer, documentation, regression suite, packaging strategy, real-hardware validation.
  - **DoD:** stable Classic Edition release, completable on Xenia and real modified Xbox 360 hardware.

---

## Enhanced graphics, presentation and engine technology

- [ ] **M15 — Diegetic 3D Library Hub**
  - Fully navigable 3D library.
  - Physical BWA1 book, BWA2 crystal book, Deluxe arcade cabinet, achievement shelf, settings objects, Lexicon/Chronicle areas.
  - Scene graph, camera system and streaming hooks.
  - **DoD:** hub is navigable, responsive and maintains target frame pacing on real hardware.

- [ ] **M16 — Enhanced Renderer**
  - Primary hardware target: 720p / 60 FPS where achievable without compromising gameplay.
  - Specialized materials, normal maps, baked GI/light probes, selective dynamic lights, shadows, parallax, fog slices, light shafts, reflections, bloom, color grading, LOD, culling and adaptive quality.
  - Stable 16.67 ms frame pacing is more important than maximum effect count.
  - **DoD:** representative enhanced arena remains inside agreed memory/frame budgets on hardware.

- [ ] **M17 — Material System and Typographic VFX**
  - Stone, paper, gold, crystal, ice, fire, ink, glass and magic materials.
  - High-value tiles receive micro-bevel/normal/AO/material treatment.
  - Semantic word categories drive thematic VFX.
  - Long/high-value words may extrude into 3D word geometry for cinematic attacks.
  - **DoD:** material/VFX language is coherent and data-driven rather than hardcoded per word.

- [ ] **M18 — Dynamic Arenas and Controlled Destruction**
  - Stateful arena damage.
  - Prepared destruction chunks rather than uncontrolled heavy simulation.
  - Weather/day-state transitions and boss-phase environment changes.
  - **DoD:** environment meaningfully changes during a full battle without destabilizing performance.

- [ ] **M19 — 3.5D Book Physics**
  - Depth/elevation/layer data for tiles and game presentation.
  - Raised/recessed/floating tiles, page folds, curls, tears, burns/freezes and page portals.
  - Optional perspective puzzle accessibility bypass.
  - **DoD:** at least one production-quality battle uses Z-depth as a real mechanic while preserving word-game readability.

- [ ] **M20 — Impossible Spaces and Recursive Books**
  - Portal cameras, render-to-texture, recursive book illusion, Escher-like library spaces and selective non-Euclidean tricks.
  - **DoD:** one polished impossible-space sequence works at stable frame pacing.

---

## Deterministic time systems and “4D” gameplay

- [ ] **M21 — Replay / Snapshot / Rewind Core**
  - Command log, deterministic RNG, ring-buffer snapshots, replay files and state hashes.
  - Rewind restores board, HP, statuses, enemy state and RNG coherently.
  - Same system supports QA, TAS-like debugging and bug reproduction.
  - **DoD:** a battle can rewind at least three turns and deterministic replay reproduces the same outcome.

- [ ] **M22 — Temporal and 4D Gameplay**
  - Time echoes, temporal tiles, branch/parallel states and past/present/future mechanics.
  - Real mathematical 4D projection experiments (e.g. tesseract guardian using x/y/z/w and 4D rotation planes).
  - **DoD:** at least one boss/puzzle uses temporal state and one uses genuine projected 4D geometry.

---

## Audio, haptics and cinematic systems

- [ ] **M23 — Modern Audio Engine**
  - Mixer buses: master/music/SFX/UI/ambient/voice/magic.
  - Adaptive music stems, smooth transitions, spatial audio, reverb zones, per-letter tonal feedback and controlled reversed audio for rewind.
  - **DoD:** music and ambience adapt continuously to gameplay without audible cuts or streaming instability.

- [ ] **M24 — Haptics and Cinematic Director**
  - Contextual dual-motor rumble vocabulary.
  - Camera director selects close-up/orbit/dolly/slow-motion patterns based on damage, word value, boss phase and events.
  - Presentation director may adapt music/camera/VFX to tension, but not secretly change Classic gameplay.
  - **DoD:** strong attacks produce varied, readable and non-repetitive presentation.

- [ ] **M25 — Streaming and Internal Quick Resume**
  - Async/preload pipeline.
  - Small game-state snapshots for switching between hub/BWA1/BWA2/Deluxe modules.
  - Shader/material prewarming where relevant.
  - **DoD:** switching modules feels near-instant on real hardware within a measured target budget.

---

## Machine learning, NLP and adaptive intelligence

- [ ] **M26 — LexMind Player Model**
  - Local telemetry: word length, decision time, rare letters, failed attempts, damage efficiency, treasures, suffix/prefix habits and enemy difficulty.
  - Train models on PC with Python; inference is tiny native C++ on Xbox.
  - Prefer interpretable models or small neural nets when justified.
  - **DoD:** player model demonstrably adapts to behavior and persists per profile.

- [ ] **M27 — Smart Hints and Adaptive Bosses**
  - Deterministic solver/Trie finds legal words.
  - ML ranks hints; ML never decides word legality.
  - Utility AI/contextual adaptation counters player habits in Enhanced Mode only.
  - **DoD:** hints and at least one boss adapt measurably to different play styles.

- [ ] **M28 — Personal Lexicon and Analytics**
  - Vocabulary history, mastery, rare-letter usage, average word length, timing and progression trends.
  - Offline challenges based on real player behavior.
  - **DoD:** persistent local dashboard provides useful and reproducible statistics.

- [ ] **M29 — Chronicle NLG / Lex Academy**
  - Event graph + deterministic grammar/template NLG.
  - Personal chronicle generated from real battles/words.
  - Educational/lexicon mode and optional offline daily challenge seeds.
  - **DoD:** two meaningfully different playthroughs produce different coherent chronicles.

---

## Enhanced story and meta-systems

- [ ] **M30 — Enhanced Meta-Campaign: The Unwritten**
  - Optional post-Classic meta-story.
  - Library corruption, altered pages, controlled UI deception, timeline anomalies and hidden boss content.
  - Simulated “system failure” moments must never manipulate thermal controls, damage hardware, delete real saves or create unsafe system behavior.
  - **DoD:** complete optional meta-campaign with safe recovery/save guarantees.

---

## Collection expansion content

- [ ] **M31 — Bookworm Deluxe Native 360 Module**
  - No XeFu dependency.
  - Recover/reimplement Deluxe gameplay on shared LexEngine.
  - Classic 2D mode plus Retro Vault presentation: 3D arcade cabinet, CRT curvature, scanlines, phosphor-like persistence, cabinet audio and rumble.
  - **DoD:** Deluxe is fully playable as native PowerPC/Xbox 360 content.

- [ ] **M32 — Bookworm Adventures Volume 2 Native Module**
  - Binary/data diff against BWA1 to maximize shared-engine reuse.
  - Recover BWA2-specific logic, content, enemies, campaigns and data-format differences.
  - **DoD:** Volume 2 is fully playable through LexEngine.

- [ ] **M33 — Collection Content/DLC Architecture**
  - One base collection/title architecture with discoverable BWA2 and Deluxe content packs.
  - Packaging must follow what is technically possible on modified Xbox 360 hardware; do not claim official Microsoft/Xbox Live publication.
  - **DoD:** base game detects and exposes installed content packs reliably.

- [ ] **M34 — Collection Achievement Set**
  - Target design: ~40 achievements / 1000G-style local collection set, subject to proven local-profile capabilities.
  - Achievements cover BWA1, BWA2, Deluxe, Enhanced/secret systems and LexMind.
  - **DoD:** final local achievement implementation and presentation are consistent across supported target environments.

---

## Accessibility, diagnostics, preservation and community tooling

- [ ] **M35 — Accessibility and Modern UX**
  - Color-blind modes, high contrast, scalable fonts/UI, reduced motion/flashes, one-handed mappings, remapping, hint strength, flat/Classic presentation alternatives.
  - **DoD:** all required Classic gameplay can be completed with the supported accessibility profiles.

- [ ] **M36 — Photo Mode, Museum and LexEngine Room**
  - Photo/free-camera mode where feasible.
  - Museum documenting original-vs-reconstructed systems.
  - Diegetic engine room displaying FPS, memory, render stats, RNG, state and LexMind telemetry.
  - **DoD:** preservation/debug material is accessible without contaminating normal gameplay.

- [ ] **M37 — Security Hardening and Fuzzing**
  - ASan/UBSan host builds.
  - libFuzzer/AFL++ targets for PAK/save/XML/script/dictionary/content parsers.
  - Path traversal prevention, strict bounds checks, checksums and malformed-file handling.
  - **DoD:** defined fuzz corpora pass agreed soak testing without known critical parser crashes.

- [ ] **M38 — Developer Toolchain**
  - `bwa-pak`, resource inspector, replay viewer, state diff, symbol DB, function matcher, achievement generator, content validator/packager and RE scripts.
  - **DoD:** clean host setup can reproduce the documented analysis/build pipeline.

- [ ] **M39 — LexMod SDK Foundation**
  - Data-driven custom books, enemies, treasures, dictionaries, arenas, scripts and gameplay rule providers.
  - Safe mod discovery/loading, manifests, packaging and a versioned public API.
  - Extension points must allow custom challenge/content logic without requiring engine-source changes.
  - **DoD:** an external sample mod can be built, packaged and loaded without changing engine source.

- [ ] **M40 — Kinect Research Branch**
  - Optional/post-release only.
  - Research air selection, gestures and pose/voice interactions if homebrew access proves practical.
  - Must never block core releases.
  - **DoD:** only considered complete if stable on real hardware; otherwise documented as experimental/non-shipping.

- [ ] **M41 — Ultimate Collection Finalization**
  - Cross-module polish, profiling, adaptive quality, frame pacing, benchmark mode/boss, crash diagnostics, documentation and final real-hardware soak testing.
  - **DoD:** production-quality collection release meeting final performance/stability/preservation criteria.

- [ ] **M42 — LexMod SDK Showcase: LexMath**
  - Build a complete educational arithmetic conversion primarily through the public LexMod SDK, not by hard-coding a special mode into LexEngine.
  - Replace word-building challenges with number/operator challenges in which the player selects the correct result of an arithmetic expression.
  - Initial exercise families: addition, subtraction, multiplication, division, missing-number equations and comparisons (`<`, `>`, `=`).
  - Support age/difficulty profiles, timed and untimed play, configurable distractors, educational feedback and progression.
  - Reuse the normal combat/progression/presentation pipeline through a generic challenge-result contract so the engine does not need to know whether a correct answer came from a word or a calculation.
  - Example: `7 + 5 = ?` with `[10] [12] [14] [15]`; selecting `12` produces a successful challenge result.
  - Ship the mod as the reference/template project for third-party LexMod development.
  - **DoD:** LexMath builds and loads as an external mod, completes a representative campaign/battle loop on host targets and Xbox 360, and requires no private engine hooks beyond the documented LexMod API.

- [ ] **M43 — LexAR 360**
  - Experimental/post-mainline augmented-reality presentation with **Xbox 360 + Kinect as the primary target**.
  - Capture the player/environment camera feed and composite LexEngine content over it on the TV.
  - Research Kinect RGB/depth/skeleton access through the homebrew toolchain and isolate it behind a platform/input abstraction.
  - Support spatially presented tiles, enemies, effects and world-space UI without moving gameplay rules into the AR backend.
  - Provide gesture/hand-selection experiments where technically reliable; controller fallback remains valid.
  - Build at least one complete AR battle and a LexMath AR demonstration.
  - AR must be a presentation/input backend: simulation, combat, progression and challenge validation remain presentation-independent.
  - **DoD:** a complete representative encounter runs in an Xbox 360/Kinect AR presentation on real hardware if practical; otherwise the exact hardware/toolchain blocker is documented and the portable AR backend is demonstrated on a supported host target.

- [ ] **M44 — LexVR Research**
  - Experimental/post-mainline VR research; **do not make modern HMD support a core Xbox 360 requirement**.
  - First Xbox 360 research tier: stereoscopic rendering, head-tracked camera experiments and Kinect-derived pose input where feasible.
  - Investigate a bridge architecture in which a PC/OpenXR-class host handles modern headset I/O while LexEngine/Xbox 360 can remain responsible for simulation and selected rendering experiments.
  - Add a portable VR presentation/input backend with stereo views, head pose abstraction, world-space UI and spatial tile interaction.
  - Include comfort requirements: stable horizon/UI anchors, minimal forced acceleration, configurable interaction distance, seated mode and standing mode.
  - Build one complete VR battle and a LexMath VR demonstration on an appropriate VR-capable target.
  - VR remains a frontend/backend layer; no core simulation code may depend on HMD APIs.
  - **DoD:** the portable LexVR backend completes a representative battle on a VR-capable target, while Xbox 360-specific stereo/head-tracking research is either demonstrated or documented with reproducible limitations.

- [ ] **M45 — Multiplayer & Challenge Modes**
  - Add reusable local and network session/game-mode infrastructure supporting **Co-op and Versus** without duplicating the core simulation.
  - Local targets: Word Duel, shared-board/parallel-board Co-op, small-team play and party modes such as Hot Potato.
  - Network targets: LAN/System Link-style transport first, Aurora LiNK compatibility research where applicable, plus portable replaceable direct/relay transports for host builds.
  - Add an optional **Xbox Live / Xbox Network research backend** for native-style session create/find/join/leave, matchmaking/discovery, invites and presence where those facilities are legitimately and technically available; failure/limitations must be documented rather than bypassed.
  - Xbox Live is a stretch transport, not a dependency: local/System Link/community transports must preserve multiplayer even when official services are unavailable.
  - Reuse deterministic simulation/snapshots from earlier milestones, but treat rollback as a separate engineering feature requiring fixed ticks, input history/prediction, resimulation, checksums and presentation-side-effect reconciliation.
  - Add LexMath Duel/Co-op and optional Kinect asymmetric play through existing challenge/input abstractions.
  - Reuse selected rules as solo challenges: Boss Raid Solo, Time Bomb, Puzzle/LexMath Academy, Kinect Trial and deterministic Ghost Challenge.
  - Do not make stealth/anti-ban services or platform-enforcement bypasses a project dependency.
  - **DoD:** local Versus + Co-op + one party/solo mode ship through reusable session APIs; at least one supported network transport completes a real match with desync diagnostics; Xbox-specific LAN/System Link/LiNK results are documented and tested on real hardware where practical; Xbox Live/Xbox Network API research is documented and demonstrated only if the validated environment permits it without enforcement bypasses.

- [ ] **M46 — Lexicon Pad Custom Controller**
  - Design and build a purpose-built physical controller for BWA360/LexEngine, with Xbox 360 as the primary hardware target.
  - Wired-first architecture; validate the real console device/authentication path before committing the final PCB/interface design.
  - Provide a compact mechanical alphabet matrix for direct word entry plus a numeric/operator layer for LexMath.
  - Include practical game controls and dedicated actions such as Submit, Undo/Backspace, Clear, Shuffle and configurable power/hint shortcuts.
  - Research an analog slider/wheel for M21-style rewind/time control, plus rumble and status lighting where useful.
  - Add firmware profiles/remapping, deterministic debouncing/key scanning, latency diagnostics and a host-side input test utility.
  - Integrate through a capability-driven `LexInputDevice` abstraction so standard Xbox controllers, keyboard/gamepad host input, Kinect and future devices remain supported.
  - Multiplayer must allow mixed devices (for example Lexicon Pad + standard Xbox controller) without ruleset-specific hacks.
  - Prototype progression: electrical proof-of-concept → Rev A hand-wired/dev-board unit → Rev B custom PCB/enclosure → validated final revision.
  - Do not make console-authentication bypasses, stealth services or proprietary redistributed firmware a project dependency.
  - **DoD:** a documented physical Lexicon Pad prototype completes a representative BWA360 word encounter and LexMath challenge on real Xbox 360 hardware (or the closest validated compliant interface path), reports measured input latency/reliability, supports remapping/profiles and leaves standard-controller gameplay fully functional.

---

# Global Engineering Principles

1. **Recover first, reinvent second.** Original BWA behavior is reconstructed where practical; new systems belong in optional layers.
2. **Classic Mode remains faithful.** Enhanced ML, adaptive difficulty and dimensional mechanics must not silently alter Classic balance.
3. **Simulation and presentation stay separate.**
4. **Determinism is a first-class feature.**
5. **Data-oriented design is used where performance benefits; recovered OOP is preserved where architecture/fidelity requires it.**
6. **No Unity dependency.** LexEngine is a purpose-built native C/C++ engine.
7. **No unsafe hardware theatrics.** Never manipulate cooling/thermal protections for gameplay effects.
8. **Performance target before spectacle.** A feature that destroys frame pacing does not ship on real Xbox 360.
9. **Real hardware is authoritative.** Xenia is the rapid iteration environment, not the final performance oracle.
10. **No proprietary assets in Git.** Users import from their own legally obtained copies.
11. **Extension boundaries stay content-agnostic.** LexEngine itself should not assume that every challenge is a word; future rule providers may supply letters, numbers, operators or other content while Classic BWA remains word-faithful.
