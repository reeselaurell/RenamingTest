table 14135228 lvngCalculationUnit
{
    DataClassification = CustomerContent;
    LookupPageId = lvngCalculationUnitList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[100]) { DataClassification = CustomerContent; }
        field(11; Type; Enum lvngCalculationUnitType) { DataClassification = CustomerContent; }
        //For Type::Constant
        field(20; "Constant Value"; Decimal) { DataClassification = CustomerContent; }
        //For Type::"Amount Lookup" and Type::"Count Lookup"
        field(30; "Lookup Source"; Enum lvngPerformanceLineSourceType) { DataClassification = CustomerContent; }
        //For "Lookup Source"::"Loan Card"
        field(31; "Based On Date"; Enum lvngPerformanceBaseDate) { DataClassification = CustomerContent; }
        //For "Lookup Source"::"Ledger Entries"
        field(32; "Account No. Filter"; Text[250]) { DataClassification = CustomerContent; TableRelation = "G/L Account"."No."; ValidateTableRelation = false; }
        field(33; "Amount Type"; Enum lvngPerformanceAmountType) { DataClassification = CustomerContent; }
        //For Type::Expression
        field(40; "Expression Code"; Code[20]) { DataClassification = CustomerContent; }
        //For Type::"Provider Value"
        field(50; "Provider Metadata"; Text[250]) { DataClassification = CustomerContent; }
        field(60; "Dimension 1 Filter"; Text[250]) { DataClassification = CustomerContent; }
        field(61; "Dimension 2 Filter"; Text[250]) { DataClassification = CustomerContent; }
        field(62; "Dimension 3 Filter"; Text[250]) { DataClassification = CustomerContent; }
        field(63; "Dimension 4 Filter"; Text[250]) { DataClassification = CustomerContent; }
        field(64; "Dimension 5 Filter"; Text[250]) { DataClassification = CustomerContent; }
        field(65; "Dimension 6 Filter"; Text[250]) { DataClassification = CustomerContent; }
        field(66; "Dimension 7 Filter"; Text[250]) { DataClassification = CustomerContent; }
        field(67; "Dimension 8 Filter"; Text[250]) { DataClassification = CustomerContent; }
        field(68; "Business Unit Filter"; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    var
        DeleteLinesQst: Label 'Associated expression lines will be deleted. Continue?';

    trigger OnDelete()
    var
        CalcUnitLine: Record lvngCalculationUnitLine;
    begin
        CalcUnitLine.Reset();
        CalcUnitLine.SetRange("Unit Code", Code);
        CalcUnitLine.DeleteAll();
    end;

    trigger OnRename()
    var
        CalcUnitLine: Record lvngCalculationUnitLine;
    begin
        CalcUnitLine.Reset();
        CalcUnitLine.SetRange("Unit Code", Code);
        if CalcUnitLine.IsEmpty() then
            exit;
        if Type = Type::lvngExpression then
            if not Confirm(DeleteLinesQst) then
                exit;
        CalcUnitLine.DeleteAll();
    end;
}