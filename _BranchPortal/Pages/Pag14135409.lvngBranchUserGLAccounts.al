page 14135409 lvngBranchUserGLAccounts
{
    PageType = List;
    SourceTable = lvngBranchUserGLMapping;
    Caption = 'Branch User G/L Accounts';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("G/L Account No."; "G/L Account No.") { ApplicationArea = All; }
                field("G/L Account Name"; "G/L Account Name") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Retrieve)
            {
                Caption = 'Retrieve Accounts';
                Image = Restore;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                var
                    RetrieveGLAccountsMapping: Report lvngRetrieveGLAccountsMapping;
                begin
                    Clear(RetrieveGLAccountsMapping);
                    RetrieveGLAccountsMapping.SetParams("User ID");
                    RetrieveGLAccountsMapping.RunModal();
                end;
            }
        }
    }
}