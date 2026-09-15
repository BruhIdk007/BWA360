# Project Status

## Completed

- [x] **M1 — Hello360**
  - OpenXeChain toolchain validated.
  - Native `ppc32-unknown-xbox360` code produced.
  - Xbox PE32 generated with machine `0x01F2` and Xbox subsystem `0x0E`.
  - SynthXEX function-import thunk issue isolated and locally patched.
  - XEX2 loaded successfully in Xenia.
  - `xboxkrnl!DbgPrint` resolved and executed.
  - Observed guest marker:

    ```text
    HELLO360: LexEngine bring-up successful!
    ```

## Active work

- [ ] **M2 — LexEngine Platform Bring-up**
  - Detailed checklist: [`docs/milestones/M2-LexEngine-Platform-Bringup.md`](docs/milestones/M2-LexEngine-Platform-Bringup.md)

## Current release state

- [x] **v0.0.1 — Toolchain Bring-up** — milestone content complete and ready to tag once this repository snapshot is committed.
- [ ] **v0.1.0 — Lex Lives** — current release target.

## Immediate M2 priorities

1. Establish `src/lexengine/platform/xbox360/` instead of growing the `hello360` test into production code.
2. Define a small platform API for logging, asserts, monotonic time, memory, file reads and input.
3. Create an Xbox runtime/entry layer and an explicit main loop.
4. Produce first visible output.
5. Add controller input.
6. Read one packaged file.
7. Play one simple sound.
8. Validate on Xenia first, then on real modified Xbox 360 hardware when available.

## Known environment issue

The current Linux Xenia setup detects only Mesa `llvmpipe` rather than a physical Vulkan GPU. This did not block M1 because M1 required no rendering, but hardware Vulkan must be fixed before graphics/performance work becomes authoritative.

## Update rule

When a milestone completes:

1. mark it `[x]` in `ROADMAP.md`;
2. finish its detailed milestone checklist;
3. advance this file to the next active milestone;
4. update `RELEASES.md` when a release boundary is reached;
5. add a `CHANGELOG.md` entry;
6. create the matching Git tag only after the committed repository reproduces the result.
