tableextension 14135110 "lvnPurchaseLine" extends "Purchase Line"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvnLoan; }
        field(14135101; lvnReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
        field(14135102; lvnDeliveryState; Code[20]) { Caption = 'Delivery State'; DataClassification = CustomerContent; TableRelation = lvnState; }
        field(14135103; lvnUseSalesTax; Boolean) { Caption = 'Use Sales Tax'; DataClassification = CustomerContent; }
        field(14135104; lvnShortcutDimension1Name; Text[30]) { CaptionClass = GetDimensionName(1); Editable = false; FieldClass = FlowField; CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(1), Code = field("Shortcut Dimension 1 Code"))); }
        field(14135105; lvnShortcutDimension2Name; Text[30]) { CaptionClass = GetDimensionName(2); Editable = false; FieldClass = FlowField; CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(2), Code = field("Shortcut Dimension 2 Code"))); }
        field(14135106; lvnServicingType; Enum lvnServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135110; lvnComment; Text[250]) { Caption = 'Comment'; DataClassification = CustomerContent; }
    }

    local procedure GetDimensionName(DimensionNo: Integer): Text
    var
        lvnDimensionsManagement: Codeunit lvnDimensionsManagement;
    begin
        exit(lvnDimensionsManagement.GetDimensionName(DimensionNo));
    end;
}