# BWA360 / LexEngine Architecture Direction

## Reconstruction pipeline

```text
Original Bookworm Adventures.exe
          ↓
Ghidra / dynamic analysis / public framework comparison
          ↓
Recovered classes, algorithms, layouts and behavior
          ↓
Portable reconstructed game core
          ↓
LexEngine platform/presentation layer
     ┌──────────┼──────────┐
   Linux      Windows    Xbox 360
```

## Code categories

### Recovered game code

Reconstruct original BWA classes and behavior as faithfully as practical. Preserve object-oriented boundaries where they carry behavioral or layout meaning.

### Reconstructed framework code

Recreate only the PopCap/SexyApp-derived systems actually needed by BWA: application lifecycle, resources, widgets, images/fonts, audio, timing and filesystem abstractions.

### New LexEngine code

Platform APIs, Xbox renderer/audio/input/storage, diagnostics, deterministic replay, Enhanced presentation, LexMind, tools and collection architecture.

## Simulation / presentation boundary

```text
SIMULATION
board / words / HP / RNG / enemy decisions / progression
                      ↓ events
PRESENTATION
render / animation / audio / camera / rumble / cinematic effects
```

Classic simulation must remain stable even when Enhanced presentation is enabled.

## Determinism

Gameplay state should be reproducible from state + input + RNG state. This supports parity testing, replays, rewind, debugging and later temporal mechanics.

## Data structures / runtime direction

- Trie/DAWG for dictionary lookup.
- Explicit endian-safe serialization.
- Versioned/checksummed saves and snapshots.
- Memory arenas and pools where appropriate on Xbox 360.
- Generation handles for new engine resources.
- Ring buffers for replay/rewind snapshots.
- Data-oriented storage for particles/render batches; recovered OOP where fidelity benefits.

## Future modding / challenge abstraction

The public LexMod layer is a late-roadmap concern (M39/M42), but the engine should avoid unnecessary assumptions that all future gameplay content is letter-based. Classic BWA itself remains strictly word-based.

The intended high-level separation is:

```text
challenge provider
    ├── Classic WordRuleProvider
    └── LexMath ArithmeticRuleProvider
                 ↓
          ChallengeResult
                 ↓
   combat / scoring / progression / presentation
```

A future `ChallengeResult`-style contract may carry correctness, score/value, damage/effect inputs and feedback metadata. The exact ABI/API must be designed from real reconstructed BWA requirements first; this diagram is an architectural constraint, not an instruction to over-generalize M2.

LexMath will validate the public SDK with examples such as:

```text
7 + 5 = ?       → 12
15 - 7 = ?      → 8
6 × 3 = ?       → 18
24 ÷ 6 = ?      → 4
? + 5 = 13      → 8
17 ? 12         → >
```

The reference mod should load externally and use documented APIs only.

## Future XR presentation boundary (M43/M44)

AR and VR are late experimental presentation/input targets, not simulation features. The long-term dependency direction is:

```text
LexEngine simulation / combat / progression / challenge rules
                         |
                         v
                 presentation API
        +----------------+----------------+
        |                |                |
      2D/3D          LexAR 360          LexVR
                         |                |
                  Kinect/camera      stereo/HMD/pose
```

**M43 — LexAR 360** uses Xbox 360 + Kinect as its primary research target where homebrew access is practical. Camera, depth, skeleton/gesture data and compositing must stay behind platform/input/presentation APIs.

**M44 — LexVR Research** must not make modern HMD APIs an Xbox 360 dependency. Xbox-specific work begins with stereo/head-tracking research; modern HMD integration belongs in a portable host backend or an explicitly experimental bridge.

M2 must not implement XR. It only needs boundaries clean enough that future input/camera/render backends can be introduced without moving platform-specific code into gameplay simulation.


## Future multiplayer/session boundary (M45)

Multiplayer must reuse the same deterministic gameplay core rather than fork it into separate local and online implementations.

```text
GameModeDirector
      |
      +-- Solo
      +-- Co-op
      +-- Versus
      |
Deterministic simulation
      |
      +-- local player slots
      +-- network session/transport
```

The network transport is replaceable. Xbox 360 research prioritizes LAN/System Link-style connectivity and Aurora LiNK compatibility where practical; host targets may use direct/relay transports. A separate Xbox Live/Xbox Network research adapter may map the same session abstraction onto native session/discovery/invite facilities if they are legitimately and technically usable in the validated environment. Official services are never required for basic multiplayer, and enforcement-bypass/anti-ban services are not architectural dependencies.

```text
LexSession API
     |
     +-- LocalSessionBackend
     +-- SystemLinkBackend
     +-- RelayBackend
     +-- XboxLiveResearchBackend   (optional / capability-gated)
```

M21 snapshot/rewind facilities may later supply state capture for rollback, but rollback itself additionally requires fixed simulation ticks, deterministic compact inputs, prediction, input/state history, bounded resimulation, checksums/desync detection and suppression/reconciliation of duplicated presentation effects. Lockstep/input-delay networking remains a valid choice for puzzle modes where it performs better operationally.

LexMod game modes may configure validated multiplayer rules/messages, while low-level transport/session integrity remains engine-owned.
## Future dedicated input hardware boundary (M46)

Lexicon Pad is a late hardware target, not a reason to hard-code one physical layout into gameplay. Input should remain capability-driven:

```text
physical device
      |
      +-- standard Xbox controller
      +-- Lexicon Pad
      +-- host keyboard/gamepad
      +-- Kinect / future devices
      |
      v
LexInputDevice capabilities
      |
      +-- navigation/actions
      +-- direct text/letter input
      +-- numeric/operator input
      +-- analog controls
      +-- haptics/status output
      |
      v
Game / Challenge / UI layers
```

No word-combat rule should depend on a Lexicon Pad being present. Direct alphabet entry is an optional capability that can improve speed and ergonomics; standard controller navigation remains fully supported. LexMath similarly consumes number/operator actions through the input abstraction rather than reading hardware scan codes.

Xbox 360 electrical/protocol/authentication details are deliberately isolated beneath the platform-device backend and must be proven on real hardware before PCB decisions are frozen. The project may use a compliant/donor interface where appropriate; console-enforcement bypasses and redistributed proprietary firmware are outside the engine architecture.

M45 mixed-device multiplayer should be able to assign different `LexInputDevice` implementations per local player, allowing configurations such as Lexicon Pad + stock Xbox controller without special-case gameplay code.
