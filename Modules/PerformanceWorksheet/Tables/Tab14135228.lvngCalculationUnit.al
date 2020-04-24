table 14135228 lvngCalculationUnit
{
    Caption = 'Calculation Unit';
    DataClassification = CustomerContent;
    LookupPageId = lvngCalculationUnitList;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; Type; Enum lvngCalculationUnitType) { Caption = 'Type'; DataClassification = CustomerContent; }
        //For Type::Constant
        field(20; "Constant Value"; Decimal) { Caption = 'Constant Value'; DataClassification = CustomerContent; }
        //For Type::"Amount Lookup" and Type::"Count Lookup"
        field(30; "Lookup Source"; Enum lvngPerformanceLineSourceType) { Caption = 'Lookup Source'; DataClassification = CustomerContent; }
        //For "Lookup Source"::"Loan Card"
        field(31; "Based On Date"; Enum lvngLoanDateType) { Caption = 'Based On Date'; DataClassification = CustomerContent; }
        //For "Lookup Source"::"Ledger Entries"
        field(32; "Account No. Filter"; Text[250]) { Caption = 'Account No. Filter'; DataClassification = CustomerContent; TableRelation = "G/L Account"."No."; ValidateTableRelation = false; }
        field(33; "Amount Type"; Enum lvngPerformanceAmountType) { Caption = 'Amount Type'; DataClassification = CustomerContent; }
        //For "Lookup Source"::"Loan Values"
        field(34; "Field No."; Integer) { Caption = 'Field No.'; DataClassification = CustomerContent; TableRelation = lvngLoanFieldsConfiguration."Field No." where("Value Type" = filter(Decimal | Integer)); }
        //For Type::Expression
        field(40; "Expression Code"; Code[20]) { Caption = 'Expression Code'; DataClassification = CustomerContent; }
        //For Type::"Provider Value"
        field(50; "Provider Metadata"; Text[250]) { Caption = 'Provider Metadata'; DataClassification = CustomerContent; }
        field(60; "Dimension 1 Filter"; Text[250]) { Caption = 'Dimension 1 Filter'; DataClassification = CustomerContent; }
        field(61; "Dimension 2 Filter"; Text[250]) { Caption = 'Dimension 2 Filter'; DataClassification = CustomerContent; }
        field(62; "Dimension 3 Filter"; Text[250]) { Caption = 'Dimension 3 Filter'; DataClassification = CustomerContent; }
        field(63; "Dimension 4 Filter"; Text[250]) { Caption = 'Dimension 4 Filter'; DataClassification = CustomerContent; }
        field(64; "Dimension 5 Filter"; Text[250]) { Caption = 'Dimension 5 Filter'; DataClassification = CustomerContent; }
        field(65; "Dimension 6 Filter"; Text[250]) { Caption = 'Dimension 6 Filter'; DataClassification = CustomerContent; }
        field(66; "Dimension 7 Filter"; Text[250]) { Caption = 'Dimension 7 Filter'; DataClassification = CustomerContent; }
        field(67; "Dimension 8 Filter"; Text[250]) { Caption = 'Dimension 8 Filter'; DataClassification = CustomerContent; }
        field(68; "Business Unit Filter"; Text[250]) { Caption = 'Business Unit Filter'; DataClassification = CustomerContent; }
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
        if Type = Type::Expression then
            if not Confirm(DeleteLinesQst) then
                exit;
        CalcUnitLine.DeleteAll();
    end;
}