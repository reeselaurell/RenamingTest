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
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngTagCode; lvngTagCode)
                {
                    ApplicationArea = All;
                }
                field(lvngProcessingSourceType; lvngProcessingSourceType)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngConditionCode; lvngConditionCode)
                {
                    ApplicationArea = All;
                }
                field(lvngAccountType; lvngAccountType)
                {
                    ApplicationArea = All;
                }
                field(lvngAccountNo; lvngAccountNo)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccount: Record "G/L Account";
                        BankAccount: Record "Bank Account";
                    begin
                        case lvngAccountType of
                            lvngAccountType::lvngGLAccount:
                                begin
                                    GLAccount.reset;
                                    GLAccount.SetRange("Direct Posting", true);
                                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                    if page.RunModal(0, GLAccount) = Action::LookupOK then
                                        lvngAccountNo := GLAccount."No.";
                                end;
                            lvngAccountType::lvngBankAccount:
                                begin
                                    BankAccount.reset;
                                    if Page.RunModal(0, BankAccount) = Action::LookupOK then
                                        lvngAccountNo := BankAccount."No.";
                                end;
                        end;
                    end;
                }
                field(lvngAccountNoSwitchCode; lvngAccountNoSwitchCode)
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
                        case lvngProcessingSourceType of
                            lvngProcessingSourceType::lvngLoanJournalValue:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", lvngFieldNo);
                                    FieldRec.FindFirst();
                                    lvngDescription := FieldRec."Field Caption";
                                end;
                            lvngProcessingSourceType::lvngLoanJournalVariableValue:
                                begin
                                    lvngLoanFieldsConfiguration.Get(lvngFieldNo);
                                    lvngDescription := lvngLoanFieldsConfiguration."Field Name";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case lvngProcessingSourceType of
                            lvngProcessingSourceType::lvngLoanJournalValue:
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
                                        lvngDescription := FieldRec."Field Caption";
                                    end;
                                end;
                            lvngProcessingSourceType::lvngLoanJournalVariableValue:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        lvngFieldNo := lvngLoanFieldsConfiguration."Field No.";
                                        lvngDescription := lvngLoanFieldsConfiguration."Field Name";
                                    end;
                                end;
                        end;
                    end;
                }
                field(lvngFunctionCode; lvngFunctionCode)
                {
                    ApplicationArea = All;
                }

                field(lvngOverrideReasonCode; lvngOverrideReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngReverseSign; lvngReverseSign)
                {
                    ApplicationArea = All;
                }

                field(lvngBalancingEntry; lvngBalancingEntry)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension1Rule; lvngDimension1Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngDimension2Rule; lvngDimension2Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension3Rule; lvngDimension3Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4Rule; lvngDimension4Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5Rule; lvngDimension5Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6Rule; lvngDimension6Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7Rule; lvngDimension7Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8Rule; lvngDimension8Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngBusinessUnitRule; lvngBusinessUnitRule)
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngGlobalDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngShortcutDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngShortcutDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngShortcutDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngShortcutDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngBusinessUnitCode; lvngBusinessUnitCode)
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