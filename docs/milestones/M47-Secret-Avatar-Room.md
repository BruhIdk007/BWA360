# M47 — Secret Avatar Room

**Status: FUTURE / OPTIONAL / CAPABILITY-GATED**

## Objective

Create a nostalgic Xbox 360 profile/Avatar room inside the LexEngine 3D Library Hub without making Avatar services a requirement for BWA360.

## Experience

When the validated runtime exposes enough profile/avatar functionality, the signed-in player's Xbox 360 Avatar can appear as a resident of the Library Hub: sitting on a couch, browsing books, reacting to wins/losses, holding a stock controller or Lexicon Pad, and appearing in local multiplayer lobby scenes.

The room is a showcase/presentation feature. It does not affect combat balance, progression or save compatibility.

## Research constraints

- Validate the actual Xbox 360 profile/avatar APIs available to the chosen homebrew runtime/toolchain before coding against them.
- Do not assume a specific undocumented XAM symbol exists merely because it is named in old notes or third-party examples.
- Keep all access behind capability queries and a small `LexProfileService` / `LexAvatarService` boundary.
- Do not redistribute proprietary Microsoft Avatar models, clothing, animations or system content.
- Xenia may not reproduce every system/avatar facility; real hardware is authoritative for this milestone.

## Fallback

If the real Avatar path is unavailable, the same room must work with a fallback representation (Lex, another collection character, or a generic local-profile figure/card). No normal gameplay path may depend on Avatar support.

## Definition of Done

1. Detect a signed-in local profile through validated APIs.
2. Query whether the runtime provides a usable Avatar path.
3. Demonstrate one animated/profile-linked resident in the 3D hub using the system-supported path where available.
4. Demonstrate the fallback path.
5. Document Xenia-vs-hardware behavior and all unsupported calls/content.
