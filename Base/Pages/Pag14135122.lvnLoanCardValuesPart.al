page 14135122 "lvnLoanCardValuesPart"
{
    Caption = 'Loan Values';
    PageType = ListPart;
    SourceTable = lvnLoanValue;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Field No."; Rec."Field No.") { ApplicationArea = All; }
                field(FieldDescription; FieldDescription) { ApplicationArea = All; Editable = false; Caption = 'Field Name'; }
                field("Field Value"; Rec."Field Value") { ApplicationArea = All; }
                field("Boolean Value"; Rec."Boolean Value") { ApplicationArea = All; Visible = false; }
                field("Date Value"; Rec."Date Value") { ApplicationArea = All; Visible = false; }
                field("Decimal Value"; Rec."Decimal Value") { ApplicationArea = All; Visible = false; }
                field("Integer Value"; Rec."Integer Value") { ApplicationArea = All; Visible = false; }
            }
        }
    }

    var
        TempLoanFieldsConfiguration: Record lvnLoanFieldsConfiguration temporary;
        FieldDescription: Text;

    trigger OnOpenPage()
    var
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
    begin
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then begin
            repeat
                TempLoanFieldsConfiguration := LoanFieldsConfiguration;
                TempLoanFieldsConfiguration.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        FieldDescription := '';
        if TempLoanFieldsConfiguration.Get(Rec."Field No.") then begin
            FieldDescription := TempLoanFieldsConfiguration."Field Name";
        end;
    end;
}