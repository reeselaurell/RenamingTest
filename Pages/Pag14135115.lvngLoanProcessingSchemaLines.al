page 14135115 "lvngLoanProcessingSchemaLines"
{
    PageType = List;
    SourceTable = lvngLoanProcessingSchemaLine;
    Caption = 'Loan Processing Schema Lines';

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
                field(lvngTagCode; "Tag Code")
                {
                    ApplicationArea = All;
                }
                field(lvngProcessingSourceType; "Processing Source Type")
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngConditionCode; "Condition Code")
                {
                    ApplicationArea = All;
                }
                field(lvngAccountType; "Account Type")
                {
                    ApplicationArea = All;
                }
                field(lvngAccountNo; "Account No.")
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
                                    GLAccount.reset;
                                    GLAccount.SetRange("Direct Posting", true);
                                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                    if page.RunModal(0, GLAccount) = Action::LookupOK then
                                        "Account No." := GLAccount."No.";
                                end;
                            "Account Type"::"Bank Account":
                                begin
                                    BankAccount.reset;
                                    if Page.RunModal(0, BankAccount) = Action::LookupOK then
                                        "Account No." := BankAccount."No.";
                                end;
                        end;
                    end;
                }
                field(lvngAccountNoSwitchCode; "Account No. Switch Code")
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
                        case "Processing Source Type" of
                            "Processing Source Type"::"Loan Journal Value":
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", "Field No.");
                                    FieldRec.FindFirst();
                                    Description := FieldRec."Field Caption";
                                end;
                            "Processing Source Type"::"Loan Journal Variable Value":
                                begin
                                    lvngLoanFieldsConfiguration.Get("Field No.");
                                    Description := lvngLoanFieldsConfiguration."Field Name";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Processing Source Type" of
                            "Processing Source Type"::"Loan Journal Value":
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
                                        Description := FieldRec."Field Caption";
                                    end;
                                end;
                            "Processing Source Type"::"Loan Journal Variable Value":
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        "Field No." := lvngLoanFieldsConfiguration."Field No.";
                                        Description := lvngLoanFieldsConfiguration."Field Name";
                                    end;
                                end;
                        end;
                    end;
                }
                field(lvngFunctionCode; "Function Code")
                {
                    ApplicationArea = All;
                }

                field(lvngOverrideReasonCode; "Override Reason Code")
                {
                    ApplicationArea = All;
                }
                field(lvngReverseSign; "Reverse Sign")
                {
                    ApplicationArea = All;
                }

                field(lvngBalancingEntry; "Balancing Entry")
                {
                    ApplicationArea = All;
                }
                field(lvngDimension1Rule; "Dimension 1 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngDimension2Rule; "Dimension 2 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension3Rule; "Dimension 3 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4Rule; "Dimension 4 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5Rule; "Dimension 5 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6Rule; "Dimension 6 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7Rule; "Dimension 7 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8Rule; "Dimension 8 Rule")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngBusinessUnitRule; "Business Unit Rule")
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngGlobalDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngShortcutDimension3Code; "Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngShortcutDimension4Code; "Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngShortcutDimension5Code; "Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngShortcutDimension6Code; "Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngShortcutDimension7Code; "Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngShortcutDimension8Code; "Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngBusinessUnitCode; "Business Unit Code")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

    var
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

}