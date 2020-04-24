table 14135172 lvngSystemCalculationFilter
{
    Caption = 'System Calculation Filter';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Integer) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Global Dimension 1"; Text[250]) { Caption = 'Global Dimension 1'; DataClassification = CustomerContent; }
        field(12; "Global Dimension 2"; Text[250]) { Caption = 'Global Dimension 2'; DataClassification = CustomerContent; }
        field(13; "Shortcut Dimension 3"; Text[250]) { Caption = 'Shortcut Dimension 3'; DataClassification = CustomerContent; }
        field(14; "Shortcut Dimension 4"; Text[250]) { Caption = 'Shortcut Dimension 4'; DataClassification = CustomerContent; }
        field(15; "Shortcut Dimension 5"; Text[250]) { Caption = 'Shortcut Dimension 5'; DataClassification = CustomerContent; }
        field(16; "Shortcut Dimension 6"; Text[250]) { Caption = 'Shortcut Dimension 6'; DataClassification = CustomerContent; }
        field(17; "Shortcut Dimension 7"; Text[250]) { Caption = 'Shortcut Dimension 7'; DataClassification = CustomerContent; }
        field(18; "Shortcut Dimension 8"; Text[250]) { Caption = 'Shortcut Dimension 8'; DataClassification = CustomerContent; }
        field(19; "Business Unit"; Text[250]) { Caption = 'Business Unit'; DataClassification = CustomerContent; }
        field(20; "As Of Date"; Date) { Caption = 'As Of Date'; DataClassification = CustomerContent; }
        field(21; "Date Filter"; Text[50]) { Caption = 'Date Filter'; DataClassification = CustomerContent; }
        field(22; "Block Data From Date"; Date) { Caption = 'Block Data From Date'; DataClassification = CustomerContent; }
        field(23; "Block Data To Date"; Date) { Caption = 'Block Date To Date'; DataClassification = CustomerContent; }
        field(24; "Omit Closing Dates"; Boolean) { Caption = 'Omit Closing Dates'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    var
        InvalidOperationErr: Label 'System Calculation Filter table is not designed to store values';

    trigger OnInsert()
    begin
        Error(InvalidOperationErr);
    end;

    procedure GetGLPostingDateFilter() DateFilter: Text
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        if "Date Filter" = '' then
            exit;
        DateFilter := "Date Filter";
        if "Omit Closing Dates" then begin
            AccountingPeriod.Reset();
            AccountingPeriod.SetFilter("Starting Date", "Date Filter");
            AccountingPeriod.SetRange(Closed, true);
            if AccountingPeriod.FindSet() then
                repeat
                    DateFilter += StrSubstNo('&<>%1', ClosingDate(AccountingPeriod."Starting Date"));
                until AccountingPeriod.Next() = 0;
        end;
    end;
}