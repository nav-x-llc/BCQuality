// AppSource: extend via tableextension, use registered prefix, translatable caption
tableextension 70000 "NAVX Customer Ext." extends Customer
{
    fields
    {
        field(70000; "NAVX Discount Group"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'NAVX Discount Group';
        }
    }
}
