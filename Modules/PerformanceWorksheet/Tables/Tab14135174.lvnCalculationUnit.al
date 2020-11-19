table 14135174 "lvnCalculationUnit"
{
    Caption = 'Calculation Unit';
    DataClassification = CustomerContent;
    LookupPageId = lvnCalculationUnitList;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; Type; Enum lvnCalculationUnitType)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(20; "Constant Value"; Decimal)
        {
            Caption = 'Constant Value';
            DataClassification = CustomerContent;
        }
        field(30; "Lookup Source"; Enum lvnPerformanceLineSourceType)
        {
            Caption = 'Lookup Source';
            DataClassification = CustomerContent;
        }
        field(31; "Based On Date"; Enum lvnLoanDateType)
        {
            Caption = 'Based On Date';
            DataClassification = CustomerContent;
        }
        field(32; "Account No. Filter"; Text[250])
        {
            Caption = 'Account No. Filter';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No.";
            ValidateTableRelation = false;
        }
        field(33; "Amount Type"; Enum lvnPerformanceAmountType)
        {
            Caption = 'Amount Type';
            DataClassification = CustomerContent;
        }
        field(34; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoanFieldsConfiguration."Field No." where("Value Type" = filter(Decimal | Integer));
        }
        field(35; "Invert Sign"; Boolean)
        {
            Caption = 'Invert Sign';
            DataClassification = CustomerContent;
        }
        field(40; "Expression Code"; Code[20])
        {
            Caption = 'Expression Code';
            DataClassification = CustomerContent;
        }
        field(50; "Provider Metadata"; Text[250])
        {
            Caption = 'Provider Metadata';
            DataClassification = CustomerContent;
        }
        field(60; "Dimension 1 Filter"; Text[250])
        {
            Caption = 'Dimension 1 Filter';
            DataClassification = CustomerContent;
        }
        field(61; "Dimension 2 Filter"; Text[250])
        {
            Caption = 'Dimension 2 Filter';
            DataClassification = CustomerContent;
        }
        field(62; "Dimension 3 Filter"; Text[250])
        {
            Caption = 'Dimension 3 Filter';
            DataClassification = CustomerContent;
        }
        field(63; "Dimension 4 Filter"; Text[250])
        {
            Caption = 'Dimension 4 Filter';
            DataClassification = CustomerContent;
        }
        field(64; "Dimension 5 Filter"; Text[250])
        {
            Caption = 'Dimension 5 Filter';
            DataClassification = CustomerContent;
        }
        field(65; "Dimension 6 Filter"; Text[250])
        {
            Caption = 'Dimension 6 Filter';
            DataClassification = CustomerContent;
        }
        field(66; "Dimension 7 Filter"; Text[250])
        {
            Caption = 'Dimension 7 Filter';
            DataClassification = CustomerContent;
        }
        field(67; "Dimension 8 Filter"; Text[250])
        {
            Caption = 'Dimension 8 Filter';
            DataClassification = CustomerContent;
        }
        field(68; "Business Unit Filter"; Text[250])
        {
            Caption = 'Business Unit Filter';
            DataClassification = CustomerContent;
        }
        field(70; "Row No."; Integer)
        {
            Caption = 'Row No.';
            DataClassification = CustomerContent;
        }
        field(71; "Column No."; Integer)
        {
            Caption = 'Column No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnDelete()
    var
        CalcUnitLine: Record lvnCalculationUnitLine;
    begin
        CalcUnitLine.Reset();
        CalcUnitLine.SetRange("Unit Code", Code);
        CalcUnitLine.DeleteAll();
    end;

    trigger OnRename()
    var
        CalcUnitLine: Record lvnCalculationUnitLine;
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

    var
        DeleteLinesQst: Label 'Associated expression lines will be deleted. Continue?';
}