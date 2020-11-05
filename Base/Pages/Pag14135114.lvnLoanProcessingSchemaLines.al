page 14135114 "lvnLoanProcessingSchemaLines"
{
    PageType = List;
    SourceTable = lvnLoanProcessingSchemaLine;
    Caption = 'Loan Processing Schema Lines';

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
                field("Tag Code"; Rec."Tag Code")
                {
                    ApplicationArea = All;
                }
                field("Processing Source Type"; Rec."Processing Source Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Condition Code"; Rec."Condition Code")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccount: Record "G/L Account";
                        BankAccount: Record "Bank Account";
                    begin
                        case Rec."Account Type" of
                            Rec."Account Type"::"G/L Account":
                                begin
                                    GLAccount.Reset();
                                    GLAccount.SetRange("Direct Posting", true);
                                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                    if Page.RunModal(0, GLAccount) = Action::LookupOK then
                                        Rec."Account No." := GLAccount."No.";
                                end;
                            Rec."Account Type"::"Bank Account":
                                begin
                                    BankAccount.Reset();
                                    if Page.RunModal(0, BankAccount) = Action::LookupOK then
                                        Rec."Account No." := BankAccount."No.";
                                end;
                        end;
                    end;
                }
                field("Account No. Switch Code"; Rec."Account No. Switch Code")
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
                        case Rec."Processing Source Type" of
                            Rec."Processing Source Type"::"Loan Journal Value":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetRange("No.", Rec."Field No.");
                                    FieldRec.FindFirst();
                                    Rec.Description := FieldRec."Field Caption";
                                end;
                            Rec."Processing Source Type"::"Loan Journal Variable Value":
                                begin
                                    LoanFieldsConfiguration.Get(Rec."Field No.");
                                    Rec.Description := LoanFieldsConfiguration."Field Name";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
                        FieldsLookup: Page "Fields Lookup";
                    begin
                        case Rec."Processing Source Type" of
                            Rec."Processing Source Type"::"Loan Journal Value":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        Rec."Field No." := FieldRec."No.";
                                        Rec.Description := FieldRec."Field Caption";
                                    end;
                                end;
                            Rec."Processing Source Type"::"Loan Journal Variable Value":
                                begin
                                    if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                        Rec."Field No." := LoanFieldsConfiguration."Field No.";
                                        Rec.Description := LoanFieldsConfiguration."Field Name";
                                    end;
                                end;
                        end;
                    end;
                }
                field("Function Code"; Rec."Function Code")
                {
                    ApplicationArea = All;
                }
                field("Override Reason Code"; Rec."Override Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Reverse Sign"; Rec."Reverse Sign")
                {
                    ApplicationArea = All;
                }
                field("Balancing Entry"; Rec."Balancing Entry")
                {
                    ApplicationArea = All;
                }
                field("Dimension 1 Rule"; Rec."Dimension 1 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field("Dimension 2 Rule"; Rec."Dimension 2 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field("Dimension 3 Rule"; Rec."Dimension 3 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field("Dimension 4 Rule"; Rec."Dimension 4 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field("Dimension 5 Rule"; Rec."Dimension 5 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field("Dimension 6 Rule"; Rec."Dimension 6 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field("Dimension 7 Rule"; Rec."Dimension 7 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field("Dimension 8 Rule"; Rec."Dimension 8 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field("Business Unit Rule"; Rec."Business Unit Rule")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}