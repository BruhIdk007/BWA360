# M46 — Lexicon Pad Custom Controller

**Status: FUTURE / POST-MAINLINE / HARDWARE**

## Objective

Design, prototype and validate a purpose-built physical controller for BWA360/LexEngine, with Xbox 360 as the primary target and word-entry ergonomics as the defining feature.

Lexicon Pad is not required to play BWA360. It is an optional companion hardware project that demonstrates how far the `LexInput` abstraction can scale from a stock gamepad to a game-specific device.

## Product concept

A compact desk/lap controller that combines direct mechanical text entry with familiar console controls. The player should be able to form words without moving a cursor across an on-screen keyboard, while still navigating menus, combat UI, LexMath and multiplayer normally.

Conceptual face:

```text
┌──────────────────────────────────────────────────────────────┐
│ [LB] [LT]                  STATUS                  [RT] [RB]  │
│                                                              │
│  Q W E R T Y U I O P          [Y]         [1 2 3 4 5]       │
│   A S D F G H J K L         [X][B]        [6 7 8 9 0]       │
│    Z X C V B N M              [A]         [+ - × ÷ =]       │
│                                                              │
│ [D-PAD] [UNDO] [CLEAR] [SUBMIT] [SHUFFLE]   [REWIND ◄──►]  │
│                                                              │
│             [BACK]                 [START]                   │
└──────────────────────────────────────────────────────────────┘
```

This is a design direction, not a frozen PCB layout. Ergonomic prototypes decide the final geometry.

## 1. Input goals

### Direct word entry

- 26 physical alphabet keys, preferably compact mechanical/low-profile switches;
- deterministic matrix scanning and debounce;
- reliable rollover for fast typing;
- configurable QWERTY or alternative logical mappings where practical;
- dedicated submit and correction controls.

### Dedicated BWA actions

Candidate keys:

- `SUBMIT`;
- `UNDO/BACKSPACE`;
- `CLEAR`;
- `SHUFFLE`;
- context/power/hint buttons;
- menu/navigation controls;
- pause/start/back equivalents.

The final mapping must come from actual BWA360 playtesting rather than speculative button proliferation.

### LexMath layer

LexMath should gain direct number/operator input without needing another controller:

- digits `0–9`;
- `+`, `-`, `×`, `÷`;
- comparison/equality actions such as `=`, `<`, `>` through dedicated or shifted mappings;
- mode/profile layer rather than forcing every symbol to have a permanent physical key if ergonomics suffer.

### Analog time control

Research a spring-loaded slider, wheel or other analog control for M21-style rewind/time manipulation. It must be treated as a normal analog capability so the same mechanic remains usable from a stock controller.

## 2. Standard console controls

Lexicon Pad must still be practical outside the letter matrix. Candidate minimum controls include:

- D-pad;
- ABXY-equivalent actions;
- shoulder/trigger actions;
- Start/Back-equivalent controls;
- optional analog stick or compact navigation control if playtesting demonstrates a need.

The exact set is validated against the final collection UI, Enhanced modes and M45 multiplayer rather than copied mechanically from a stock pad.

## 3. Feedback

Optional hardware feedback:

- rumble/haptic motor support;
- mode/status LEDs;
- profile/player indicator;
- per-key or zone lighting only if power, firmware and manufacturing cost remain reasonable;
- optional small diagnostic display only if it provides clear value.

Decorative electronics must not compromise input reliability or latency.

## 4. Firmware

Firmware responsibilities may include:

- keyboard matrix scanning;
- debounce;
- profile switching;
- remapping;
- analog calibration;
- haptic/status control;
- device self-test;
- latency/event diagnostics;
- safe firmware update/recovery path.

The microcontroller and electrical interface are selected only after Xbox 360 compatibility research. Host-side development may initially use a generic USB-capable MCU/dev board, but that does not prove native Xbox 360 acceptance.

## 5. Xbox 360 interface strategy

This milestone is **wired-first**. Wireless is a separate stretch target and must not delay a working prototype.

Xbox 360 device recognition/authentication constraints must be measured on real hardware before freezing the final electronics. Candidate compliant paths can include:

