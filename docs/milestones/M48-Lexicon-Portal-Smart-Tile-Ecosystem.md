# M48 — Lexicon Portal & Smart-Tile Ecosystem

**Status: FUTURE / OPTIONAL HARDWARE**

## Objective

Extend the M46 physical-input work into a tangible-play ecosystem: a **Lexicon Portal** plus NFC/RFID-enabled letters, LexMath tiles and collectible figurines.

## Physical components

### Lexicon Portal

A small illuminated reader/bridge enclosure with one or more scan/placement zones. The prototype may use a microcontroller or host bridge and addressable status lighting. The exact Xbox 360 connection path is not frozen until real-hardware validation.

### Smart letter tiles

A physical A–Z set whose stable tag IDs map to letters. A player can construct or scan a word physically and submit the resulting normalized sequence through the same challenge APIs used by conventional input.

### LexMath tiles

Number and operator tiles (`0–9`, `+`, `-`, multiplication, division, comparison/equality as appropriate) can construct/select arithmetic answers and expressions.

### Figurines

Lex/character/enemy/collection figurines can identify a character, cosmetic/loadout, encounter theme or profile slot through stable content IDs. Figurines are optional; gameplay content must still be selectable digitally.

## Data policy

NFC/RFID tags are identifiers first. The normal versioned save remains authoritative. If writable tags later cache small metadata, that data must be checksummed/versioned and never become the sole copy of progression.

## Software boundary

```text
portal/bridge -> LexPhysicalDeviceBackend -> LexInputDevice/content-ID events
                                           -> challenge/UI/collection systems
```

Host-side tools should provision tags, inspect IDs, simulate placement/removal and replay portal event logs.

## Hardware constraints

- Validate USB/serial/network/donor-interface options on real Xbox 360 hardware before PCB freeze.
- Do not require console-authentication bypasses or redistributed proprietary firmware.
- Standard controllers remain fully supported.

## Definition of Done

1. A physical portal prototype enumerates reliably through the validated bridge path.
2. One figurine is identified and mapped to a digital selection.
3. Physical letter tiles complete a valid BWA word challenge.
4. Physical LexMath number/operator tiles complete one arithmetic challenge.
5. Placement/removal events are deterministic and logged.
6. The same encounters remain playable without the portal.
