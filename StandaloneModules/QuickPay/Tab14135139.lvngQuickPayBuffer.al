table 14135139 lvngQuickPayBuffer
{
    Caption = 'Quick Pay Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = CustomerContent; }
        field(10; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(11; "Due Date"; Date) { Caption = 'Due Date'; DataClassification = CustomerContent; }
        field(12; "Document No."; Code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; }
        field(13; "External Document No."; Code[35]) { Caption = 'External Document No.'; DataClassification = CustomerContent; }
        field(14; "Vendor No."; Code[20]) { Caption = 'Vendor No.'; DataClassification = CustomerContent; }
        field(15; "Remaining Amount"; Decimal) { Caption = 'Remaining Amount'; DataClassification = CustomerContent; }
        field(16; "Amount to Pay"; Decimal) { Caption = 'Amount to Pay'; DataClassification = CustomerContent; }
        field(17; "Dimension Set ID"; Integer) { Caption = 'Dimension Set ID'; DataClassification = CustomerContent; }
        field(18; Pay; Boolean)
        {
            Caption = 'Pay';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Pay then
                    "Amount to Pay" := "Remaining Amount"
                else
                    "Amount to Pay" := 0;
            end;
        }
        field(50; "Vendor Name"; Text[50]) { Caption = 'Vendor Name'; DataClassification = CustomerContent; Editable = false; }
        field(51; Description; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; Editable = false; }
        field(70; "Payment Method Code"; Code[10]) { Caption = 'Payment Method Code'; DataClassification = CustomerContent; TableRelation = "Payment Method".Code; Editable = false; }
        field(71; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
        field(80; "Applies-to ID"; Code[50]) { Caption = 'Applies-to ID'; DataClassification = CustomerContent; }
        field(14135999; "Document GUID"; Guid) { Caption = 'Document GUID'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; SumIndexFields = "Amount to Pay"; }
        key(Search; "Vendor Name", "External Document No.") { }
    }
}