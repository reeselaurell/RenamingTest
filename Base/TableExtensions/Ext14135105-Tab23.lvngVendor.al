tableextension 14135105 lvngVendor extends Vendor
{
    fields
    {
        field(14135100; lvngLegalName; Text[100]) { Caption = 'Legal Name'; DataClassification = CustomerContent; }
        field(14135101; lvngLegalAddress; Text[50]) { Caption = 'Legal Address'; DataClassification = CustomerContent; }
        field(14135102; lvngLegalAddress2; Text[50]) { Caption = 'Legal Address 2'; DataClassification = CustomerContent; }
        field(14135103; lvngLegalCity; Text[30]) { Caption = 'Legal City'; DataClassification = CustomerContent; }
        field(14135104; lvngLegalState; Text[30]) { Caption = 'Legal State'; DataClassification = CustomerContent; }
        field(14135105; lvngLegalZIPCode; Code[20]) { Caption = 'Legal ZIP Code'; DataClassification = CustomerContent; }
        field(14135200; lvngReasonCodeFilter; Code[10])
        {
            Caption = 'Reason Code Filter';
            FieldClass = FlowFilter;
            TableRelation = "Reason Code";
        }
        field(14135201; lvngPaymentMethodFilter; Code[20])
        {
            Caption = 'Payment Method Filter';
            FieldClass = FlowFilter;
            TableRelation = "Payment Method";
        }
        field(14135202; lvngUserIDFilter; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
            TableRelation = User."User Name";
        }
        field(14135203; lvngPostingGroupFilter; Code[10])
        {
            Caption = 'Posting Group Filter';
            FieldClass = FlowFilter;
            TableRelation = "Vendor Posting Group";
        }
        field(14135999; lvngDocumentGuid; Guid) { DataClassification = CustomerContent; }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvngDocumentGuid = EmptyGuid then
            lvngDocumentGuid := CreateGuid();
    end;
}