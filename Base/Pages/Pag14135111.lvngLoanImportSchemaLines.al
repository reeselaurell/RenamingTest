page 14135111 lvngLoanImportSchemaLines
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
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field("Field Type"; "Field Type") { ApplicationArea = All; }
                field("Field No."; "Field No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Field Type" of
                            "Field Type"::Table:
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", "Field No.");
                                    FieldRec.FindFirst();
                                    "Field Name" := FieldRec."Field Caption";
                                    case FieldRec.Type of
                                        Fieldrec.Type::Integer:
                                            "Value Type" := "Value Type"::Integer;
                                        FieldRec.Type::Boolean:
                                            "Value Type" := "Value Type"::Boolean;
                                        FieldRec.Type::Decimal:
                                            "Value Type" := "Value Type"::Decimal;
                                        FieldRec.Type::Date:
                                            "Value Type" := "Value Type"::Date;
                                        else
                                            "Value Type" := "Value Type"::Text;
                                    end;
                                end;
                            "Field Type"::Variable:
                                begin
                                    LoanFieldsConfiguration.Get("Field No.");
                                    "Field Name" := LoanFieldsConfiguration."Field Name";
                                    "Value Type" := LoanFieldsConfiguration."Value Type";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Field Type" of
                            "Field Type"::Table:
                                begin
                                    FieldRec.Reset();
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
                                                "Value Type" := "Value Type"::Integer;
                                            FieldRec.Type::Boolean:
                                                "Value Type" := "Value Type"::Boolean;
                                            FieldRec.Type::Decimal:
                                                "Value Type" := "Value Type"::Decimal;
                                            FieldRec.Type::Date:
                                                "Value Type" := "Value Type"::Date;
                                            else
                                                "Value Type" := "Value Type"::Text;
                                        end;
                                    end;
                                end;
                            "Field Type"::Variable:
                                begin
                                    if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                        "Field No." := LoanFieldsConfiguration."Field No.";
                                        "Field Name" := LoanFieldsConfiguration."Field Name";
                                        "Value Type" := LoanFieldsConfiguration."Value Type";
                                    end;
                                end;
                        end;
                    end;
                }
                field("Field Name"; "Field Name") { ApplicationArea = All; }
                field("Field Size"; "Field Size") { ApplicationArea = All; }
                field("Numeric Format"; "Numeric Format") { ApplicationArea = All; }
                field("Value Type"; "Value Type") { ApplicationArea = All; }
                field("Padding Side"; "Padding Side") { ApplicationArea = All; }
                field("Padding Character"; "Padding Character") { ApplicationArea = All; }
                field(Trimming; Trimming) { ApplicationArea = All; }
                field("Boolean Format"; "Boolean Format") { ApplicationArea = All; }
            }
        }
    }
}