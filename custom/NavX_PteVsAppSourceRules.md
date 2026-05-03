---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- PTE
- AppSource
- per-tenant extension
- cloud
- permission set
- prefix
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

NAV-X delivers both Per-Tenant Extensions (PTEs) for individual clients and AppSource
products for the global marketplace. The rules differ significantly between the two.

## Best Practice

**PTE (client extensions):**
- Object names use the client prefix (e.g. "5GCust"), not "NAVX".
- May extend Base App tables directly via tableextension.
- No strict AppSource validation — but follow NAV-X internal quality rules.
- Target: `Cloud` in app.json.

**AppSource products:**
- All object names must use the registered NAV-X prefix ("NAVX" or product-specific).
- No direct Base App table modifications — use tableextension objects only.
- All user-facing text must use translatable captions and labels.
- Explicit `PermissionSet` objects required; never reference internal Microsoft objects.
- `target: Cloud` required; no on-premises-only APIs.
- Backward compatibility: fixes must not break existing customer data.
- `application` version in app.json defines the minimum supported BC version.

## Anti Pattern

Using AppSource-style strict validation rules for PTE work (over-engineering), or
applying PTE permissiveness to AppSource products (will fail AppSource validation).

```al
// WRONG for AppSource — direct table modification instead of tableextension
table 18 Customer
{
    fields
    {
        field(50000; "NAVX Custom Field"; Text[50]) { }
    }
}
```
