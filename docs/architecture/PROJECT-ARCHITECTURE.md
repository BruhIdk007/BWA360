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
