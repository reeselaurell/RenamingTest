xmlport 14135300 lvnCommissionAdjImport
{
    Caption = 'Commission Adjustments Import';
    Format = VariableText;
    FieldSeparator = '<TAB>';

    schema
    {
        textelement(Root)
        {
            tableelement(Loop; lvnCommissionJournalLine)
            {
                SourceTableView = sorting("Schedule No.", "Line No.");

                fieldelement(ProfileCode; Loop."Profile Code")
                {
                }
                fieldelement(Description; Loop.Description)
                {
                }
                fieldelement(Amount; Loop."Commission Amount")
                {
                }
                fieldelement(IdentifierCode; Loop."Identifier Code")
                {
                }
                fieldelement(LoanNo; Loop."Loan No.")
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                trigger OnBeforeInsertRecord()
                begin
                    Loop."Line No." := LineNo;
                    LineNo := LineNo + 1000;
                    Loop."Schedule No." := CommissionSchedule."No.";
                    Loop."Manual Adjustment" := true;
                    Loop."Period Identifier Code" := CommissionSchedule."Period Identifier Code";
                    Loop."Profile Line Type" := Loop."Profile Line Type"::"Period Level";
                    Loop."Commission Date" := AsOfDate;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(ScheduleNoField; ScheduleNo)
                    {
                        Caption = 'Commission Schedule No.';
                        ApplicationArea = All;
                        TableRelation = lvnCommissionSchedule."No." where("Period Posted" = const(false));
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            CommissionSchedule.Get(ScheduleNo);
                            AsOfDate := CommissionSchedule."Period End Date";
                        end;
                    }
                    field(AsOfDateField; AsOfDate)
                    {
                        Caption = 'As Of Date';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        CommissionSchedule.Get(ScheduleNo);
        CommissionSchedule.TestField("Period Posted", false);
        if AsOfDate = 0D then
            Error(AsOfDateCantBeBlankErr);
        if AsOfDate > CommissionSchedule."Period End Date" then
            Error(AsOfDateCantBeGreaterPeriodEndDateErr);
        if AsOfDate < CommissionSchedule."Period Start Date" then
            Error(AsOfDateCantBeLowerPeriodStartDateErr);
        CommissionJournalLine.Reset();
        CommissionJournalLine.SetRange("Schedule No.", ScheduleNo);
        if CommissionJournalLine.FindLast() then
            LineNo := CommissionJournalLine."Line No." + 1000
        else
            LineNo := 1000;
    end;

    var
        CommissionSchedule: Record lvnCommissionSchedule;
        CommissionJournalLine: Record lvnCommissionJournalLine;
        ScheduleNo: Integer;
        LineNo: Integer;
        AsOfDate: Date;
        AsOfDateCantBeBlankErr: Label 'As Of Date parameter can''t be blank';
        AsOfDateCantBeGreaterPeriodEndDateErr: Label 'As Of Date parameter must be smaller than Period End Date';
        AsOfDateCantBeLowerPeriodStartDateErr: Label 'As Of Date parameter must be greater than Period Start Date';
}