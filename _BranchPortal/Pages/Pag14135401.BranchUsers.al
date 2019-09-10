page 14135401 lvngBranchUsers
{
    PageType = List;
    SourceTable = lvngBranchUser;
    Caption = 'Branch Users';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID") { ApplicationArea = All; }
                field("Super User"; "Super User") { ApplicationArea = All; }
                field("E-Mail"; "E-Mail") { ApplicationArea = All; }
                field("Show Loan Funding Report"; "Show Loan Funding Report") { ApplicationArea = All; }
                field("Show Account Schedule"; "Show Account Schedule") { ApplicationArea = All; }
                field("Loan Level Report Schema Code"; "Loan Level Report Schema Code") { ApplicationArea = All; }
                field("Hide General Ledger"; "Hide General Ledger") { ApplicationArea = All; }
                field("Hide KPI"; "Hide KPI") { ApplicationArea = All; }
                field("Hide Performance Worksheet"; "Hide Performance Worksheet") { ApplicationArea = All; }
                field("Regenerate Permissions"; "Regenerate Permissions") { ApplicationArea = All; }
                field("Show Corporate Tile"; "Show Corporate Tile") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UserMapping)
            {
                Caption = 'User Mapping';
                Image = MapDimensions;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page lvngBranchUserMapping;
                RunPageView = sorting ("User ID", Type, Code);
                RunPageLink = "User ID" = field ("User ID");
                ApplicationArea = All;
            }
            action(PerformanceMapping)
            {
                Caption = 'Performance Mapping';
                Image = MapDimensions;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page lvngBranchPerfSchemaMapping;
                RunPageLink = "User ID" = field ("User ID");
                RunPageView = sorting ("User ID", "Schema Code");
                ApplicationArea = All;
            }
            action(CopyFrom)
            {
                Caption = 'Copy From';
                Image = CopyToTask;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FromRecord: Record lvngBranchUser;
                    FromRecordLines: Record lvngBranchUserMapping;
                    ToRecordLines: Record lvngBranchUserMapping;
                begin
                    if Page.RunModal(0, FromRecord) = Action::LookupOK then begin
                        FromRecordLines.Reset();
                        FromRecordLines.SetRange("User ID", FromRecord."User ID");
                        if FromRecordLines.FindSet() then
                            repeat
                                ToRecordLines := FromRecordLines;
                                ToRecordLines."User ID" := "User ID";
                                ToRecordLines.Insert();
                            until FromRecordLines.Next() = 0;
                        RegeneratePermissions("User ID");
                    end;
                end;
            }
            action(GeneratePermissions)
            {
                Caption = 'Generate Permissions';
                Image = Permission;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    RegeneratePermissions('');
                    Message(CompletedMsg);
                end;
            }
        }
    }

    var
        CompletedMsg: Label 'Completed!';
        Level1PrefixCodeTok: Label '1_100001';
        Level2PrefixCodeTok: Label '2_100001';
        Level3PrefixCodeTok: Label '3_100001';
        Level4PrefixCodeTok: Label '4_100001';

    procedure RegeneratePermissions(CurrentUserID: Code[50])
    var
        BranchPortalSetup: Record lvngBranchPortalSetup;
        BranchUser: Record lvngBranchUser;
        BranchUserMapping: Record lvngBranchUserMapping;
        PortalFilterPrefix: Record lvngPortalFilterPrefix;
        AccessControl: Record "Access Control";
        PermissionSet: Record "Permission Set";
        UserPermission: Record Permission;
        Permission: Record Permission;
        User: Record User;
        Filter: Text;
        NewCode: Code[10];
        PermissionCode: Code[20];
    begin
        BranchPortalSetup.Get();
        BranchUser.Reset();
        if CurrentUserID = '' then
            BranchUser.SetRange("Regenerate Permissions", true)
        else
            BranchUser.SetRange("User ID", CurrentUserID);
        if BranchUser.FindSet(true) then
            repeat
                if BranchUser."Super User" then begin
                    BranchUser."Level 1 Filter Prefix" := '';
                    BranchUser."Level 2 Filter Prefix" := '';
                    BranchUser."Level 3 Filter Prefix" := '';
                    BranchUser."Level 4 Filter Prefix" := '';
                    BranchUser.Modify();
                end else begin
                    BranchUserMapping.Reset();
                    BranchUserMapping.SetRange("User ID", BranchUser."User ID");
                    BranchUserMapping.SetRange(Type, BranchUserMapping.Type::"Level 1");
                    if not BranchUserMapping.IsEmpty() then begin
                        Filter := '';
                        BranchUserMapping.FindSet();
                        repeat
                            Filter := Filter + BranchUserMapping.Code + '!';
                        until BranchUserMapping.Next() = 0;
                        Filter := DelChr(Filter, '>', '!');
                        PortalFilterPrefix.Reset();
                        PortalFilterPrefix.SetRange(Type, PortalFilterPrefix.Type::"Level 1");
                        PortalFilterPrefix.SetRange(Filter, Filter);
                        if PortalFilterPrefix.IsEmpty() then begin
                            PortalFilterPrefix.Reset();
                            PortalFilterPrefix.SetRange(Type, PortalFilterPrefix.Type::"Level 1");
                            if PortalFilterPrefix.FindLast() then
                                NewCode := CopyStr(IncStr(PortalFilterPrefix."Prefix Code"), 1, MaxStrLen(NewCode))
                            else
                                NewCode := BranchPortalSetup."Permission Identifier" + Level1PrefixCodeTok;
                            Clear(PortalFilterPrefix);
                            PortalFilterPrefix.Type := PortalFilterPrefix.Type::"Level 1";
                            PortalFilterPrefix."Prefix Code" := NewCode;
                            PortalFilterPrefix.Filter := CopyStr(Filter, 1, MaxStrLen((PortalFilterPrefix.Filter)));
                            PortalFilterPrefix.Insert();
                        end else
                            PortalFilterPrefix.FindLast();
                        BranchUser."Level 1 Filter Prefix" := PortalFilterPrefix."Prefix Code";
                        BranchUser."Level 2 Filter Prefix" := '';
                        BranchUser."Level 3 Filter Prefix" := '';
                        BranchUser."Level 4 Filter Prefix" := '';
                        BranchUser.Modify();
                    end else begin
                        BranchUserMapping.SetRange(Type, BranchUserMapping.Type::"Level 2");
                        if not BranchUserMapping.IsEmpty() then begin
                            Filter := '';
                            BranchUserMapping.FindSet();
                            repeat
                                Filter := Filter + BranchUserMapping.Code + '!';
                            until BranchUserMapping.Next() = 0;
                            Filter := DelChr(Filter, '>', '!');
                            PortalFilterPrefix.Reset();
                            PortalFilterPrefix.SetRange(Type, PortalFilterPrefix.Type::"Level 2");
                            PortalFilterPrefix.SetRange(Filter, Filter);
                            if PortalFilterPrefix.IsEmpty() then begin
                                PortalFilterPrefix.Reset();
                                PortalFilterPrefix.SetRange(Type, PortalFilterPrefix.Type::"Level 1");
                                if PortalFilterPrefix.FindLast() then
                                    NewCode := CopyStr(IncStr(PortalFilterPrefix."Prefix Code"), 1, MaxStrLen(NewCode))
                                else
                                    NewCode := BranchPortalSetup."Permission Identifier" + Level2PrefixCodeTok;
                                Clear(PortalFilterPrefix);
                                PortalFilterPrefix.Type := PortalFilterPrefix.Type::"Level 2";
                                PortalFilterPrefix."Prefix Code" := NewCode;
                                PortalFilterPrefix.Filter := CopyStr(Filter, 1, MaxStrLen(PortalFilterPrefix.Filter));
                                PortalFilterPrefix.Insert();
                            end else
                                PortalFilterPrefix.FindLast();
                            BranchUser."Level 1 Filter Prefix" := '';
                            BranchUser."Level 2 Filter Prefix" := PortalFilterPrefix."Prefix Code";
                            BranchUser."Level 3 Filter Prefix" := '';
                            BranchUser."Level 4 Filter Prefix" := '';
                            BranchUser.Modify();
                        end else begin
                            BranchUserMapping.SetRange(Type, BranchUserMapping.Type::"Level 3");
                            if not BranchUserMapping.IsEmpty() then begin
                                Filter := '';
                                BranchUserMapping.FindSet();
                                repeat
                                    Filter := Filter + BranchUserMapping.Code + '!';
                                until BranchUserMapping.Next() = 0;
                                Filter := DelChr(Filter, '>', '!');
                                PortalFilterPrefix.Reset();
                                PortalFilterPrefix.SetRange(Type, PortalFilterPrefix.Type::"Level 3");
                                PortalFilterPrefix.SetRange(Filter, Filter);
                                if PortalFilterPrefix.IsEmpty() then begin
                                    PortalFilterPrefix.Reset();
                                    PortalFilterPrefix.SetRange(Type, PortalFilterPrefix.Type::"Level 3");
                                    if PortalFilterPrefix.FindLast() then
                                        NewCode := CopyStr(IncStr(PortalFilterPrefix."Prefix Code"), 1, MaxStrLen(NewCode))
                                    else
                                        NewCode := BranchPortalSetup."Permission Identifier" + Level3PrefixCodeTok;
                                    Clear(PortalFilterPrefix);
                                    PortalFilterPrefix.Type := PortalFilterPrefix.Type::"Level 3";
                                    PortalFilterPrefix."Prefix Code" := NewCode;
                                    PortalFilterPrefix.Filter := CopyStr(Filter, 1, MaxStrLen(PortalFilterPrefix.Filter));
                                    PortalFilterPrefix.Insert();
                                end else
                                    PortalFilterPrefix.FindLast();
                                BranchUser."Level 1 Filter Prefix" := '';
                                BranchUser."Level 2 Filter Prefix" := '';
                                BranchUser."Level 3 Filter Prefix" := PortalFilterPrefix."Prefix Code";
                                BranchUser."Level 4 Filter Prefix" := '';
                                BranchUser.Modify();
                            end else begin
                                BranchUserMapping.SetRange(Type, BranchUserMapping.Type::"Level 4");
                                if not BranchUserMapping.IsEmpty() then begin
                                    Filter := '';
                                    BranchUserMapping.FindSet();
                                    repeat
                                        Filter := Filter + BranchUserMapping.Code + '!';
                                    until BranchUserMapping.Next() = 0;
                                    Filter := DelChr(Filter, '>', '!');
                                    PortalFilterPrefix.Reset();
                                    PortalFilterPrefix.SetRange(Type, PortalFilterPrefix.Type::"Level 4");
                                    PortalFilterPrefix.SetRange(Filter, Filter);
                                    if PortalFilterPrefix.IsEmpty() then begin
                                        PortalFilterPrefix.Reset();
                                        PortalFilterPrefix.SetRange(Type, PortalFilterPrefix.Type::"Level 4");
                                        if PortalFilterPrefix.FindLast() then
                                            NewCode := CopyStr(IncStr(PortalFilterPrefix."Prefix Code"), 1, MaxStrLen(NewCode))
                                        else
                                            NewCode := BranchPortalSetup."Permission Identifier" + Level4PrefixCodeTok;
                                        Clear(PortalFilterPrefix);
                                        PortalFilterPrefix.Type := PortalFilterPrefix.Type::"Level 4";
                                        PortalFilterPrefix."Prefix Code" := NewCode;
                                        PortalFilterPrefix.Filter := CopyStr(Filter, 1, MaxStrLen(PortalFilterPrefix.Filter));
                                        PortalFilterPrefix.Insert();
                                    end else
                                        PortalFilterPrefix.FindLast();
                                    BranchUser."Level 1 Filter Prefix" := '';
                                    BranchUser."Level 2 Filter Prefix" := '';
                                    BranchUser."Level 3 Filter Prefix" := '';
                                    BranchUser."Level 4 Filter Prefix" := PortalFilterPrefix."Prefix Code";
                                    BranchUser.Modify();
                                end;
                            end;
                        end;
                    end;
                end;
            until BranchUser.Next() = 0;
        BranchUser.Reset();
        if CurrentUserID <> '' then
            BranchUser.SetRange("User ID", CurrentUserID);
        BranchUser.FindSet();
        repeat
            if BranchUser."Regenerate Permissions" or (CurrentUserID <> '') then begin
                User.Reset();
                User.SetRange("User Name", BranchUser."User ID");
                User.FindFirst();
                if BranchUser."Super User" then begin
                    AccessControl.Reset();
                    AccessControl.SetRange("User Security ID", User."User Security ID");
                    AccessControl.DeleteAll();
                    Clear(AccessControl);
                    AccessControl.Init();
                    AccessControl."User Security ID" := user."User Security ID";
                    AccessControl."Role ID" := 'SUPER';
                    AccessControl.Insert();
                end else begin
                    BranchPortalSetup.TestField("Basic Permission Set");
                    BranchPortalSetup.TestField("Level 1 Permission Set");
                    BranchPortalSetup.TestField("Level 2 Permission Set");
                    BranchPortalSetup.TestField("Level 3 Permission Set");
                    BranchPortalSetup.TestField("Level 4 Permission Set");
                    AccessControl.Reset();
                    AccessControl.SetRange("User Security ID", User."User Security ID");
                    AccessControl.SetFilter("Role ID", '*-' + BranchPortalSetup."Level 4 Permission Set");
                    AccessControl.SetRange("Company Name", CompanyName());
                    AccessControl.DeleteAll();
                    AccessControl.Reset();
                    AccessControl.SetRange("User Security ID", User."User Security ID");
                    AccessControl.SetFilter("Role ID", '*-' + BranchPortalSetup."Level 3 Permission Set");
                    AccessControl.SetRange("Company Name", CompanyName());
                    AccessControl.DeleteAll();
                    AccessControl.Reset();
                    AccessControl.SetRange("User Security ID", User."User Security ID");
                    AccessControl.SetFilter("Role ID", '*-' + BranchPortalSetup."Level 2 Permission Set");
                    AccessControl.SetRange("Company Name", CompanyName());
                    AccessControl.DeleteAll();
                    AccessControl.Reset();
                    AccessControl.SetRange("User Security ID", User."User Security ID");
                    AccessControl.SetFilter("Role ID", '*-' + BranchPortalSetup."Level 1 Permission Set");
                    AccessControl.SetRange("Company Name", CompanyName());
                    AccessControl.DeleteAll();

                    Clear(AccessControl);
                    AccessControl.Init();
                    AccessControl."User Security ID" := user."User Security ID";
                    AccessControl."Role ID" := BranchPortalSetup."Basic Permission Set";
                    if AccessControl.Insert() then;
                    if BranchUser."Level 4 Filter Prefix" <> '' then begin
                        PortalFilterPrefix.Get(PortalFilterPrefix.Type::"Level 4", BranchUser."Level 4 Filter Prefix");
                        PermissionCode := BranchUser."Level 4 Filter Prefix" + '-' + BranchPortalSetup."Level 4 Permission Set";
                        PermissionSet.Reset();
                        PermissionSet.SetRange("Role ID", PermissionCode);
                        if not PermissionSet.IsEmpty() then begin
                            AccessControl.Init();
                            AccessControl."User Security ID" := User."User Security ID";
                            AccessControl."Role ID" := PermissionCode;
                            AccessControl."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(AccessControl."Company Name"));
                            AccessControl.Insert();
                        end else begin
                            Clear(PermissionSet);
                            PermissionSet."Role ID" := PermissionCode;
                            PermissionSet.Name := CopyStr(ConvertStr(PortalFilterPrefix.Filter, '!', ','), 1, MaxStrLen(PermissionSet.Name));
                            PermissionSet.Insert();
                            UserPermission.Reset();
                            UserPermission.SetRange("Role ID", BranchPortalSetup."Level 4 Permission Set");
                            UserPermission.FindSet();
                            repeat
                                Permission := UserPermission;
                                Permission."Role ID" := PermissionCode;
                                if Format(Permission."Security Filter") <> '' then
                                    Evaluate(Permission."Security Filter", StringReplace(Format(Permission."Security Filter"), '$FILTER$', PortalFilterPrefix.Filter));
                                Permission.Insert();
                            until UserPermission.Next() = 0;
                            AccessControl.Init();
                            AccessControl."User Security ID" := user."User Security ID";
                            AccessControl."Role ID" := PermissionCode;
                            AccessControl."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(AccessControl."Company Name"));
                            AccessControl.Insert();
                        end;
                    end;
                    if BranchUser."Level 3 Filter Prefix" <> '' then begin
                        PortalFilterPrefix.Get(PortalFilterPrefix.Type::"Level 3", BranchUser."Level 3 Filter Prefix");
                        PermissionCode := BranchUser."Level 3 Filter Prefix" + '-' + BranchPortalSetup."Level 3 Permission Set";
                        PermissionSet.Reset();
                        PermissionSet.SetRange("Role ID", PermissionCode);
                        if not PermissionSet.IsEmpty() then begin
                            AccessControl.Init();
                            AccessControl."User Security ID" := User."User Security ID";
                            AccessControl."Role ID" := PermissionCode;
                            AccessControl."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(AccessControl."Company Name"));
                            AccessControl.Insert();
                        end else begin
                            Clear(PermissionSet);
                            PermissionSet."Role ID" := PermissionCode;
                            PermissionSet.Name := CopyStr(ConvertStr(PortalFilterPrefix.Filter, '!', ','), 1, MaxStrLen(PermissionSet.Name));
                            PermissionSet.Insert();
                            UserPermission.Reset();
                            UserPermission.SetRange("Role ID", BranchPortalSetup."Level 3 Permission Set");
                            UserPermission.FindSet();
                            repeat
                                Permission := UserPermission;
                                Permission."Role ID" := PermissionCode;
                                if Format(Permission."Security Filter") <> '' then
                                    Evaluate(Permission."Security Filter", StringReplace(Format(Permission."Security Filter"), '$FILTER$', PortalFilterPrefix.Filter));
                                Permission.Insert();
                            until UserPermission.Next() = 0;
                            AccessControl.Init();
                            AccessControl."User Security ID" := user."User Security ID";
                            AccessControl."Role ID" := PermissionCode;
                            AccessControl."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(AccessControl."Company Name"));
                            AccessControl.Insert();
                        end;
                    end;
                    if BranchUser."Level 2 Filter Prefix" <> '' then begin
                        PortalFilterPrefix.Get(PortalFilterPrefix.Type::"Level 2", BranchUser."Level 2 Filter Prefix");
                        PermissionCode := BranchUser."Level 2 Filter Prefix" + '-' + BranchPortalSetup."Level 2 Permission Set";
                        PermissionSet.Reset();
                        PermissionSet.SetRange("Role ID", PermissionCode);
                        if not PermissionSet.IsEmpty() then begin
                            AccessControl.Init();
                            AccessControl."User Security ID" := User."User Security ID";
                            AccessControl."Role ID" := PermissionCode;
                            AccessControl."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(AccessControl."Company Name"));
                            AccessControl.Insert();
                        end else begin
                            Clear(PermissionSet);
                            PermissionSet."Role ID" := PermissionCode;
                            PermissionSet.Name := CopyStr(ConvertStr(PortalFilterPrefix.Filter, '!', ','), 1, MaxStrLen(PermissionSet.Name));
                            PermissionSet.Insert();
                            UserPermission.Reset();
                            UserPermission.SetRange("Role ID", BranchPortalSetup."Level 2 Permission Set");
                            UserPermission.FindSet();
                            repeat
                                Permission := UserPermission;
                                Permission."Role ID" := PermissionCode;
                                if Format(Permission."Security Filter") <> '' then
                                    Evaluate(Permission."Security Filter", StringReplace(Format(Permission."Security Filter"), '$FILTER$', PortalFilterPrefix.Filter));
                                Permission.Insert();
                            until UserPermission.Next() = 0;
                            AccessControl.Init();
                            AccessControl."User Security ID" := user."User Security ID";
                            AccessControl."Role ID" := PermissionCode;
                            AccessControl."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(AccessControl."Company Name"));
                            AccessControl.Insert();
                        end;
                    end;
                    if BranchUser."Level 1 Filter Prefix" <> '' then begin
                        PortalFilterPrefix.Get(PortalFilterPrefix.Type::"Level 1", BranchUser."Level 1 Filter Prefix");
                        PermissionCode := BranchUser."Level 1 Filter Prefix" + '-' + BranchPortalSetup."Level 1 Permission Set";
                        PermissionSet.Reset();
                        PermissionSet.SetRange("Role ID", PermissionCode);
                        if not PermissionSet.IsEmpty() then begin
                            AccessControl.Init();
                            AccessControl."User Security ID" := User."User Security ID";
                            AccessControl."Role ID" := PermissionCode;
                            AccessControl."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(AccessControl."Company Name"));
                            AccessControl.Insert();
                        end else begin
                            Clear(PermissionSet);
                            PermissionSet."Role ID" := PermissionCode;
                            PermissionSet.Name := CopyStr(ConvertStr(PortalFilterPrefix.Filter, '!', ','), 1, MaxStrLen(PermissionSet.Name));
                            PermissionSet.Insert();
                            UserPermission.Reset();
                            UserPermission.SetRange("Role ID", BranchPortalSetup."Level 1 Permission Set");
                            UserPermission.FindSet();
                            repeat
                                Permission := UserPermission;
                                Permission."Role ID" := PermissionCode;
                                if Format(Permission."Security Filter") <> '' then
                                    Evaluate(Permission."Security Filter", StringReplace(Format(Permission."Security Filter"), '$FILTER$', PortalFilterPrefix.Filter));
                                Permission.Insert();
                            until UserPermission.Next() = 0;
                            AccessControl.Init();
                            AccessControl."User Security ID" := user."User Security ID";
                            AccessControl."Role ID" := PermissionCode;
                            AccessControl."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(AccessControl."Company Name"));
                            AccessControl.Insert();
                        end;
                    end;
                end;
                BranchUser."Regenerate Permissions" := false;
                BranchUser.Modify();
            end;
        until BranchUser.Next() = 0;
    end;

    local procedure StringReplace(String: Text; FindWhat: Text; ReplaceWith: Text): Text
    var
        Pos: Integer;
        Len: Integer;
    begin
        ReplaceWith := ConvertStr(ReplaceWith, '!', '|');
        Pos := StrPos(String, FindWhat);
        Len := StrLen(FindWhat);
        while Pos > 0 do begin
            String := DelStr(String, Pos) + ReplaceWith + CopyStr(String, Pos + Len);
            Pos := StrPos(String, FindWhat);
        end;
        exit(String);
    end;
}