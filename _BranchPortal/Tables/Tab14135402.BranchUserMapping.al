table 14135402 lvngBranchUserMapping
{
    fields
    {
        field(1; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UserMgmt.ValidateUserID("User ID");
            end;

            trigger OnLookup()
            begin
                UserMgmt.LookupUserID("User ID");
            end;
        }
        field(2; Type; Enum lvngPortalLevel) { DataClassification = CustomerContent; }
        field(3; Code; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                LoanVisionSetup: Record lvngLoanVisionSetup;
                BusinessUnit: Record "Business Unit";
                DimensionValue: Record "Dimension Value";
            begin
                case Type of
                    Type::"Level 1":
                        begin
                            if LoanVisionSetup.lvngLevel1 = LoanVisionSetup.lvngLevel1::lvngBusinessUnit then begin
                                BusinessUnit.Reset();
                                if Page.RunModal(0, BusinessUnit) = Action::LookupOK then
                                    Code := BusinessUnit.Code;
                            end;
                            if LoanVisionSetup.lvngLevel1 = LoanVisionSetup.lvngLevel1::lvngDimension1 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 1);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel1 = LoanVisionSetup.lvngLevel1::lvngDimension2 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 2);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel1 = LoanVisionSetup.lvngLevel1::lvngDimension3 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 3);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel1 = LoanVisionSetup.lvngLevel1::lvngDimension4 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 4);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                        end;
                    Type::"Level 2":
                        begin
                            if LoanVisionSetup.lvngLevel2 = LoanVisionSetup.lvngLevel2::lvngBusinessUnit then begin
                                BusinessUnit.Reset();
                                if Page.RunModal(0, BusinessUnit) = Action::LookupOK then
                                    Code := BusinessUnit.Code;
                            end;
                            if LoanVisionSetup.lvngLevel2 = LoanVisionSetup.lvngLevel2::lvngDimension1 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 1);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel2 = LoanVisionSetup.lvngLevel2::lvngDimension2 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 2);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel2 = LoanVisionSetup.lvngLevel2::lvngDimension3 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 3);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel2 = LoanVisionSetup.lvngLevel2::lvngDimension4 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 4);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                        end;
                    Type::"Level 3":
                        begin
                            if LoanVisionSetup.lvngLevel3 = LoanVisionSetup.lvngLevel3::lvngBusinessUnit then begin
                                BusinessUnit.Reset();
                                if Page.RunModal(0, BusinessUnit) = Action::LookupOK then
                                    Code := BusinessUnit.Code;
                            end;
                            if LoanVisionSetup.lvngLevel3 = LoanVisionSetup.lvngLevel3::lvngDimension1 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 1);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel3 = LoanVisionSetup.lvngLevel3::lvngDimension2 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 2);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel3 = LoanVisionSetup.lvngLevel3::lvngDimension3 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 3);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel3 = LoanVisionSetup.lvngLevel3::lvngDimension4 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 4);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                        end;
                    Type::"Level 4":
                        begin
                            if LoanVisionSetup.lvngLevel4 = LoanVisionSetup.lvngLevel4::lvngBusinessUnit then begin
                                BusinessUnit.Reset();
                                if Page.RunModal(0, BusinessUnit) = Action::LookupOK then
                                    Code := BusinessUnit.Code;
                            end;
                            if LoanVisionSetup.lvngLevel4 = LoanVisionSetup.lvngLevel4::lvngDimension1 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 1);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel4 = LoanVisionSetup.lvngLevel4::lvngDimension2 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 2);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel4 = LoanVisionSetup.lvngLevel4::lvngDimension3 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 3);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel4 = LoanVisionSetup.lvngLevel4::lvngDimension4 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 4);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                        end;
                    Type::"Level 5":
                        begin
                            if LoanVisionSetup.lvngLevel5 = LoanVisionSetup.lvngLevel5::lvngBusinessUnit then begin
                                BusinessUnit.Reset();
                                if Page.RunModal(0, BusinessUnit) = Action::LookupOK then
                                    Code := BusinessUnit.Code;
                            end;
                            if LoanVisionSetup.lvngLevel5 = LoanVisionSetup.lvngLevel5::lvngDimension1 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 1);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel5 = LoanVisionSetup.lvngLevel5::lvngDimension2 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 2);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel5 = LoanVisionSetup.lvngLevel5::lvngDimension3 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 3);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                            if LoanVisionSetup.lvngLevel5 = LoanVisionSetup.lvngLevel5::lvngDimension4 then begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Global Dimension No.", 4);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                    Code := DimensionValue.Code;
                            end;
                        end;
                end;
            end;
        }
        field(4; Sequence; Integer) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "User ID", Type, Code) { Clustered = true; }
        key(Sequence; Sequence) { }
    }

    var
        UserMgmt: Codeunit "User Management";
}