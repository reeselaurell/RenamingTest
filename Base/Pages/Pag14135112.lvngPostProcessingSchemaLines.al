page 14135112 lvngPostProcessingSchemaLines
{
    PageType = List;
    SourceTable = lvngPostProcessingSchemaLine;
    Caption = 'Post Processing Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field(Type; Type) { ApplicationArea = All; }
                field("From Field No."; "From Field No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsLookup: Page "Fields Lookup";
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case Type of
                            Type::"Copy Loan Card Value":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvngLoan);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        "From Field No." := FieldRec."No.";
                                    end;
                                end;
                            Type::"Copy Loan Variable Value", Type::"Copy Loan Journal Variable Value", Type::"Dimension Mapping":
                                begin
                                    if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                        "From Field No." := LoanFieldsConfiguration."Field No.";
                                    end;
                                end;
                            Type::"Copy Loan Journal Value":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        "From Field No." := FieldRec."No.";
                                    end;
                                end;
                        end;
                    end;
                }
                field("Expression Code"; "Expression Code") { ApplicationArea = All; }
                field("Custom Value"; "Custom Value") { ApplicationArea = All; }
                field(Priority; Priority) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Assign To"; "Assign To") { ApplicationArea = All; }
                field("To Field No."; "To Field No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsLookup: Page "Fields Lookup";
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Assign To" of
                            "Assign To"::"Loan Journal Field":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        "To Field No." := FieldRec."No.";
                                    end;
                                end;
                            "Assign To"::"Loan Journal Variable Field":
                                begin
                                    if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                        "To Field No." := LoanFieldsConfiguration."Field No.";
                                    end;
                                end;
                        end;

                    end;
                }
                field("Copy Field Part"; "Copy Field Part") { ApplicationArea = All; }
                field("From Character No."; "From Character No.") { ApplicationArea = All; }
                field("Characters Count"; "Characters Count") { ApplicationArea = All; }
                field("Rounding Expression"; "Rounding Expression") { ApplicationArea = All; }
            }
        }
    }
}