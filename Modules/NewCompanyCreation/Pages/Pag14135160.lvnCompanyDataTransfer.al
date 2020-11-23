page 14135160 "lvnCompanyDataTransfer"
{
    Caption = 'Company Data Transfer';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnCompanyDataTransfer;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Table ID"; Rec."Table ID")
                {
                    Caption = 'Table ID';
                    ApplicationArea = All;
                }
                field("Table Name"; Rec."Table Name")
                {
                    Caption = 'Table Name';
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    Caption = 'Active';
                    ApplicationArea = All;
                }
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
                RunObject = codeunit lvnCreateNewCompany;
            }
            action(GetLoanVisionObjects)
            {
                ApplicationArea = All;
                Caption = 'Get Loan Vision Objects';
                Image = AddAction;

                trigger OnAction()
                var
                    TableMetaData: Record "Table Metadata";
                begin
                    TableMetaData.Reset();
                    TableMetaData.SetRange(Id, 1, 19999999);
                    TableMetaData.FindSet();
                    repeat
                        Clear(Rec);
                        Rec.Validate("Table ID", TableMetaData.Id);
                        if Rec.Insert() then;
                    until TableMetaData.Next() = 0;
                end;
            }
        }
    }
}