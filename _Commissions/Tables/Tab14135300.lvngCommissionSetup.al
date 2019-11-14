table 14135300 "lvngCommissionSetup"
{
    DataClassification = CustomerContent;
    Caption = 'Commission Setup';
    fields
    {
        field(1; lvngPrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; lvngCommissionIdentifierCode; Code[20])
        {
            Caption = 'Commission Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvngCommissionIdentifier;
        }
        field(11; lvngUsePeriodIdentifiers; Boolean)
        {
            Caption = 'Use Period Identifiers';
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; lvngPrimaryKey)
        {
            Clustered = true;
        }
    }

    procedure GetCommissionId(): Guid
    var
        lvngCommissionId: Guid;
    begin
        Evaluate(lvngCommissionId, '3def5809-acaa-44c2-a1bb-1b4ced82881d');
        exit(lvngCommissionId);
    end;

    procedure GetCommissionReportId(): Guid
    var
        lvngReportCommissionId: Guid;
    begin
        Evaluate(lvngReportCommissionId, '9c8a9515-e298-4d37-8eee-fe1ec30afd7d');
        exit(lvngReportCommissionId);
    end;

    procedure GetLoanLevelExpressionCode(): Code[20]
    var
        lvngLoanLevelConditionCodeLbl: Label 'LOAN';
    begin
        exit(lvngLoanLevelConditionCodeLbl);
    end;

    procedure GetReportingExpressionCode(): Code[20]
    var
        lvngReportingFunctionCode: Label 'REPORTLOAN';
    begin
        exit(lvngReportingFunctionCode);
    end;

}