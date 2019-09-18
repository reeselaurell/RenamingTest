page 14135159 lvngLoanEscrowFields
{

    PageType = ListPart;
    SourceTable = lvngEscrowFieldsMapping;
    Editable = false;
    Caption = 'Escrow Values';


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngAmount; lvngAmount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        Clear(lvngAmount);
        if lvngLoanValue.Get(lvngLoanNo, lvngFieldNo) then
            lvngAmount := lvngLoanValue.lvngDecimalValue;
    end;

    var
        lvngLoanValue: Record lvngLoanValue;
        lvngLoanNo: Code[20];
        lvngAmount: Decimal;


    procedure SetParams(lvngLoanNoParam: Code[20])
    begin
        lvngLoanNo := lvngLoanNoParam;
        CurrPage.Update(false);
    end;

}