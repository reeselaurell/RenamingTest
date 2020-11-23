page 14135158 "lvnLoanEscrowFields"
{
    PageType = ListPart;
    SourceTable = lvnEscrowFieldsMapping;
    Editable = false;
    Caption = 'Escrow Values';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        LoanValue: Record lvnLoanValue;
    begin
        Clear(Amount);
        if LoanValue.Get(LoanNo, Rec."Field No.") then
            Amount := LoanValue."Decimal Value";
    end;

    var
        LoanNo: Code[20];
        Amount: Decimal;

    procedure SetParams(LoanCode: Code[20])
    begin
        LoanNo := LoanCode;
        CurrPage.Update(false);
    end;
}