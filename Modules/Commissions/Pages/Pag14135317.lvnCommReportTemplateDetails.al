page 14135317 lvnCommReportTemplateDetails
{
    PageType = List;
    SourceTable = lvnCommReportTemplateLine;
    Caption = 'Commission Report Template Details';

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(ColumnNo; Rec."Column No.")
                {
                    ApplicationArea = All;
                }
                field(TemplateLineType; Rec."Template Line Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(FieldNo; Rec."Field No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
                    begin
                        case Rec."Template Line Type" of
                            Rec."Template Line Type"::"Loan Card Field":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetRange("No.", Rec."Field No.");
                                    FieldRec.FindFirst();
                                    if Rec.Description = '' then
                                        Rec.Description := FieldRec."Field Caption";
                                    case FieldRec.Type of
                                        Fieldrec.Type::Integer:
                                            Rec."Value Data Type" := Rec."Value Data Type"::Integer;
                                        FieldRec.Type::Boolean:
                                            Rec."Value Data Type" := Rec."Value Data Type"::Boolean;
                                        FieldRec.Type::Decimal:
                                            Rec."Value Data Type" := Rec."Value Data Type"::Decimal;
                                        FieldRec.Type::Date:
                                            Rec."Value Data Type" := Rec."Value Data Type"::Date;
                                    end;
                                end;
                            Rec."Template Line Type"::"Loan Value Field":
                                begin
                                    LoanFieldsConfiguration.Get(Rec."Field No.");
                                    if Rec.Description = '' then
                                        Rec.Description := LoanFieldsConfiguration."Field Name";
                                    Rec."Value Data Type" := LoanFieldsConfiguration."Value Type";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
                        FieldsListPage: Page "Fields Lookup";
                    begin
                        case Rec."Template Line Type" of
                            Rec."Template Line Type"::"Loan Card Field":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoan);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        Rec."Field No." := FieldRec."No.";
                                        if Rec.Description = '' then
                                            Rec.Description := FieldRec."Field Caption";
                                        case FieldRec.Type of
                                            Fieldrec.Type::Integer:
                                                Rec."Value Data Type" := Rec."Value Data Type"::Integer;
                                            FieldRec.Type::Boolean:
                                                Rec."Value Data Type" := Rec."Value Data Type"::Boolean;
                                            FieldRec.Type::Decimal:
                                                Rec."Value Data Type" := Rec."Value Data Type"::Decimal;
                                            FieldRec.Type::Date:
                                                Rec."Value Data Type" := Rec."Value Data Type"::Date;
                                        end;
                                    end;
                                end;
                            Rec."Template Line Type"::"Loan Value Field":
                                if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                    Rec."Field No." := LoanFieldsConfiguration."Field No.";
                                    if Rec.Description = '' then
                                        Rec.Description := LoanFieldsConfiguration."Field Name";
                                    Rec."Value Data Type" := LoanFieldsConfiguration."Value Type";
                                end;
                        end;
                    end;
                }
                field(FormulaCode; Rec."Formula Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvnExpressionList;
                        ExpressiontType: Enum lvnExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(CommissionHelper.GetCommissionReportConsumerId(), CommissionHelper.GetReportingExpressionCode(), Rec."Formula Code", ExpressiontType::Formula);
                        if NewCode <> '' then
                            Rec."Formula Code" := NewCode;
                    end;
                }
                field(DataType; Rec."Value Data Type")
                {
                    ApplicationArea = All;
                }
                field(DecimalRounding; Rec."Decimal Rounding")
                {
                    ApplicationArea = All;
                }
                field(ExcelExportFormat; Rec."Excel Export Format")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        CommissionHelper: Codeunit lvnCommissionCalcHelper;
}