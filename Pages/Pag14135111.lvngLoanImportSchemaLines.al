page 14135111 "lvngLoanImportSchemaLines"
{
    PageType = List;
    SourceTable = lvngLoanImportSchemaLine;
    Caption = 'Loan Import Schema Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldType; lvngFieldType)
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
                        case lvngFieldType of
                            lvngFieldType::lvngTable:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", lvngFieldNo);
                                    FieldRec.FindFirst();
                                    lvngName := FieldRec."Field Caption";
                                    case FieldRec.Type of
                                        Fieldrec.Type::Integer:
                                            begin
                                                lvngValueType := lvngValueType::lvngInteger;
                                            end;
                                        FieldRec.Type::Boolean:
                                            begin
                                                lvngValueType := lvngValueType::lvngBoolean;
                                            end;
                                        FieldRec.Type::Decimal:
                                            begin
                                                lvngValueType := lvngValueType::lvngDecimal;
                                            end;
                                        FieldRec.Type::Date:
                                            begin
                                                lvngValueType := lvngValueType::lvngDate;
                                            end;
                                    end;
                                end;
                            lvngFieldType::lvngVariable:
                                begin
                                    lvngLoanFieldsConfiguration.Get(lvngFieldNo);
                                    lvngName := lvngLoanFieldsConfiguration.lvngFieldName;
                                    lvngValueType := lvngLoanFieldsConfiguration.lvngValueType;
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Field List";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case lvngFieldType of
                            lvngFieldType::lvngTable:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        lvngFieldNo := FieldRec."No.";
                                        lvngName := FieldRec."Field Caption";
                                        case FieldRec.Type of
                                            Fieldrec.Type::Integer:
                                                begin
                                                    lvngValueType := lvngValueType::lvngInteger;
                                                end;
                                            FieldRec.Type::Boolean:
                                                begin
                                                    lvngValueType := lvngValueType::lvngBoolean;
                                                end;
                                            FieldRec.Type::Decimal:
                                                begin
                                                    lvngValueType := lvngValueType::lvngDecimal;
                                                end;
                                            FieldRec.Type::Date:
                                                begin
                                                    lvngValueType := lvngValueType::lvngDate;
                                                end;
                                        end;
                                    end;
                                end;
                            lvngFieldType::lvngVariable:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        lvngFieldNo := lvngLoanFieldsConfiguration.lvngFieldNo;
                                        lvngName := lvngLoanFieldsConfiguration.lvngFieldName;
                                        lvngValueType := lvngLoanFieldsConfiguration.lvngValueType;
                                    end;
                                end;

                        end;
                    end;
                }
                field(lvngName; lvngName)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldSize; lvngFieldSize)
                {
                    ApplicationArea = All;
                }
                field(lvngNumbericalFormatting; lvngNumbericalFormatting)
                {
                    ApplicationArea = All;
                }
                field(lvngValueType; lvngValueType)
                {
                    ApplicationArea = All;
                }
                field(lvngPaddingSide; lvngPaddingSide)
                {
                    ApplicationArea = All;
                }
                field(lvngPaddingCharacter; lvngPaddingCharacter)
                {
                    ApplicationArea = All;
                }
                field(lvngTrimOption; lvngTrimOption)
                {
                    ApplicationArea = All;
                }
                field(lvngBooleanFormat; lvngBooleanFormat)
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}