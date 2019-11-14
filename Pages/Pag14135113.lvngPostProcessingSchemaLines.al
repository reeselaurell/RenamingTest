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
                field(lvngLineNo; "Line No.")
                {
                    ApplicationArea = All;
                }
                field(lvngType; Type)
                {
                    ApplicationArea = All;
                }
                field(lvngFromFieldNo; "From Field No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case Type of
                            Type::lvngCopyLoanCardValue:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoan);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        "From Field No." := FieldRec."No.";
                                    end;
                                end;
                            Type::lvngCopyLoanVariableValue, Type::lvngCopyLoanJournalVariableValue, Type::lvngDimensionMapping:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        "From Field No." := lvngLoanFieldsConfiguration."Field No.";
                                    end;
                                end;
                            Type::lvngCopyLoanJournalValue:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        "From Field No." := FieldRec."No.";
                                    end;
                                end;
                        end;
                    end;
                }

                field(lvngExpressionCode; "Expression Code")
                {
                    ApplicationArea = All;
                }
                field(lvngCustomValue; "Custom Value")
                {
                    ApplicationArea = All;
                }
                field(lvngPriority; Priority)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngAssignTo; "Assign To")
                {
                    ApplicationArea = All;
                }
                field(lvngToFieldNo; "To Field No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Assign To" of
                            "Assign To"::lvngLoanJournalField:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        "To Field No." := FieldRec."No.";
                                    end;
                                end;
                            "Assign To"::lvngLoanJournalVariableField:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        "To Field No." := lvngLoanFieldsConfiguration."Field No.";
                                    end;
                                end;
                        end;

                    end;
                }
                field(lvngCopyFieldPart; "Copy Field Part")
                {
                    ApplicationArea = All;
                }
                field(lvngFromCharacterNo; "From Character No.")
                {
                    ApplicationArea = All;
                }
                field(lvngCharactersCount; "Characters Count")
                {
                    ApplicationArea = All;
                }
                field(lvngRoundExpression; "Rounding Expression")
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