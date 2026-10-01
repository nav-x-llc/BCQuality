---
bc-version:
  - 22.0
  - 23.0
  - 24.0
  - 25.0
domain: error-handling
keywords:
  - Codeunit.Run
  - TryFunction
  - transaction
  - error boundary
  - atomic
technologies:
  - AL
countries:
  - W1
application-area: All
---

## Description

When a unit of work must succeed or fail atomically, use a conditional `Codeunit.Run` (or
`if not MyCodeunit.Run(Rec) then`) as the error boundary rather than a `[TryFunction]`.
`[TryFunction]` does **not** roll back writes it catches, and the on-premises server rejects
database writes inside a try method that is itself called from another try method. After
a conditional `Run` returns — on either the success or the error path — the caller regains
control to release subscriptions, clear context, and re-raise the error.

## Best Practice

```al
// Wrap the unit of work in a dedicated codeunit and run it conditionally so the
// caller always regains control for cleanup, and an error rolls back all writes.
trigger OnAction()
var
    WorkRunner: Codeunit "NAVX My Work Runner";
    ErrorText: Text;
begin
    WorkRunner.SetContext(Rec);
    BindSubscription(WorkRunner);
    if not WorkRunner.Run(Rec) then begin
        ErrorText := GetLastErrorText();
        ReleaseContext(WorkRunner);
        Error('%1', ErrorText);
    end;
    ReleaseContext(WorkRunner);
end;

local procedure ReleaseContext(var Runner: Codeunit "NAVX My Work Runner")
begin
    UnbindSubscription(Runner);
    Runner.ClearContext();
end;
```

## Anti Pattern

```al
// BAD: uses SalesPost.Run() directly with no error boundary.
// A posting failure leaves the modified component lines in place (uncommitted)
// and the subscriber bound, because control never returns to the caller.
trigger OnAction()
var
    SalesPost: Codeunit "Sales-Post";
    Subscriber: Codeunit "NAVX My Subscriber";
begin
    Subscriber.SetContext(Rec);
    BindSubscription(Subscriber);
    SalesPost.Run(Rec); // BAD - no conditional; error unwinds past UnbindSubscription
    UnbindSubscription(Subscriber); // BAD - never reached on error
end;
```
