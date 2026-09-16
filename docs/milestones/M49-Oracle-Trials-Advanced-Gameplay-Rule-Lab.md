# M49 — Oracle Trials & Advanced Gameplay Rule Lab

**Status: FUTURE / OPTIONAL GAMEPLAY**

## Objective

Provide a late-game laboratory for genuinely new word/puzzle mechanics while protecting Classic Mode. M49 is about **rules**, not networking or hardware.

## Rule family 1 — Word Combo Strings

Successive valid words can form semantic/thematic chains across turns. Examples might combine categories such as anatomy, weapons and actions, or other data-driven relationships. The player is rewarded for planning a sequence rather than only maximizing one immediate word.

Requirements:

- data-driven semantic tags/relationships;
- deterministic scoring/state;
- visible chain progress and reset rules;
- no changes to Classic scoring unless the modifier is explicitly enabled.

## Rule family 2 — Dynamic Grid Hazards

Arena state can affect tile priorities through deterministic hazards:

- heat/lava countdown tiles;
- frozen/locked regions;
- currents/bubbles that move or promote tiles;
- corruption/decay zones;
- timed sanctuary/bonus regions.

Hazards must serialize cleanly and replay identically.

## Rule family 3 — Anagram Shields

Selected bosses can expose a scrambled-letter objective or constrained mini-puzzle. Solving the valid anagram (or satisfying the configured rule) breaks a shield/phase gate before normal damage resumes.

The system must support explicit accepted-solution rules and avoid ambiguous/unfair hidden requirements.

## Oracle Trials

A dedicated challenge area can combine modifiers into curated gauntlets, endurance runs and puzzle encounters. M45 session modes may host compatible M49 modifiers, but M49 itself remains transport-independent.

## LexMod direction

Expose stable rule-provider/modifier contracts where practical so community mods can define future deterministic challenge mechanics without patching engine internals.

## Definition of Done

1. One Word Combo String trial runs and replays deterministically.
2. One environmental grid-hazard encounter runs and replays deterministically.
3. One Anagram Shield boss phase works with explicit validation rules.
4. Each modifier can be enabled/disabled independently.
5. Classic Mode produces unchanged reference behavior with all M49 modifiers disabled.
