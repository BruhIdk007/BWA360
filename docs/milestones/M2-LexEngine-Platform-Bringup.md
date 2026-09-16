# M2 — LexEngine Platform Bring-up

**Status: ACTIVE**

## Objective

Turn the M1 `hello360` proof-of-life into a minimal reusable LexEngine Xbox 360 platform backend without introducing Bookworm-specific gameplay code.

## Proposed source layout

```text
src/
└── lexengine/
    ├── core/
    │   ├── assert.*
    │   ├── log.*
    │   ├── memory.*
    │   └── time.*
    └── platform/
        └── xbox360/
            ├── entry.*
            ├── platform_xbox360.*
            ├── input_xbox360.*
            ├── filesystem_xbox360.*
            ├── video_xbox360.*
            └── audio_xbox360.*
```

Names may change as OpenXeChain APIs are validated; the architectural boundary should not.

## Checklist

### Runtime foundation

- [ ] Define a stable Xbox entry path separate from game `main` logic.
- [ ] Add `LexLog` / `LexAssert` with `DbgPrint` backend.
- [ ] Add monotonic/high-resolution timing abstraction.
- [ ] Establish clear fatal-exit / main-loop behavior.
- [ ] Define compile-time platform macros and endianness helpers.

### Memory

- [ ] Record basic process memory assumptions.
- [ ] Add allocation wrappers and diagnostic counters.
- [ ] Prototype a frame/scratch arena without committing the full long-term allocator design.

### Filesystem

- [ ] Resolve packaged game-relative path.
- [ ] Read one packaged test file.
- [ ] Validate byte count/content and report through logging.

### Input

- [ ] Detect a controller.
- [ ] Read buttons and analog state.
- [ ] Map at least one button to a visible/debug action.

### Video

- [ ] Fix hardware Vulkan detection in the Linux Xenia environment before using Xenia performance numbers.
- [ ] Establish the minimal Xbox display/render path.
- [ ] Clear/present a visible frame.
- [ ] Draw at least one simple primitive or test texture.
- [ ] Prototype readable text/debug overlay.

### Audio

- [ ] Establish minimal audio initialization.
- [ ] Play one short packaged sound or generated tone.

### Validation

- [ ] Xenia demo remains stable for an extended interactive run.
- [ ] One build accepts controller input, renders visible content, plays one sound and reads one packaged file.
- [ ] Validate on real modified Xbox 360 hardware when available.
- [ ] Document differences between Xenia and hardware.

## Definition of Done

M2 completes when one native Xbox 360 LexEngine demo:

1. boots through the reusable platform layer;
2. logs/asserts correctly;
3. uses timing and basic memory services;
4. reads one packaged file;
5. accepts controller input;
6. renders visible content;
7. plays one sound.

No Bookworm gameplay reconstruction is required for M2.

## Scope guardrail for future LexMod work

M39/M42 will eventually add the LexMod SDK and the LexMath arithmetic reference mod. M43/M44 later add experimental AR/VR presentation backends. M2 should **not** implement any of those systems early. Its only obligation is to keep the platform/core layer free of game-specific assumptions such as letters, dictionaries or arithmetic rules, and to keep input/render/platform boundaries clean enough that future Kinect, camera, stereo or HMD backends do not require simulation rewrites.
