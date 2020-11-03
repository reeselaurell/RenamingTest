table 14135149 "lvnDimensionChangeSet"
{
    Caption = 'Dimension Change Set';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Change Set ID"; Guid) { Caption = 'Change Set ID'; DataClassification = CustomerContent; Editable = false; }
        field(10; Date; Date) { Caption = 'Date'; DataClassification = CustomerContent; Editable = false; }
        field(11; Comment; Text[250]) { Caption = 'Comment'; DataClassification = CustomerContent; NotBlank = true; }
        field(12; "User ID"; Code[50]) { Caption = 'User ID'; DataClassification = CustomerContent; Editable = false; }
    }

    keys
    {
        key(PK; "Change Set ID") { Clustered = true; }
    }

    var
        DeleteChangeSetErr: Label 'Unable to delete posted change set.';

    trigger OnInsert()
    begin
        "Change Set ID" := CreateGuid();
        Date := Today();
        "User ID" := UserId();
    end;

    trigger OnDelete()
    var
        DimensionChangeLedgerEntry: Record lvnDimensionChangeLedgerEntry;
        DimensionChangeJnlEntry: Record lvnDimensionChangeJnlEntry;
    begin
        DimensionChangeLedgerEntry.Reset();
        DimensionChangeLedgerEntry.SetRange("Change Set ID", "Change Set ID");
        if not DimensionChangeLedgerEntry.IsEmpty() then
            Error(DeleteChangeSetErr);
        DimensionChangeJnlEntry.Reset();
        DimensionChangeJnlEntry.SetRange("Change Set ID", "Change Set ID");
        DimensionChangeJnlEntry.DeleteAll();
    end;
}