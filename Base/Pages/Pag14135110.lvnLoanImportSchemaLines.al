page 14135110 "lvnLoanImportSchemaLines"
{
    PageType = List;
    SourceTable = lvnLoanImportSchemaLine;
    Caption = 'Loan Import Schema Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Field Type"; Rec."Field Type")
                {
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
                    begin
                        case Rec."Field Type" of
                            Rec."Field Type"::Table:
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetRange("No.", Rec."Field No.");
                                    FieldRec.FindFirst();
                                    Rec."Field Name" := FieldRec."Field Caption";
                                    case FieldRec.Type of
                                        Fieldrec.Type::Integer:
                                            Rec."Value Type" := Rec."Value Type"::Integer;
                                        FieldRec.Type::Boolean:
                                            Rec."Value Type" := Rec."Value Type"::Boolean;
                                        FieldRec.Type::Decimal:
                                            Rec."Value Type" := Rec."Value Type"::Decimal;
                                        FieldRec.Type::Date:
                                            Rec."Value Type" := Rec."Value Type"::Date;
                                        else
                                            Rec."Value Type" := Rec."Value Type"::Text;
                                    end;
                                end;
                            Rec."Field Type"::Variable:
                                begin
                                    LoanFieldsConfiguration.Get(Rec."Field No.");
                                    Rec."Field Name" := LoanFieldsConfiguration."Field Name";
                                    Rec."Value Type" := LoanFieldsConfiguration."Value Type";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
                        FieldsListPage: Page "Fields Lookup";
                    begin
                        case Rec."Field Type" of
                            Rec."Field Type"::Table:
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        Rec."Field No." := FieldRec."No.";
                                        Rec."Field Name" := FieldRec."Field Caption";
                                        case FieldRec.Type of
                                            Fieldrec.Type::Integer:
                                                Rec."Value Type" := Rec."Value Type"::Integer;
                                            FieldRec.Type::Boolean:
                                                Rec."Value Type" := Rec."Value Type"::Boolean;
                                            FieldRec.Type::Decimal:
                                                Rec."Value Type" := Rec."Value Type"::Decimal;
                                            FieldRec.Type::Date:
                                                Rec."Value Type" := Rec."Value Type"::Date;
                                            else
                                                Rec."Value Type" := Rec."Value Type"::Text;
                                        end;
                                    end;
                                end;
                            Rec."Field Type"::Variable:
                                begin
                                    if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                        Rec."Field No." := LoanFieldsConfiguration."Field No.";
                                        Rec."Field Name" := LoanFieldsConfiguration."Field Name";
                                        Rec."Value Type" := LoanFieldsConfiguration."Value Type";
                                    end;
                                end;
                        end;
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
                field("Field Size"; Rec."Field Size")
                {
                    ApplicationArea = All;
                }
                field("Numeric Format"; Rec."Numeric Format")
                {
                    ApplicationArea = All;
                }
                field("Value Type"; Rec."Value Type")
                {
                    ApplicationArea = All;
                }
                field("Padding Side"; Rec."Padding Side")
                {
                    ApplicationArea = All;
                }
                field("Padding Character"; Rec."Padding Character")
                {
                    ApplicationArea = All;
                }
                field(Trimming; Rec.Trimming)
                {
                    ApplicationArea = All;
                }
                field("Boolean Format"; Rec."Boolean Format")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}