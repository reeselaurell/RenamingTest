tableextension 14135108 lvngSalesLine extends "Sales Line"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; lvngServicingType; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135102; lvngReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
        field(14135104; lvngShortcutDimension1Name; Text[30]) { CaptionClass = GetDimensionName(1); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(1), Code = field("Shortcut Dimension 1 Code"))); }
        field(14135105; lvngShortcutDimension2Name; Text[30]) { CaptionClass = GetDimensionName(2); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(2), Code = field("Shortcut Dimension 2 Code"))); }
        field(14135106; lvngDeliveryState; Code[20]) { Caption = 'Delivery State'; DataClassification = CustomerContent; TableRelation = lvngState; }
        field(14135107; lvngUseSalesTax; Boolean) { Caption = 'Use Sales Tax'; DataClassification = CustomerContent; }
    }
    local procedure GetDimensionName(DimensionNo: Integer): Text
    var
        Dimension: Record "Dimension";
        GenLedgSetup: Record "General Ledger Setup";
    begin
        if GenLedgSetup.Get() then
            if DimensionNo = 1 then
                Dimension.Get(GenLedgSetup."Global Dimension 1 Code")
            else
                Dimension.Get((GenLedgSetup."Global Dimension 2 Code"));
        exit(Dimension.Name);
    end;

}