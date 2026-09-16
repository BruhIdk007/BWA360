# M44 — LexVR Research

**Status:** Future / Experimental / Post-mainline

## Goal

Validate that LexEngine presentation and input can support VR without coupling the simulation layer to an HMD runtime. Xbox 360 work is explicitly research-oriented; modern HMD support belongs in an appropriate portable backend or optional bridge.

## Research tiers

### Tier 1 — Xbox 360 stereo presentation

- Stereo left/right camera rendering experiments.
- Frame-time and memory-cost profiling.
- Stable world-space UI and tile-board presentation.

### Tier 2 — Xbox 360 head/pose experiments

- Kinect-derived head/upper-body pose where practical.
- Head-tracked camera experiments.
- Controller/Kinect spatial interaction experiments.

### Tier 3 — Portable modern VR backend

- Stereo/HMD view abstraction.
- Head pose.
- VR controller or hand input abstraction.
- World-space UI and spatial tile interaction.
- Appropriate host runtime integration kept outside the simulation core.

### Tier 4 — Optional bridge research

Investigate whether a PC/HMD host can provide pose/input/display services while Xbox 360/LexEngine participates in simulation or selected rendering experiments. This is research only, not a release requirement.

## Comfort requirements

- Stable horizon and UI anchors.
- Minimal forced camera acceleration.
- Configurable interaction distance.
- Seated and standing modes where supported.
- No gameplay mechanic should require discomfort-inducing motion.

## Showcase targets

- One complete BWA-style VR battle on a VR-capable target.
- One LexMath VR encounter in which number/operator tiles can be selected spatially.
- Documented Xbox 360 stereo/head-tracking results, positive or negative.

## Definition of Done

- [ ] VR renderer/input code is isolated from simulation.
- [ ] Stereo presentation and head-pose abstractions exist in the portable presentation layer.
- [ ] One representative battle is playable on a VR-capable target.
- [ ] LexMath VR demonstration works through documented engine/mod interfaces.
- [ ] Comfort configuration is implemented and documented.
- [ ] Xbox 360 stereo/head-tracking/bridge experiments are either demonstrated or closed with reproducible technical findings.
