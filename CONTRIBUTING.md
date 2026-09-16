# Contributing

BWA360 is currently in early bring-up and reverse-engineering stages. Contributions should preserve reproducibility and the Classic/Enhanced separation.

## Rules

1. Do not commit proprietary Bookworm/PopCap/EA executables, assets, audio, fonts or `main.pak`.
2. Do not commit generated XEX/PE/object binaries unless a future release process explicitly defines signed/reproducible artifacts.
3. Reverse-engineering claims should include evidence: address, disassembly, trace, file format observation, differential behavior or a reproducible test.
4. Recovered behavior and new LexEngine behavior must be clearly distinguished.
5. Classic Mode behavior must not be silently changed by Enhanced features.
6. Persistent formats must be versioned and endian-safe.
7. Target-specific code belongs behind platform interfaces rather than leaking through reconstructed game logic.
8. Real-hardware verification should be recorded separately from Xenia verification.
9. Community references such as the Bookworm Adventures Wikia/Fandom may guide discovery and inspiration, but reconstruction-critical claims must be independently verified; link/attribute rather than copying external text, screenshots or artwork into the repository.

## Before opening the repository to outside contributors

A project-wide source license must be selected. Until that happens, do not accept external code contributions whose licensing status would be ambiguous.

## Toolchain patches

Changes derived from SynthXEX/OpenXeChain components must keep their upstream attribution and satisfy the corresponding upstream license requirements.
