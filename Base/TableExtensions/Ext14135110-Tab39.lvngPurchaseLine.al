tableextension 14135110 lvngPurchaseLine extends "Purchase Line"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; lvngReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
        field(14135102; lvngDeliveryState; Code[20]) { Caption = 'Delivery State'; DataClassification = CustomerContent; TableRelation = lvngState; }
        field(14135103; lvngUseSalesTax; Boolean) { Caption = 'Use Sales Tax'; DataClassification = CustomerContent; }
        field(14135104; lvngShortcutDimension1Name; Text[30]) { CaptionClass = GetDimensionName(1); Editable = false; FieldClass = FlowField; CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(1), Code = field("Shortcut Dimension 1 Code"))); }
        field(14135105; lvngShortcutDimension2Name; Text[30]) { CaptionClass = GetDimensionName(2); Editable = false; FieldClass = FlowField; CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(2), Code = field("Shortcut Dimension 2 Code"))); }
        field(14135106; lvngServicingType; Enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135110; lvngComment; Text[250]) { Caption = 'Comment'; DataClassification = CustomerContent; }
    }

    local procedure GetDimensionName(DimensionNo: Integer): Text
    var
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;
    begin
        exit(lvngDimensionsManagement.GetDimensionName(DimensionNo));
    end;
}