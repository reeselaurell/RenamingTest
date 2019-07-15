page 14135113 "lvngPostProcessingSchemaLines"
{
    PageType = List;
    SourceTable = lvngPostProcessingSchemaLine;
    Caption = 'Post Processing Lines';

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngType; lvngType)
                {
                    ApplicationArea = All;
                }
                field(lvngFromFieldNo; lvngFromFieldNo)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Field List";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case lvngType of
                            lvngtype::lvngCopyLoanCardValue:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoan);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        lvngFromFieldNo := FieldRec."No.";
                                    end;
                                end;
                            lvngtype::lvngCopyLoanVariableValue, lvngtype::lvngCopyLoanJournalVariableValue, lvngType::lvngDimensionMapping:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        lvngFromFieldNo := lvngLoanFieldsConfiguration.lvngFieldNo;
                                    end;
                                end;
                            lvngtype::lvngCopyLoanJournalValue:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        lvngFromFieldNo := FieldRec."No.";
                                    end;
                                end;
                        end;
                    end;
                }

                field(lvngExpressionCode; lvngExpressionCode)
                {
                    ApplicationArea = All;
                }
                field(lvngCustomValue; lvngCustomValue)
                {
                    ApplicationArea = All;
                }
                field(lvngPriority; lvngPriority)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngAssignTo; lvngAssignTo)
                {
                    ApplicationArea = All;
                }
                field(lvngToFieldNo; lvngToFieldNo)
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Field List";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case lvngAssignTo of
                            lvngAssignTo::lvngLoanJournalField:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        lvngToFieldNo := FieldRec."No.";
                                    end;
                                end;
                            lvngAssignTo::lvngLoanJournalVariableField:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        lvngToFieldNo := lvngLoanFieldsConfiguration.lvngFieldNo;
                                    end;
                                end;
                        end;

                    end;
                }
                field(lvngRoundExpression; lvngRoundExpression)
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
        }
    }
}