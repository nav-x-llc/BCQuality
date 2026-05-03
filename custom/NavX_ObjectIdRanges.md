---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- object ID
- idRanges
- AL Object Ninja
- app.json
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

Every AL object must have an ID within the app's own `idRanges` declared in `app.json`.
NAV-X uses AL Object Ninja to atomically reserve object IDs and prevent collisions
across concurrent AI and human developers. IDs must never be hardcoded or guessed.

## Best Practice

1. Read `idRanges` from `app.json` in the target app folder (main and test apps have
   separate ranges).
2. Call AL Object Ninja `getNext` to atomically reserve the next available ID.
3. If Ninja is unavailable, scan existing `.al` files in the folder for the highest
   used ID, then take `max + 1` and register it with Ninja.
4. Separate ID ranges for the main app vs. the test app — never cross-use them.

## Anti Pattern

Using hardcoded IDs like 50000 for every new object, reusing an ID already in
the repo, or using an ID outside the app's declared range.

```al
// WRONG — hardcoded ID that may already be in use
codeunit 50000 "NAVX My New Codeunit"
{
}
```

```al
// WRONG — ID outside the app's idRange
codeunit 60000 "NAVX My New Codeunit"
{
    // app.json says idRanges: [{"from": 50000, "to": 59999}]
}
```
