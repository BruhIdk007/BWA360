# Release Plan

This file tracks release checkpoints. A release is checked only when its required milestone evidence exists in the repository.

## Versioning

- `0.x` — platform bring-up, reconstruction and incomplete-game milestones
- `1.x` — complete Bookworm Adventures Classic/Enhanced editions
- `2.x` — dimensional systems, LexMind and collection expansion
- `3.x` — mature collection, tooling and SDK

---

- [x] **v0.0.1 — Toolchain Bring-up**
  - Requires: M1
  - Native PowerPC Xbox 360 guest code built with OpenXeChain and executed in Xenia.
  - Proven `xboxkrnl!DbgPrint` call from guest PowerPC code.
  - Tag: `v0.0.1`

- [ ] **v0.1.0 — Lex Lives**
  - Requires: M2, with early M10-compatible platform interfaces
  - First reusable LexEngine/Xbox platform demo with visible output, controller input, timing, file I/O and audio probe.
  - Tag: `v0.1.0`

- [ ] **v0.2.0 — First Battle**
  - Requires: M3–M11
  - One reconstructed Bookworm Adventures battle playable through the native Xbox 360 backend.
  - Tag: `v0.2.0`

- [ ] **v0.5.0 — Adventure Preview**
  - Requires: substantial M12 progress
  - Major campaign systems playable; not yet release-quality.
  - Tag: `v0.5.0`

- [ ] **v1.0.0 — Classic Edition**
  - Requires: M12–M14
  - Complete campaign, stable native Xbox 360 port, saves, controller UX, importer and documented local profile/achievement support.
  - Tag: `v1.0.0`

- [ ] **v1.5.0 — Enhanced Edition**
  - Requires: M15–M20 plus M23–M25 baseline
  - 3D library hub, enhanced renderer/materials, dynamic arenas, 3.5D presentation and modern audio/cinematic systems.
  - Tag: `v1.5.0`

- [ ] **v2.0.0 — Dimensions**
  - Requires: M21–M22
  - Deterministic replay/rewind, temporal mechanics and production 4D/timeline content.
  - Tag: `v2.0.0`

- [ ] **v2.2.0 — LexMind**
  - Requires: M26–M29
  - Player modeling, smart hints, adaptive bosses, personal lexicon/analytics and Chronicle NLG.
  - Tag: `v2.2.0`

- [ ] **v2.4.0 — The Unwritten**
  - Requires: M30
  - Optional Enhanced meta-campaign and secret systems.
  - Tag: `v2.4.0`

- [ ] **v2.5.0 — Volume II Pack**
  - Requires: M32 and collection-content integration
  - Native Bookworm Adventures Volume 2 module/content pack.
  - Tag: `v2.5.0`

- [ ] **v2.7.0 — Retro Vault Pack**
  - Requires: M31 and collection-content integration
  - Native Bookworm Deluxe module/content pack with Retro Vault presentation.
  - Tag: `v2.7.0`

- [ ] **v2.8.0 — Collection Integration**
  - Requires: M33–M36
  - Unified collection hub, final local achievement design, accessibility and museum/photo/engine-room systems.
  - Tag: `v2.8.0`

- [ ] **v3.0.0 — Ultimate Collection**
  - Requires: M37–M41
  - Hardened parsers, developer tooling, LexMod SDK foundation, final optimization/documentation and optional proven Kinect extras.
  - Tag: `v3.0.0`

- [ ] **v3.1.0 — LexMath SDK Showcase**
  - Requires: M42 (and the M39 LexMod SDK foundation)
  - Reference educational arithmetic conversion distributed as the canonical LexMod example/template.
  - Demonstrates custom gameplay-rule providers without engine-source modification.
  - Tag: `v3.1.0`

- [ ] **v3.2.0 — LexAR 360 Research Showcase**
  - Requires: M43 and relevant successful M40 Kinect research.
  - Xbox 360 + Kinect AR presentation showcase with at least one complete encounter and LexMath AR demonstration where real-hardware access proves practical.
  - Tag: `v3.2.0`

- [ ] **v3.3.0 — LexVR Research Showcase**
  - Requires: M44.
  - Portable VR battle/interaction showcase plus documented Xbox 360 stereo/head-tracking/bridge research results.
  - Tag: `v3.3.0`

---

## Planning range

Assuming roughly 10–15 focused solo hours/week:

- Classic 1.0: approximately 12–20 months
- Enhanced / Dimensions / LexMind: an additional approximately 10–18 months
- BWA2 / Deluxe / collection tooling: an additional approximately 8–16 months
- full long-term vision: approximately 2.5–4+ years

These are planning ranges, not promises. Reverse-engineering difficulty, toolchain maturity and real-hardware behavior can move them substantially.
