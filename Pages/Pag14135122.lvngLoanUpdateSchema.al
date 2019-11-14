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

                field(lvngImportFieldType; "Import Field Type")
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
                        case "Import Field Type" of
                            "Import Field Type"::lvngTable:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", "Field No.");
                                    FieldRec.FindFirst();
                                    lvngFieldDescription := FieldRec."Field Caption";
                                end;
                            "Import Field Type"::lvngVariable:
                                begin
                                    lvngLoanFieldsConfiguration.Get("Field No.");
                                    lvngFieldDescription := lvngLoanFieldsConfiguration."Field Name";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsListPage: Page "Fields Lookup";
                        FieldRec: Record Field;
                        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Import Field Type" of
                            "Import Field Type"::lvngTable:
                                begin
                                    FieldRec.reset;
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '%1..%2', 5, 4999);
                                    Clear(FieldsListPage);
                                    FieldsListPage.SetTableView(FieldRec);
                                    FieldsListPage.LookupMode(true);
                                    if FieldsListPage.RunModal() = Action::LookupOK then begin
                                        FieldsListPage.GetRecord(FieldRec);
                                        "Field No." := FieldRec."No.";
                                        lvngFieldDescription := FieldRec."Field Caption";
                                    end;
                                end;
                            "Import Field Type"::lvngVariable:
                                begin
                                    if Page.RunModal(0, lvngLoanFieldsConfiguration) = Action::LookupOK then begin
                                        "Field No." := lvngLoanFieldsConfiguration."Field No.";
                                        lvngFieldDescription := lvngLoanFieldsConfiguration."Field Name";
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

                field(lvngFieldUpdateOption; "Field Update Option")
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
                    lvngLoanManagement.CopyImportSchemaToUpdateSchema("Journal Batch Code");
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
                        lvngLoanManagement.ModifyFieldUpdateOption("Journal Batch Code", "Field Update Option"::lvngAlways);
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
                        lvngLoanManagement.ModifyFieldUpdateOption("Journal Batch Code", "Field Update Option"::lvngIfDestinationBlank);
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
                        lvngLoanManagement.ModifyFieldUpdateOption("Journal Batch Code", "Field Update Option"::lvngIfSourceNotBlank);
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
        case "Import Field Type" of
            "Import Field Type"::lvngTable:
                begin
                    TableField.SetRange("No.", "Field No.");
                    TableField.setrange(TableNo, Database::lvngLoanJournalLine);
                    if TableField.FindFirst() then
                        lvngFieldDescription := TableField."Field Caption";
                    //lvngFieldDescription := CaptionManagement.GetTranslatedFieldCaption('', Database::lvngLoanJournalLine, lvngFieldNo);
                end;
            "Import Field Type"::lvngVariable:
                lvngFieldDescription := lvngLoanManagement.GetFieldName("Field No.");
        end;
    end;

}