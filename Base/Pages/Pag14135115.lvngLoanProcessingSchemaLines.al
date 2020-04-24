page 14135115 lvngLoanProcessingSchemaLines
{
    PageType = List;
    SourceTable = lvngLoanProcessingSchemaLine;
    Caption = 'Loan Processing Schema Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field("Tag Code"; "Tag Code") { ApplicationArea = All; }
                field("Processing Source Type"; "Processing Source Type") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Condition Code"; "Condition Code") { ApplicationArea = All; }
                field("Account Type"; "Account Type") { ApplicationArea = All; }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccount: Record "G/L Account";
                        BankAccount: Record "Bank Account";
                    begin
                        case "Account Type" of
                            "Account Type"::"G/L Account":
                                begin
                                    GLAccount.Reset();
                                    GLAccount.SetRange("Direct Posting", true);
                                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                    if page.RunModal(0, GLAccount) = Action::LookupOK then
                                        "Account No." := GLAccount."No.";
                                end;
                            "Account Type"::"Bank Account":
                                begin
                                    BankAccount.Reset();
                                    if Page.RunModal(0, BankAccount) = Action::LookupOK then
                                        "Account No." := BankAccount."No.";
                                end;
                        end;
                    end;
                }
                field("Account No. Switch Code"; "Account No. Switch Code") { ApplicationArea = All; }
                field("Field No."; "Field No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Processing Source Type" of
                            "Processing Source Type"::"Loan Journal Value":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", "Field No.");
                                    FieldRec.FindFirst();
                                    Description := FieldRec."Field Caption";
                                end;
                            "Processing Source Type"::"Loan Journal Variable Value":
                                begin
                                    LoanFieldsConfiguration.Get("Field No.");
                                    Description := LoanFieldsConfiguration."Field Name";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsLookup: Page "Fields Lookup";
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Processing Source Type" of
                            "Processing Source Type"::"Loan Journal Value":
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '>=%1', 5);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        "Field No." := FieldRec."No.";
                                        Description := FieldRec."Field Caption";
                                    end;
                                end;
                            "Processing Source Type"::"Loan Journal Variable Value":
                                begin
                                    if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                        "Field No." := LoanFieldsConfiguration."Field No.";
                                        Description := LoanFieldsConfiguration."Field Name";
                                    end;
                                end;
                        end;
                    end;
                }
                field("Function Code"; "Function Code") { ApplicationArea = All; }
                field("Override Reason Code"; "Override Reason Code") { ApplicationArea = All; }
                field("Reverse Sign"; "Reverse Sign") { ApplicationArea = All; }
                field("Balancing Entry"; "Balancing Entry") { ApplicationArea = All; }
                field("Dimension 1 Rule"; "Dimension 1 Rule") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Dimension 2 Rule"; "Dimension 2 Rule") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Dimension 3 Rule"; "Dimension 3 Rule") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Dimension 4 Rule"; "Dimension 4 Rule") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Dimension 5 Rule"; "Dimension 5 Rule") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Dimension 6 Rule"; "Dimension 6 Rule") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Dimension 7 Rule"; "Dimension 7 Rule") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Dimension 8 Rule"; "Dimension 8 Rule") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Business Unit Rule"; "Business Unit Rule") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
            }
        }
    }

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;
}