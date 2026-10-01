/// <summary>
/// Demonstrates correct label naming conventions: Err, Msg, Lbl, Tok.
/// </summary>
codeunit 99908 "NAVX Label Naming Good"
{
    Access = Internal;

    var
        // Error raised to the user: Err suffix, no Locked.
        BankAccNotFoundErr: Label 'Bank account %1 does not exist.', Comment = '%1 - Bank Account No.';

        // Informational/assertion message: Msg suffix.
        RecordsProcessedMsg: Label '%1 records processed successfully.', Comment = '%1 - count';

        // UI caption: Lbl suffix.
        JobItemPriceLbl: Label 'Job Item Price';

        // Internal non-translatable token: Tok suffix + Locked = true.
        ClientIdStorageKeyTok: Label 'NAVX_AUTHCONTEXT_CLIENT_ID', Locked = true;
        JobGuardKeyTok: Label '%1|%2|%3', Comment = '%1 = ID, %2 = Job No., %3 = Version', Locked = true;

    internal procedure DemoLabels(BankAccNo: Code[20])
    begin
        if BankAccNo = '' then
            Error(BankAccNotFoundErr, BankAccNo);

        Message(RecordsProcessedMsg, 1);
    end;

    internal procedure GetStorageKey(): Text
    begin
        exit(ClientIdStorageKeyTok);
    end;

    internal procedure GetJobKey(ID: Integer; Job: Integer; Version: Integer): Text
    begin
        exit(StrSubstNo(JobGuardKeyTok, ID, Job, Version));
    end;

    internal procedure GetCaption(): Text
    begin
        exit(JobItemPriceLbl);
    end;
}
