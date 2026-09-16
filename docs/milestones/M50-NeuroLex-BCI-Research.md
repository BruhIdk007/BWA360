# M50 — NeuroLex / BCI Research

**Status: FUTURE / EXPERIMENTAL / ACCESSIBILITY RESEARCH**

## Objective

Research non-invasive EEG/brain-computer-interface input as one more optional `LexInputDevice` source. The milestone is intentionally modest: classify a small set of robust intent events, not decode arbitrary thoughts.

## Candidate interaction paradigms

Depending on the headset and research results, experiments may evaluate:

- P300-style target/confirmation events;
- SSVEP-style selection among a small number of visual targets;
- other vendor-neutral classifier outputs with measurable repeatability.

Potential actions are coarse: choose a highlighted tile/region, confirm, cancel, navigate a scanning UI, or charge/trigger an optional "Neuro-Spell" showcase.

## Preferred architecture

```text
EEG headset
   -> host acquisition
   -> calibration / preprocessing / classifier
   -> confidence-gated high-level intent
   -> bridge transport
   -> LexBCIInputBackend
   -> LexInputDevice
```

Raw EEG does not need to enter the Xbox 360. A PC/host bridge can perform signal processing and send only timestamped high-level actions. This keeps LexEngine hardware-agnostic and lets the same BCI prototype drive host builds.

## Reliability and safety constraints

- Mandatory per-user calibration where the paradigm requires it.
- Confidence thresholds, dwell/confirmation logic and false-positive logging.
- Immediate conventional-controller fallback/pause path.
- Configurable visual stimulus intensity/frequency; BCI mode remains opt-in.
- Record latency, classification accuracy and usability/fatigue observations.
- No medical diagnosis, therapeutic claim or general "mind reading" claim.

## Neuro-Spells showcase

Only after coarse input is reliable, add one optional demonstration such as selecting one of a few highlighted spell/tile choices or charging a special action through a classified focus/target event.

## Definition of Done

1. One supported non-invasive EEG setup streams to a documented host pipeline.
2. The pipeline emits timestamped high-level LexInput events with confidence metadata.
3. A controlled BWA or LexMath interaction can be completed with the BCI path.
4. Latency/accuracy/false-positive results and failure cases are documented.
5. Conventional input remains fully functional and is never blocked by BCI support.
