page 14135158 lvngLoanEscrowFields
{

    PageType = ListPart;
    SourceTable = lvngEscrowFieldsMapping;
    Editable = false;
    Caption = 'Escrow Values';


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description) { Caption = 'Description'; ApplicationArea = All; }
                field(Amount; Amount) { Caption = 'Amount'; ApplicationArea = All; }
            }
        }
    }

    var
        LoanNo: Code[20];
        Amount: Decimal;

    trigger OnAfterGetRecord()
    var
        LoanValue: Record lvngLoanValue;
    begin
        Clear(Amount);
        if LoanValue.Get(LoanNo, Rec."Field No.") then
            Amount := LoanValue."Decimal Value";
    end;

    procedure SetParams(LoanCode: Code[20])
    begin
        LoanNo := LoanCode;
        CurrPage.Update(false);
    end;
}
