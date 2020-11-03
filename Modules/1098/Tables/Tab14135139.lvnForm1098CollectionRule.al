table 14135139 "lvnForm1098CollectionRule"
{
    Caption = 'Form 1098 Collection Rule';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Box No."; Integer) { Caption = 'Box No.'; DataClassification = CustomerContent; MinValue = 1; MaxValue = 10; }
        field(10; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Box No.") { Clustered = true; }
    }
}