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
                field(lvngLineNo; "Line No.")
                {
                    ApplicationArea = All;
                }
                field(lvngFieldType; "Field Type")
                {
                    ApplicationArea = All;
                }
                field(lvngFieldNo; "Field No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Field Type" of
                            "Field Type"::Table:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", "Field No.");
                                    FieldRec.FindFirst();
                                    "Field Name" := FieldRec."Field Caption";
                                    case FieldRec.Type of
                                        Fieldrec.Type::Integer:
                                            begin
                                                "Value Type" := "Value Type"::Integer;
                                            end;
                                        FieldRec.Type::Boolean:
                                            begin
                                                "Value Type" := "Value Type"::Boolean;
                                            end;
                                        FieldRec.Type::Decimal:
                                            begin
                                                "Value Type" := "Value Type"::Decimal;
                                            end;
                                        FieldRec.Type::Date:
                                            begin
                                                "Value Type" := "Value Type"::Date;
                                            end;
                                    end;
                                end;
                            "Field Type"::Variable:
                                begin
                                    lvngLoanFieldsConfiguration.Get("Field No.");
                                    "Field Name" := lvngLoanFieldsConfiguration."Field Name";
                                    "Value Type" := lvngLoanFieldsConfiguration."Value Type";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Field Type" of
                            "Field Type"::Table:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        "Field No." := FieldRec."No.";
                                        "Field Name" := FieldRec."Field Caption";
                                        case FieldRec.Type of
                                            Fieldrec.Type::Integer:
                                                begin
                                                    "Value Type" := "Value Type"::Integer;
                                                end;
                                            FieldRec.Type::Boolean:
                                                begin
                                                    "Value Type" := "Value Type"::Boolean;
                                                end;
                                            FieldRec.Type::Decimal:
                                                begin
                                                    "Value Type" := "Value Type"::Decimal;
                                                end;
                                            FieldRec.Type::Date:
                                                begin
                                                    "Value Type" := "Value Type"::Date;
                                                end;
                                        end;
                                    end;
                                end;
                            "Field Type"::Variable:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        "Field No." := lvngLoanFieldsConfiguration."Field No.";
                                        "Field Name" := lvngLoanFieldsConfiguration."Field Name";
                                        "Value Type" := lvngLoanFieldsConfiguration."Value Type";
                                    end;
                                end;

                        end;
                    end;
                }
                field(lvngName; "Field Name")
                {
                    ApplicationArea = All;
                }
                field(lvngFieldSize; "Field Size")
                {
                    ApplicationArea = All;
                }
                field(lvngNumbericalFormatting; "Numeric Format")
                {
                    ApplicationArea = All;
                }
                field(lvngValueType; "Value Type")
                {
                    ApplicationArea = All;
                }
                field(lvngPaddingSide; "Padding Side")
                {
                    ApplicationArea = All;
                }
                field(lvngPaddingCharacter; "Padding Character")
                {
                    ApplicationArea = All;
                }
                field(lvngTrimOption; Trimming)
                {
                    ApplicationArea = All;
                }
                field(lvngBooleanFormat; "Boolean Format")
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