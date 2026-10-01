---
bc-version:
  - 22.0
  - 23.0
  - 24.0
  - 25.0
domain: object-design
keywords:
  - object ID
  - renumbering
  - stability
  - permissionset
  - breaking change
technologies:
  - AL
countries:
  - W1
application-area: All
---

## Description

Once an AL object (table, codeunit, report, page, enum value, etc.) has been assigned an ID
and shipped or committed, that ID **must never change**. Renumbering an existing object
breaks permission sets, event subscriptions, saved report layouts, telemetry, and any
third-party integrations that reference the original ID. New objects must claim an unused ID
from within the extension's registered range; gaps in the sequence are acceptable.

## Best Practice

```al
// Correct: the object keeps its original ID (99002) across all changes.
codeunit 99002 "NAVX PPDG Rep Install Test"
{
    Subtype = Test;
    // ... test logic ...
}

// Correct: enum extension values use IDs from the extension's own range.
enumextension 60000 "NAVX Item Replenishment Ext" extends "Replenishment System"
{
    value(60000; "PVS Case") { Caption = 'PVS Case'; }
}
```

## Anti Pattern

```al
// BAD: object ID changed from 99002 to 99100 — breaks permission sets and references.
codeunit 99100 "NAVX PPDG Rep Install Test" // BAD - was 99002; renumbering is forbidden
{
    Subtype = Test;
}

// BAD: enum value ID taken from a PrintVis internal range instead of the extension range.
enumextension 60000 "NAVX Item Replenishment Ext" extends "Replenishment System"
{
    value(6010312; "PVS Case") { Caption = 'PVS Case'; } // BAD - foreign range ID
}
```
