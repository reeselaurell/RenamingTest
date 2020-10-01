page 14135160 lvngCompanyDataTransfer
{
    Caption = 'Company Data Transfer';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngCompanyDataTransfer;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Table ID"; Rec."Table ID") { Caption = 'Table ID'; ApplicationArea = All; }
                field("Table Name"; Rec."Table Name") { Caption = 'Table Name'; ApplicationArea = All; }
                field(Active; Rec.Active) { Caption = 'Active'; ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CopySetupToCompany)
            {
                ApplicationArea = All;
                Caption = 'Copy Setup To Company';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = codeunit lvngCreateNewCompany;
            }

            action(GetLoanVisionObjects)
            {
                ApplicationArea = All;
                Caption = 'Get Loan Vision Objects';
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TableMetaData: Record "Table Metadata";
                begin
                    TableMetaData.Reset();
                    TableMetaData.SetRange(ID, 1, 19999999);
                    TableMetaData.FindSet();
                    repeat
                        Clear(Rec);
                        Rec.Validate("Table ID", TableMetaData.ID);
                        if Rec.Insert() then;
                    until TableMetaData.Next() = 0;
                end;
            }
        }
    }
}