- a documented interface supported by the validated homebrew environment;
- a donor/bridge interface using legitimately owned controller hardware where appropriate;
- another replaceable platform-device backend proven by testing.

LexEngine does not depend on console-authentication bypasses, stealth services or redistributed proprietary firmware. If a direct custom-USB path is unavailable, the hardware architecture should adapt rather than move platform-enforcement circumvention into the project.

## 6. Engine integration

The controller must enter through the general input layer, conceptually:

```cpp
enum LexInputCapability
{
    LEX_INPUT_NAVIGATION,
    LEX_INPUT_ACTION_BUTTONS,
    LEX_INPUT_TEXT_KEYS,
    LEX_INPUT_NUMBER_KEYS,
    LEX_INPUT_OPERATOR_KEYS,
    LEX_INPUT_ANALOG_REWIND,
    LEX_INPUT_HAPTICS
};
```

Gameplay consumes normalized actions/challenge input rather than raw hardware scan codes.

```text
Lexicon Pad hardware
        |
LexiconPadBackend
        |
LexInputDevice
        |
   +----+----------------+
   |                     |
Classic BWA            LexMath
letters/actions     numbers/operators
```

A stock controller maps into the same high-level actions through its own backend.

## 7. Multiplayer integration

M45 should support mixed-device local sessions:

```text
Player 1 → Lexicon Pad
Player 2 → stock Xbox 360 controller
Player 3 → stock Xbox 360 controller
Player 4 → Kinect/other validated device
```

No multiplayer ruleset may assume that both peers own Lexicon Pad hardware. Network packets carry normalized player actions, not controller-specific scan codes.

## 8. Accessibility and profiles

Research:

- full remapping;
- left/right-hand-friendly layouts where feasible;
- adjustable repeat/debounce behavior;
- alternate keycaps/labels;
- high-contrast status feedback;
- one-handed subsets for compatible modes;
- per-user profiles stored outside firmware where practical.

## 9. Prototype phases

### Phase A — Input proof of concept

- dev board / matrix mock-up;
- host test utility;
- measure scan/debounce latency and missed events;
- prototype direct word entry.

### Phase B — Xbox interface proof

- establish a validated wired interface to real Xbox 360 hardware;
- enumerate/read inputs through the BWA360 test application;
- verify rumble/output path if supported.

### Phase C — Rev A ergonomic prototype

- hand-wired or simple PCB;
- 3D-printed/laser-cut enclosure;
- real campaign playtesting;
- revise spacing/button placement.

### Phase D — Rev B custom PCB

- integrated matrix/MCU/interface;
- robust connectors and strain relief;
- firmware update/recovery;
- measured power and latency;
- enclosure revision.

### Phase E — Final validated revision

- documented BOM/schematic/PCB sources where licensing permits;
- assembly guide;
- firmware source/build instructions;
- input-test procedure;
- real-hardware soak testing.

## 10. Validation matrix

At minimum test:

- rapid letter entry;
- corrections/clear/submit;
- menus;
- normal combat;
- LexMath numeric/operator input;
- rewind analog experiment if M21 supports it;
- rumble/output;
- hot-plug/reconnect behavior where available;
- mixed-device M45 local multiplayer;
- long-session missed/duplicate input rate.

## Definition of Done

M46 completes when:

1. a physical Lexicon Pad revision exists and is documented;
2. the validated Xbox 360 interface works on real hardware through a compliant/legitimate path;
3. a representative BWA360 encounter can be completed using direct alphabet input;
4. a representative LexMath challenge can be completed through the same device;
5. remapping/profile behavior is usable and recoverable;
6. input latency/reliability measurements are recorded;
7. at least one mixed-device local multiplayer configuration is demonstrated after M45 exists;
8. stock Xbox 360 controller gameplay remains fully supported;
9. firmware/hardware documentation is sufficient to reproduce the prototype from permitted components and source.

## Non-goals

M46 does not:

- make Lexicon Pad mandatory;
- replace standard gamepad support;
- require wireless support for completion;
- require proprietary firmware redistribution;
- require platform-enforcement or anti-ban bypasses;
- change Classic BWA rules merely to justify hardware features.
