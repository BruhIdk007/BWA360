# M42 — LexMod SDK Showcase: LexMath

**Status: PLANNED / POST-MAINLINE**

## Objective

Validate the public LexMod SDK by shipping a complete educational arithmetic conversion that changes the challenge domain without modifying LexEngine source or relying on private hooks.

M39 establishes the SDK foundation. M42 is the integration proof that the API is expressive enough for a substantially different ruleset.

## Reference gameplay

Instead of forming a word, the player answers an arithmetic challenge by selecting the correct value/operator from presented choices.

```text
7 + 5 = ?

[ 10 ]  [ 12 ]  [ 14 ]  [ 15 ]
          ^
       correct
```

A correct response produces the normal successful challenge/combat result. Incorrect answers use configurable feedback/penalties appropriate to an educational mode.

## Planned exercise families

- [ ] Addition
- [ ] Subtraction
- [ ] Multiplication
- [ ] Division
- [ ] Missing-number equations
- [ ] Comparisons using `<`, `>` and `=`
- [ ] Difficulty/age profiles
- [ ] Timed and untimed modes
- [ ] Configurable distractor generation
- [ ] Educational feedback and progression

## SDK validation targets

- [ ] External mod manifest
- [ ] Discover/load/package flow
- [ ] Public rule-provider API
- [ ] Custom challenge item/content provider
- [ ] Custom UI/presentation data where required
- [ ] Custom scoring/progression configuration
- [ ] No engine-source modifications required
- [ ] Host target validation
- [ ] Xbox 360/Xenia validation
- [ ] Real-hardware validation
- [ ] Complete example/template documentation

## Architectural intent

The engine-facing result should be generic enough that downstream systems do not need to distinguish a solved word from a solved calculation:

```text
WordRuleProvider       ─┐
                        ├─→ ChallengeResult → combat / progression / VFX
ArithmeticRuleProvider ─┘
```

The exact types and API will be determined from reconstructed BWA requirements and the M39 SDK work. This milestone does not justify premature abstraction during M2.

## Definition of Done

M42 completes when LexMath:

1. is implemented primarily as an external LexMod project;
2. loads through the documented public SDK;
3. supports representative arithmetic challenge families and difficulty profiles;
4. drives a complete representative gameplay/combat loop;
5. runs on supported host targets and Xbox 360;
6. serves as the canonical mod template/reference implementation;
7. requires no private or undocumented engine hooks.
