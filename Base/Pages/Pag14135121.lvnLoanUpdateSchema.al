page 14135121 "lvnLoanUpdateSchema"
{
    PageType = List;
    SourceTable = lvnLoanUpdateSchema;
    Caption = 'Loan Update Schema';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Import Field Type"; Rec."Import Field Type")
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
                        case Rec."Import Field Type" of
                            Rec."Import Field Type"::Table:
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetRange("No.", Rec."Field No.");
                                    FieldRec.FindFirst();
                                    FieldDescription := FieldRec."Field Caption";
                                end;
                            Rec."Import Field Type"::Variable:
                                begin
                                    LoanFieldsConfiguration.Get(Rec."Field No.");
                                    FieldDescription := LoanFieldsConfiguration."Field Name";
                                end;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldRec: Record Field;
                        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
                        FieldsLookup: Page "Fields Lookup";
                    begin
                        case Rec."Import Field Type" of
                            Rec."Import Field Type"::Table:
                                begin
                                    FieldRec.Reset();
                                    FieldRec.SetRange(TableNo, Database::lvnLoanJournalLine);
                                    FieldRec.SetFilter("No.", '%1..%2', 5, 4999);
                                    Clear(FieldsLookup);
                                    FieldsLookup.SetTableView(FieldRec);
                                    FieldsLookup.LookupMode(true);
                                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                                        FieldsLookup.GetRecord(FieldRec);
                                        Rec."Field No." := FieldRec."No.";
                                        FieldDescription := FieldRec."Field Caption";
                                    end;
                                end;
                            Rec."Import Field Type"::Variable:
                                if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then begin
                                    Rec."Field No." := LoanFieldsConfiguration."Field No.";
                                    FieldDescription := LoanFieldsConfiguration."Field Name";
                                end;
                        end;
                    end;
                }
                field(FieldDescription; FieldDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Field Name';
                    Editable = false;
                }
                field("Field Update Option"; Rec."Field Update Option")
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
                    LoanManagement: Codeunit lvnLoanManagement;
                begin
                    LoanManagement.CopyImportSchemaToUpdateSchema(Rec."Journal Batch Code");
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
                        LoanManagement: Codeunit lvnLoanManagement;
                    begin
                        LoanManagement.ModifyFieldUpdateOption(Rec."Journal Batch Code", Rec."Field Update Option"::lvnAlways);
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
                        LoanManagement: Codeunit lvnLoanManagement;
                    begin
                        LoanManagement.ModifyFieldUpdateOption(Rec."Journal Batch Code", Rec."Field Update Option"::"If Destination Blank");
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
                        LoanManagement: Codeunit lvnLoanManagement;
                    begin
                        LoanManagement.ModifyFieldUpdateOption(Rec."Journal Batch Code", Rec."Field Update Option"::"If Source Not Blank");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        TableField: Record Field;
        LoanManagement: Codeunit lvnLoanManagement;
    begin
        FieldDescription := '';
        case Rec."Import Field Type" of
            Rec."Import Field Type"::Table:
                begin
                    TableField.SetRange("No.", Rec."Field No.");
                    TableField.SetRange(TableNo, Database::lvnLoanJournalLine);
                    if TableField.FindFirst() then
                        FieldDescription := TableField."Field Caption";
                end;
            Rec."Import Field Type"::Variable:
                FieldDescription := LoanManagement.GetFieldName(Rec."Field No.");
        end;
    end;

    var
        FieldDescription: Text;
}