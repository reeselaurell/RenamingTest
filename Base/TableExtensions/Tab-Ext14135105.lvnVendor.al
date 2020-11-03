tableextension 14135105 "lvnVendor" extends Vendor
{
    fields
    {
        field(14135100; lvnLegalName; Text[100]) { Caption = 'Legal Name'; DataClassification = CustomerContent; }
        field(14135101; lvnLegalAddress; Text[50]) { Caption = 'Legal Address'; DataClassification = CustomerContent; }
        field(14135102; lvnLegalAddress2; Text[50]) { Caption = 'Legal Address 2'; DataClassification = CustomerContent; }
        field(14135103; lvnLegalCity; Text[30]) { Caption = 'Legal City'; DataClassification = CustomerContent; }
        field(14135104; lvnLegalState; Text[30]) { Caption = 'Legal State'; DataClassification = CustomerContent; }
        field(14135105; lvnLegalZIPCode; Code[20]) { Caption = 'Legal ZIP Code'; DataClassification = CustomerContent; }
        field(14135200; lvnReasonCodeFilter; Code[10])
        {
            Caption = 'Reason Code Filter';
            FieldClass = FlowFilter;
            TableRelation = "Reason Code";
        }
        field(14135201; lvnPaymentMethodFilter; Code[20])
        {
            Caption = 'Payment Method Filter';
            FieldClass = FlowFilter;
            TableRelation = "Payment Method";
        }
        field(14135202; lvnUserIDFilter; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
            TableRelation = User."User Name";
        }
        field(14135203; lvnPostingGroupFilter; Code[10])
        {
            Caption = 'Posting Group Filter';
            FieldClass = FlowFilter;
            TableRelation = "Vendor Posting Group";
        }
        field(14135999; lvnDocumentGuid; Guid) { DataClassification = CustomerContent; }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvnDocumentGuid = EmptyGuid then
            lvnDocumentGuid := CreateGuid();
    end;
}