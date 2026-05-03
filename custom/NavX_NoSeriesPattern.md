---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- no. series
- number series
- NoSeriesMgt
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

BC 23+ introduced a new `No. Series` codeunit replacing the deprecated
`NoSeriesManagement` codeunit. NAV-X extensions must use the new API.
The No. Series is stored in the feature's setup table and must be initialised
via an install codeunit.

## Best Practice

Use `Codeunit "No. Series"` (`GetNextNo`, `PeekNextNo`, `TestAreRelated`).
Store the series code in the setup table. Initialise it in the `OnInstallAppPerDatabase`
trigger of the install codeunit using `ConditionalInsert` semantics.

```al
procedure GetNextEntryNo(): Code[20]
var
    Setup: Record "MyFeature Setup";
    NoSeries: Codeunit "No. Series";
begin
    Setup.GetRecordOnce();
    Setup.TestField("Entry Nos.");
    exit(NoSeries.GetNextNo(Setup."Entry Nos.", WorkDate(), true));
end;
```

## Anti Pattern

Using the deprecated `NoSeriesManagement` codeunit, or hardcoding document numbers.

```al
// WRONG — deprecated codeunit removed in BC 26+
var
    NoSeriesMgt: Codeunit NoSeriesManagement;
begin
    NoSeriesMgt.InitSeries(Setup."Entry Nos.", '', WorkDate(), EntryNo, SeriesCode);
end;
```
