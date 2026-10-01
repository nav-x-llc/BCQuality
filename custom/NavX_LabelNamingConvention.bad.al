/// <summary>
/// Demonstrates incorrect label naming — the anti-pattern.
/// </summary>
codeunit 99909 "NAVX Label Naming Bad"
{
    Access = Internal;

    var
        // BAD: Txt suffix on a Locked token — should be Tok.
        AuthContextDescriptionTxt: Label 'Quinn AuthContext', Locked = true; // BAD
        ClientIdStorageKeyTxt: Label 'NAVX_AUTHCONTEXT_CLIENT_ID', Locked = true; // BAD

        // BAD: Err suffix on an assertion/test message — should be Msg.
        CWMQtyNotPopulatedErr: Label 'NAVX CWM Qty. to Handle was not populated.'; // BAD

    internal procedure GetKey(): Text
    begin
        exit(ClientIdStorageKeyTxt); // BAD - name signals wrong classification
    end;

    internal procedure InsertField(var PVSField: Record "G/L Account"; TableID: Integer; FieldID: Integer)
    begin
        // BAD: raw string literal instead of a named Lbl variable.
        PVSField.Name := CopyStr('Job Item Price', 1, MaxStrLen(PVSField.Name)); // BAD
        PVSField.Modify();
    end;
}
