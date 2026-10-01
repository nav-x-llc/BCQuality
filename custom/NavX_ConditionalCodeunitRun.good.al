/// <summary>
/// Demonstrates the conditional Codeunit.Run error-boundary pattern.
/// The work runner codeunit owns the unit of work; the caller always regains
/// control to release subscriptions and clear context.
/// </summary>
codeunit 99903 "NAVX Cond CU Run Good"
{
    Access = Internal;
    TableNo = "Sales Header";

    var
        PostingFailedErr: Label '%1', Comment = '%1 = error text from inner run.', Locked = true;
        ContextSet: Boolean;

    trigger OnRun()
    var
        SalesPost: Codeunit "Sales-Post";
    begin
        // All writes happen here so they share one transaction scope with the caller's Run.
        SalesPost.Run(Rec);
    end;

    internal procedure SetContext(SalesHeader: Record "Sales Header")
    begin
        ContextSet := true;
    end;

    internal procedure ClearContext()
    begin
        ContextSet := false;
    end;
}

codeunit 99904 "NAVX Cond CU Run Caller Good"
{
    Access = Internal;

    local procedure PostWithCleanup(var SalesHeader: Record "Sales Header")
    var
        WorkRunner: Codeunit "NAVX Cond CU Run Good";
        ErrorText: Text;
    begin
        WorkRunner.SetContext(SalesHeader);
        BindSubscription(WorkRunner);

        // Conditional Run: whichever way it ends, execution continues on the next line.
        if not WorkRunner.Run(SalesHeader) then begin
            ErrorText := GetLastErrorText();
            ReleaseContext(WorkRunner);
            Error('%1', ErrorText);
        end;
        ReleaseContext(WorkRunner);
    end;

    local procedure ReleaseContext(var Runner: Codeunit "NAVX Cond CU Run Good")
    begin
        UnbindSubscription(Runner);
        Runner.ClearContext();
    end;
}
