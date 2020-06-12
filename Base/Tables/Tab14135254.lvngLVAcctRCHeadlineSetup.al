table 14135254 lvngLVAcctRCHeadlineSetup
{
    Caption = 'Headline Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Branch Performace Date Range"; Text[30])
        {
            Caption = 'Branch Performance Date Range';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                InvalidDateErr: Label 'Invalid Date Range';
                FilterTokens: Codeunit "Filter Tokens";
                FromDate: Text;
                ToDate: Text;
                TestDate: Date;
            begin
                FilterTokens.MakeDateFilter("Branch Performace Date Range");
                if "Branch Performace Date Range".Contains('..') then begin
                    FromDate := CopyStr("Branch Performace Date Range", 1, StrPos("Branch Performace Date Range", '.') - 1);
                    ToDate := CopyStr("Branch Performace Date Range", StrPos("Branch Performace Date Range", '.') + 2);
                    if not Evaluate(TestDate, FromDate) then
                        Error(InvalidDateErr);
                    if not Evaluate(TestDate, ToDate) then
                        Error(InvalidDateErr);
                end else
                    if not Evaluate(TestDate, "Branch Performace Date Range") then
                        Error(InvalidDateErr);
                Modify();
            end;
        }
        field(11; "LO Performace Date Range"; Text[250])
        {
            Caption = 'LO Performance Date Range';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                InvalidDateErr: Label 'Invalid Date Range';
                FilterTokens: Codeunit "Filter Tokens";
                FromDate: Text;
                ToDate: Text;
                TestDate: Date;
            begin
                FilterTokens.MakeDateFilter("LO Performace Date Range");
                if "LO Performace Date Range".Contains('..') then begin
                    FromDate := CopyStr("LO Performace Date Range", 1, StrPos("LO Performace Date Range", '.') - 1);
                    ToDate := CopyStr("LO Performace Date Range", StrPos("LO Performace Date Range", '.') + 2);
                    if not Evaluate(TestDate, FromDate) then
                        Error(InvalidDateErr);
                    if not Evaluate(TestDate, ToDate) then
                        Error(InvalidDateErr);
                end else
                    if not Evaluate(TestDate, "LO Performace Date Range") then
                        Error(InvalidDateErr);
                Modify();
            end;
        }
        field(12; "Net Income G/L Account No."; Code[20]) { Caption = 'Net Income G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}