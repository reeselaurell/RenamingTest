table 14135239 lvngLoanLevelReportSchema
{
    Caption = 'Loan Level Report Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvngLoanLevelReportSchema;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Skip Zero Balance Lines"; Boolean) { Caption = 'Skip Zero Balance Lines'; DataClassification = CustomerContent; }
    }

    trigger OnDelete()
    var
        LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine;
    begin
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", Code);
        LoanLevelReportSchemaLine.DeleteAll();
    end;
}