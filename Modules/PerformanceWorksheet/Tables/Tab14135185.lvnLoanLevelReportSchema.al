table 14135185 "lvnLoanLevelReportSchema"
{
    Caption = 'Loan Level Report Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvnLoanLevelReportSchema;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Skip Zero Balance Lines"; Boolean) { Caption = 'Skip Zero Balance Lines'; DataClassification = CustomerContent; }
    }

    trigger OnDelete()
    var
        LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine;
    begin
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", Code);
        LoanLevelReportSchemaLine.DeleteAll();
    end;
}