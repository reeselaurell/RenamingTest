table 14135156 lvngLoanNormalizedView
{
    Caption = 'Loan Normalized View';
    DataClassification = CustomerContent;
    LookupPageId = lvngJetExpressViewList;

    fields
    {
        field(1; "View Code"; Code[20]) { Caption = 'View Code'; DataClassification = CustomerContent; }
        field(2; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
        field(10; "Custom Text 1"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(10); }
        field(11; "Custom Text 2"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(11); }
        field(12; "Custom Text 3"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(12); }
        field(13; "Custom Text 4"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(13); }
        field(14; "Custom Text 5"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(14); }
        field(15; "Custom Text 6"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(15); }
        field(16; "Custom Text 7"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(16); }
        field(17; "Custom Text 8"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(17); }
        field(18; "Custom Text 9"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(18); }
        field(19; "Custom Text 10"; Text[250]) { DataClassification = CustomerContent; CaptionClass = GetCaption(19); }
        field(30; "Custom Decimal 1"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(30); }
        field(31; "Custom Decimal 2"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(31); }
        field(32; "Custom Decimal 3"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(32); }
        field(33; "Custom Decimal 4"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(33); }
        field(34; "Custom Decimal 5"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(34); }
        field(35; "Custom Decimal 6"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(35); }
        field(36; "Custom Decimal 7"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(36); }
        field(37; "Custom Decimal 8"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(37); }
        field(38; "Custom Decimal 9"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(38); }
        field(39; "Custom Decimal 10"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(39); }
        field(40; "Custom Decimal 11"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(40); }
        field(41; "Custom Decimal 12"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(41); }
        field(42; "Custom Decimal 13"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(42); }
        field(43; "Custom Decimal 14"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(43); }
        field(44; "Custom Decimal 15"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(44); }
        field(45; "Custom Decimal 16"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(45); }
        field(46; "Custom Decimal 17"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(46); }
        field(47; "Custom Decimal 18"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(47); }
        field(48; "Custom Decimal 19"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(48); }
        field(49; "Custom Decimal 20"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(49); }
        field(50; "Custom Decimal 21"; Decimal) { DataClassification = CustomerContent; CaptionClass = GetCaption(50); }
        field(100; "Custom Date 1"; Date) { DataClassification = CustomerContent; CaptionClass = GetCaption(100); }
        field(101; "Custom Date 2"; Date) { DataClassification = CustomerContent; CaptionClass = GetCaption(101); }
        field(102; "Custom Date 3"; Date) { DataClassification = CustomerContent; CaptionClass = GetCaption(102); }
        field(103; "Custom Date 4"; Date) { DataClassification = CustomerContent; CaptionClass = GetCaption(103); }
        field(104; "Custom Date 5"; Date) { DataClassification = CustomerContent; CaptionClass = GetCaption(104); }
        field(105; "Custom Date 6"; Date) { DataClassification = CustomerContent; CaptionClass = GetCaption(105); }
    }

    keys
    {
        key(PK; "View Code", "Loan No.") { Clustered = true; }
    }


    trigger OnDelete()
    var
        LoanNormalizedViewSetup: Record lvngLoanNormalizedViewSetup;
    begin
        LoanNormalizedViewSetup.Reset();
        LoanNormalizedViewSetup.SetRange(Code, Rec."View Code");
        LoanNormalizedViewSetup.DeleteAll();
    end;

    local procedure GetCaption(ViewFieldNo: Integer): Text
    var
        ViewTxt: Label 'MYVIEW';
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        LoanCustomNormViewSetup: Record lvngLoanNormalizedViewSetup;
        LoanFieldConfigurationFieldNo: Integer;
    begin
        "View Code" := ViewTxt;
        if LoanCustomNormViewSetup.Get("View Code") then begin
            case ViewFieldNo of
                10:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 1";
                11:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 2";
                12:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 3";
                13:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 4";
                14:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 5";
                15:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 6";
                16:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 7";
                17:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 8";
                18:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 9";
                19:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Text 10";
                30:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 1";
                31:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 2";
                32:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 3";
                33:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 4";
                34:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 5";
                35:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 6";
                36:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 7";
                37:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 8";
                38:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 9";
                39:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 10";
                40:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 11";
                41:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 12";
                42:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 13";
                43:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 14";
                44:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 15";
                45:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 16";
                46:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 17";
                47:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 18";
                48:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 19";
                49:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 20";
                50:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Decimal 21";
                100:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Date 1";
                101:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Date 2";
                102:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Date 3";
                103:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Date 4";
                104:
                    LoanFieldConfigurationFieldNo := LoanCustomNormViewSetup."Custom Date 5";
            end;
            if LoanFieldConfigurationFieldNo > 0 then
                if LoanFieldsConfiguration.Get(LoanFieldConfigurationFieldNo) then
                    exit(LoanFieldsConfiguration."Field Name");
        end;
        exit('');
    end;
}