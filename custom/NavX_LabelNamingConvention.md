---
bc-version:
  - 22.0
  - 23.0
  - 24.0
  - 25.0
domain: code-style
keywords:
  - label
  - naming
  - Tok
  - Err
  - Msg
  - Lbl
  - Locked
technologies:
  - AL
countries:
  - W1
application-area: All
---

## Description

AL label variable names must end with a suffix that reflects their purpose:
`Err` for user-facing error messages, `Msg` for informational messages,
`Lbl` for UI captions and general labels, and `Tok` for non-translatable tokens
(internal keys, format strings, storage keys) that carry `Locked = true`.
Mixing suffixes — e.g. using `Err` for a token or `Txt` where `Tok` is required —
causes translators to process strings that must never be translated and hides the
intent of error-path labels from reviewers.

## Best Practice

```al
var
    // User-visible error: Err suffix.
    BankAccNotFoundErr: Label 'Bank account %1 does not exist.', Comment = '%1 - Bank Account No.';
    // User-visible informational message: Msg suffix.
    RecordsProcessedMsg: Label '%1 records processed.', Comment = '%1 - count';
    // UI caption: Lbl suffix.
    JobItemPriceLbl: Label 'Job Item Price';
    // Non-translatable internal token: Tok suffix + Locked = true.
    ClientIdStorageKeyTok: Label 'NAVX_AUTHCONTEXT_CLIENT_ID', Locked = true;
    JobGuardKeyTok: Label '%1|%2|%3', Comment = '%1 = ID, %2 = Job No., %3 = Version No.', Locked = true;
```

## Anti Pattern

```al
var
    // BAD: Txt suffix used instead of Tok for a locked internal token.
    AuthContextDescriptionTxt: Label 'Quinn AuthContext', Locked = true; // BAD - should be Tok
    ClientIdStorageKeyTxt: Label 'NAVX_AUTHCONTEXT_CLIENT_ID', Locked = true; // BAD - should be Tok
    // BAD: Err suffix used for an assertion message that is not an error label.
    CWMQtyNotPopulatedErr: Label 'NAVX CWM Qty. to Handle was not populated.'; // BAD - use Msg
    // BAD: string literal passed directly instead of a named label variable.
    InsertPVSField(PVSField, 6010316, 50000, 'Job Item Price'); // BAD - should use a Lbl variable
```
