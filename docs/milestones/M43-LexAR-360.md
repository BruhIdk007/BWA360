# M43 — LexAR 360

**Status:** Future / Experimental / Post-mainline

## Goal

Demonstrate an augmented-reality LexEngine presentation with **Xbox 360 + Kinect as the primary experimental target**, while preserving the same deterministic simulation/combat/challenge logic used by normal presentation modes.

## Experience concept

The TV shows the Kinect camera view of the player/environment, with LexEngine content composited over it: tiles, enemies, effects, prompts and world-space UI. A LexMath encounter could show `7 + 5 = ?` and virtual answer tiles `[10] [12] [14] [15]`; selecting `12` produces the same `ChallengeResult` used outside AR.

## Architecture

```text
Kinect RGB / depth / pose     controller fallback
            |                         |
            +-----------+-------------+
                        v
                    LexInput
                        |
                        v
LexEngine simulation -> presentation events -> LexAR renderer/compositor
```

AR is a presentation/input backend. It must not own word validation, arithmetic validation, combat rules, RNG, progression or saves.

## Research areas

- Kinect RGB camera access.
- Depth data access.
- Skeleton/pose/gesture access.
- Camera-feed compositing.
- World-space/spatial UI.
- Hand/gesture selection with controller fallback.
- Occlusion/depth-aware experiments where practical.
- Performance and latency profiling on real Xbox 360 hardware.

## Showcase targets

- One complete BWA-style AR battle.
- One LexMath AR encounter/campaign slice.
- A diagnostic mode visualizing Kinect-derived input when available.

## Definition of Done

- [ ] AR presentation remains independent from gameplay simulation.
- [ ] Camera/input backend is isolated behind LexEngine interfaces.
- [ ] One representative encounter is fully playable in AR presentation.
- [ ] LexMath AR demonstration works through the public challenge/mod abstractions.
- [ ] Controller fallback exists for selection/navigation.
- [ ] Real-hardware Xbox 360/Kinect validation is completed if homebrew access is practical.
- [ ] If a hardware/toolchain blocker prevents full 360 completion, it is documented reproducibly and the portable AR backend is demonstrated on a supported host target.
