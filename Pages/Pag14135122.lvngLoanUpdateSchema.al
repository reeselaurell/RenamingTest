page 14135122 "lvngLoanUpdateSchema"
{
    PageType = List;
    SourceTable = lvngLoanUpdateSchema;
    Caption = 'Loan Update Schema';

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {

                field(lvngImportFieldType; lvngImportFieldType)
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
                        case lvngImportFieldType of
                            lvngImportFieldType::lvngTable:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", lvngFieldNo);
                                    FieldRec.FindFirst();
                                    lvngFieldDescription := FieldRec."Field Caption";
                                end;
                            lvngImportFieldType::lvngVariable:
                                begin
                                    lvngLoanFieldsConfiguration.Get(lvngFieldNo);
                                    lvngFieldDescription := lvngLoanFieldsConfiguration.lvngFieldName;
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case lvngImportFieldType of
                            lvngImportFieldType::lvngTable:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '%1..%2', 5, 4999);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        lvngFieldNo := FieldRec."No.";
                                        lvngFieldDescription := FieldRec."Field Caption";
                                    end;
                                end;
                            lvngImportFieldType::lvngVariable:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        lvngFieldNo := lvngLoanFieldsConfiguration.lvngFieldNo;
                                        lvngFieldDescription := lvngLoanFieldsConfiguration.lvngFieldName;
                                    end;
                                end;
                        end;
                    end;
                }
                field(lvngFieldDescription; lvngFieldDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Field Name';
                    Editable = false;
                }

                field(lvngFieldUpdateOption; lvngFieldUpdateOption)
                {
                    ApplicationArea = All;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngCopyFromImportSchema)
            {
                ApplicationArea = All;
                Caption = 'Copy from Import Schema';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Copy;

                trigger OnAction()
                var
                    lvngLoanManagement: Codeunit lvngLoanManagement;
                begin
                    lvngLoanManagement.CopyImportSchemaToUpdateSchema(lvngJournalBatchCode);
                    CurrPage.Update(false);
                end;
            }


            group(lvngOptions)
            {
                Caption = 'Change Update Option';
                Image = UpdateDescription;

                action(lvngAlways)
                {
                    ApplicationArea = all;
                    Image = Change;
                    Promoted = true;
                    Caption = 'Always';
                    trigger OnAction()
                    var
                        lvngLoanManagement: Codeunit lvngLoanManagement;
                    begin
                        lvngLoanManagement.ModifyFieldUpdateOption(lvngJournalBatchCode, lvngFieldUpdateOption::lvngAlways);
                        CurrPage.Update(false);
                    end;
                }
                action(lvngDestinationBlank)
                {
                    ApplicationArea = all;
                    Image = Change;
                    Promoted = true;
                    Caption = 'If Destination Blank';
                    trigger OnAction()
                    var
                        lvngLoanManagement: Codeunit lvngLoanManagement;
                    begin
                        lvngLoanManagement.ModifyFieldUpdateOption(lvngJournalBatchCode, lvngFieldUpdateOption::lvngIfDestinationBlank);
                        CurrPage.Update(false);
                    end;
                }
                action(lvngSourceNotBlank)
                {
                    ApplicationArea = all;
                    Image = Change;
                    Promoted = true;
                    Caption = 'If Source not Blank';
                    trigger OnAction()
                    var
                        lvngLoanManagement: Codeunit lvngLoanManagement;
                    begin
                        lvngLoanManagement.ModifyFieldUpdateOption(lvngJournalBatchCode, lvngFieldUpdateOption::lvngIfSourceNotBlank);
                        CurrPage.Update(false);
                    end;
                }
            }

        }

    }

    var
        lvngFieldDescription: Text;

    trigger OnAfterGetRecord()
    var
        TableField: Record Field;
        lvngLoanManagement: Codeunit lvngLoanManagement;
    begin
        Clear(lvngFieldDescription);
        case lvngImportFieldType of
            lvngimportfieldtype::lvngTable:
                begin
                    TableField.SetRange("No.", lvngFieldNo);
                    TableField.setrange(TableNo, Database::lvngLoanJournalLine);
                    if TableField.FindFirst() then
                        lvngFieldDescription := TableField."Field Caption";
                    //lvngFieldDescription := CaptionManagement.GetTranslatedFieldCaption('', Database::lvngLoanJournalLine, lvngFieldNo);
                end;
            lvngImportFieldType::lvngVariable:
                lvngFieldDescription := lvngLoanManagement.GetFieldName(lvngFieldNo);
        end;
    end;

}