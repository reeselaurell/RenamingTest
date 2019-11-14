page 14135317 "lvngCommReportTemplateDetails"
{
    PageType = List;
    SourceTable = lvngCommReportTemplateLine;
    Caption = 'Commission Report Template Details';

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngColumnNo; lvngColumnNo)
                {
                    ApplicationArea = All;
                }
                field(lvngType; lvngType)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldNo; lvngFieldNo)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case lvngType of
                            lvngType::lvngLoanCardField:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", lvngFieldNo);
                                    FieldRec.FindFirst();
                                    if lvngDescription = '' then
                                        lvngDescription := FieldRec."Field Caption";
                                    case FieldRec.Type of
                                        Fieldrec.Type::Integer:
                                            begin
                                                lvngDataType := lvngDataType::lvngInteger;
                                            end;
                                        FieldRec.Type::Boolean:
                                            begin
                                                lvngDataType := lvngDataType::lvngBoolean;
                                            end;
                                        FieldRec.Type::Decimal:
                                            begin
                                                lvngDataType := lvngDataType::lvngDecimal;
                                            end;
                                        FieldRec.Type::Date:
                                            begin
                                                lvngDataType := lvngDataType::lvngDate;
                                            end;
                                    end;
                                end;
                            lvngType::lvngLoanValueField:
                                begin
                                    lvngLoanFieldsConfiguration.Get(lvngFieldNo);
                                    if lvngDescription = '' then
                                        lvngDescription := lvngLoanFieldsConfiguration."Field Name";
                                    lvngDataType := lvngLoanFieldsConfiguration."Value Type";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case lvngType of
                            lvngType::lvngLoanCardField:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoan);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        lvngFieldNo := FieldRec."No.";
                                        if lvngDescription = '' then
                                            lvngDescription := FieldRec."Field Caption";
                                        case FieldRec.Type of
                                            Fieldrec.Type::Integer:
                                                begin
                                                    lvngDataType := lvngDataType::lvngInteger;
                                                end;
                                            FieldRec.Type::Boolean:
                                                begin
                                                    lvngDataType := lvngDataType::lvngBoolean;
                                                end;
                                            FieldRec.Type::Decimal:
                                                begin
                                                    lvngDataType := lvngDataType::lvngDecimal;
                                                end;
                                            FieldRec.Type::Date:
                                                begin
                                                    lvngDataType := lvngDataType::lvngDate;
                                                end;
                                        end;
                                    end;
                                end;
                            lvngType::lvngLoanValueField:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        lvngFieldNo := lvngLoanFieldsConfiguration."Field No.";
                                        if lvngDescription = '' then
                                            lvngDescription := lvngLoanFieldsConfiguration."Field Name";
                                        lvngDataType := lvngLoanFieldsConfiguration."Value Type";
                                    end;
                                end;

                        end;
                    end;
                }
                field(lvngFormulaCode; lvngFormulaCode)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvngExpressionList;
                        ExpressiontType: Enum lvngExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(lvngCommissionSetup.GetCommissionReportId(), lvngCommissionSetup.GetReportingExpressionCode(), lvngFormulaCode, ExpressiontType::Formula);
                        if NewCode <> '' then
                            lvngFormulaCode := NewCode;
                    end;
                }
                field(lvngDataType; lvngDataType)
                {
                    ApplicationArea = All;
                }
                field(lvngDecimalRounding; lvngDecimalRounding)
                {
                    ApplicationArea = All;
                }
                field(lvngExcelExportFormat; lvngExcelExportFormat)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        lvngCommissionSetup.Get();
    end;

    var
        lvngCommissionSetup: Record lvngCommissionSetup;
}