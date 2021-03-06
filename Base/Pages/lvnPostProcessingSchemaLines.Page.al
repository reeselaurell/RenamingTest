page 14135112 "lvnPostProcessingSchemaLines"
{
    PageType = List;
    SourceTable = lvnPostProcessingSchemaLine;
    Caption = 'Post Processing Lines';

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
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("From Field No."; Rec."From Field No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
                        FieldsLookup: Page "Fields Lookup";
                    begin
                        case Rec.Type of
                            Rec.Type::"Copy Loan Card Value":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoan);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        Rec."From Field No." := FieldRec."No.";
                                    end;
                                end;
                            Rec.Type::"Copy Loan Variable Value", Rec.Type::"Copy Loan Journal Variable Value", Rec.Type::"Dimension Mapping":
                                if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then
                                    Rec."From Field No." := LoanFieldsConfiguration."Field No.";
                            Rec.Type::"Copy Loan Journal Value":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        Rec."From Field No." := FieldRec."No.";
                                    end;
                                end;
                        end;
                    end;
                }
                field("Expression Code"; Rec."Expression Code")
                {
                    ApplicationArea = All;
                }
                field("Custom Value"; Rec."Custom Value")
                {
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Assign To"; Rec."Assign To")
                {
                    ApplicationArea = All;
                }
                field("To Field No."; Rec."To Field No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
                        FieldsLookup: Page "Fields Lookup";
                    begin
                        case Rec."Assign To" of
                            Rec."Assign To"::"Loan Journal Field":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        Rec."To Field No." := FieldRec."No.";
                                    end;
                                end;
                            Rec."Assign To"::"Loan Journal Variable Field":
                                if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then
                                    Rec."To Field No." := LoanFieldsConfiguration."Field No.";
                        end;
                    end;
                }
                field("Copy Field Part"; Rec."Copy Field Part")
                {
                    ApplicationArea = All;
                }
                field("From Character No."; Rec."From Character No.")
                {
                    ApplicationArea = All;
                }
                field("Characters Count"; Rec."Characters Count")
                {
                    ApplicationArea = All;
                }
                field("Rounding Expression"; Rec."Rounding Expression")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}