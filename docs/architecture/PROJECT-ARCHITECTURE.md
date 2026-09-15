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
