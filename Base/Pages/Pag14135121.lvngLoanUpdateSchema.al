page 14135121 lvngLoanUpdateSchema
{
    PageType = List;
    SourceTable = lvngLoanUpdateSchema;
    Caption = 'Loan Update Schema';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Import Field Type"; "Import Field Type") { ApplicationArea = All; }
                field("Field No."; "Field No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Import Field Type" of
                            "Import Field Type"::Table:
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetRange("No.", "Field No.");
                                    FieldRec.FindFirst();
                                    FieldDescription := FieldRec."Field Caption";
                                end;
                            "Import Field Type"::Variable:
                                begin
                                    LoanFieldsConfiguration.Get("Field No.");
                                    FieldDescription := LoanFieldsConfiguration."Field Name";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldsLookup: Page "Fields Lookup";
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    begin
                        case "Import Field Type" of
                            "Import Field Type"::Table:
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvngLoanJournalLine);
                                    FieldRec.SetFilter("No.", '%1..%2', 5, 4999);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        "Field No." := FieldRec."No.";
                                        FieldDescription := FieldRec."Field Caption";
                                    end;
                                end;
                            "Import Field Type"::Variable:
                                begin
                                    if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                        "Field No." := LoanFieldsConfiguration."Field No.";
                                        FieldDescription := LoanFieldsConfiguration."Field Name";
                                    end;
                                end;
                        end;
                    end;
                }
                field(FieldDescription; FieldDescription) { ApplicationArea = All; Caption = 'Field Name'; Editable = false; }
                field("Field Update Option"; "Field Update Option") { ApplicationArea = All; }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(CopyFromImportSchema)
            {
                ApplicationArea = All;
                Caption = 'Copy from Import Schema';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Copy;

                trigger OnAction()
                var
                    LoanManagement: Codeunit lvngLoanManagement;
                begin
                    LoanManagement.CopyImportSchemaToUpdateSchema("Journal Batch Code");
                    CurrPage.Update(false);
                end;
            }

            group(Options)
            {
                Caption = 'Change Update Option';
                Image = UpdateDescription;

                action(Always)
                {
                    ApplicationArea = all;
                    Image = Change;
                    Promoted = true;
                    Caption = 'Always';

                    trigger OnAction()
                    var
                        LoanManagement: Codeunit lvngLoanManagement;
                    begin
                        LoanManagement.ModifyFieldUpdateOption("Journal Batch Code", "Field Update Option"::lvngAlways);
                        CurrPage.Update(false);
                    end;
                }
                action(DestinationBlank)
                {
                    ApplicationArea = all;
                    Image = Change;
                    Promoted = true;
                    Caption = 'If Destination Blank';

                    trigger OnAction()
                    var
                        LoanManagement: Codeunit lvngLoanManagement;
                    begin
                        LoanManagement.ModifyFieldUpdateOption("Journal Batch Code", "Field Update Option"::"If Destination Blank");
                        CurrPage.Update(false);
                    end;
                }
                action(SourceNotBlank)
                {
                    ApplicationArea = all;
                    Image = Change;
                    Promoted = true;
                    Caption = 'If Source not Blank';

                    trigger OnAction()
                    var
                        LoanManagement: Codeunit lvngLoanManagement;
                    begin
                        LoanManagement.ModifyFieldUpdateOption("Journal Batch Code", "Field Update Option"::"If Source Not Blank");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        FieldDescription: Text;

    trigger OnAfterGetRecord()
    var
        TableField: Record Field;
        LoanManagement: Codeunit lvngLoanManagement;
    begin
        FieldDescription := '';
        case "Import Field Type" of
            "Import Field Type"::Table:
                begin
                    TableField.SetRange("No.", "Field No.");
                    TableField.setrange(TableNo, Database::lvngLoanJournalLine);
                    if TableField.FindFirst() then
                        FieldDescription := TableField."Field Caption";
                end;
            "Import Field Type"::Variable:
                FieldDescription := LoanManagement.GetFieldName("Field No.");
        end;
    end;
}