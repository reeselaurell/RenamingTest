report 14135401 lvngRetrieveGLAccountsMapping
{
    Caption = 'Retrieve G/L Accounts Mapping';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(AccountScheduleName; AccountScheduleName.Name) { ApplicationArea = All; Caption = 'Account Schedule'; TableRelation = "Acc. Schedule Name".Name; }
            }
        }
    }

    var
        BranchUser: Record lvngBranchUser;
        AccountScheduleName: Record "Acc. Schedule Name";

    trigger OnPreReport()
    var
        AccountScheduleLine: Record "Acc. Schedule Line";
        GLAccount: Record "G/L Account";
        BranchUserGLMapping: Record lvngBranchUserGLMapping;
    begin
        AccountScheduleName.Get(AccountScheduleName.Name);
        AccountScheduleLine.Reset();
        AccountScheduleLine.SetRange("Schedule Name", AccountScheduleName.Name);
        AccountScheduleLine.SetRange("Totaling Type", AccountScheduleLine."Totaling Type"::"Posting Accounts");
        AccountScheduleLine.FindSet();
        repeat
            if AccountScheduleLine.Totaling <> '' then begin
                GLAccount.Reset();
                GLAccount.SetFilter("No.", AccountScheduleLine.Totaling);
                if GLAccount.FindSet() then
                    repeat
                        Clear(BranchUserGLMapping);
                        BranchUserGLMapping."User ID" := BranchUser."User ID";
                        BranchUserGLMapping."G/L Account No." := GLAccount."No.";
                        if BranchUserGLMapping.Insert() then;
                    until GLAccount.Next() = 0;
            end;
        until AccountScheduleLine.Next() = 0;
    end;

    procedure SetParams(User: Code[50])
    begin
        BranchUser.Get(User);
    end;
}