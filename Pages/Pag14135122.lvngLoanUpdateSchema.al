page 14135122 "lvngLoanUpdateSchema"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
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
                    lvngLoanCardManagement: Codeunit lvngLoanCardManagement;
                begin
                    lvngLoanCardManagement.CopyImportSchemaToUpdateSchema(lvngJournalBatchCode);
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
                        lvngLoanCardManagement: Codeunit lvngLoanCardManagement;
                    begin
                        lvngLoanCardManagement.ModifyFieldUpdateOption(lvngJournalBatchCode, lvngFieldUpdateOption::lvngAlways);
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
                        lvngLoanCardManagement: Codeunit lvngLoanCardManagement;
                    begin
                        lvngLoanCardManagement.ModifyFieldUpdateOption(lvngJournalBatchCode, lvngFieldUpdateOption::lvngIfDestinationBlank);
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
                        lvngLoanCardManagement: Codeunit lvngLoanCardManagement;
                    begin
                        lvngLoanCardManagement.ModifyFieldUpdateOption(lvngJournalBatchCode, lvngFieldUpdateOption::lvngIfSourceNotBlank);
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
        CaptionManagement: codeunit CaptionManagement;
        lvngLoanCardManagement: Codeunit lvngLoanCardManagement;
    begin
        Clear(lvngFieldDescription);
        case lvngImportFieldType of
            lvngimportfieldtype::lvngTable:
                lvngFieldDescription := CaptionManagement.GetTranslatedFieldCaption('', Database::lvngLoanJournalLine, lvngFieldNo);
            lvngImportFieldType::lvngVariable:
                lvngFieldDescription := lvngLoanCardManagement.GetFieldName(lvngFieldNo);
        end;
    end;

}