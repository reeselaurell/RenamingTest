page 14135419 lvngLoanValuesWorksheet
{
    PageType = Worksheet;
    SourceTable = lvngLoan;
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group("Base Date")
            {
                field(BasedOn; BasedOn) { ApplicationArea = All; Caption = 'Base Date'; }
                field(DateFilter; DateFilter) { ApplicationArea = All; Caption = 'Date Filter'; }
            }
            repeater(Group)
            {
                Editable = false;

                field("Loan No."; lvngLoanNo) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        BasedOn: Enum lvngPerformanceBaseDate;
        DateFilter: Text;
}