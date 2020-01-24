codeunit 14135122 lvngJetExpressViewMgmt
{
    procedure RefreshJetExpressView(ViewCode: Code[20])
    var
        ProcessingMsg: Label 'Processing #1######### of #2###########';
        LoanCustomNormViewSetup: Record lvngLoanNormalizedViewSetup;
        LoanCustomNormView: Record lvngLoanNormalizedView;
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        Loans: Record lvngLoan;
        Counter: Integer;
        Progress: Dialog;
    begin
        LoanCustomNormViewSetup.Get(ViewCode);
        LoanCustomNormViewSetup."Last Update DateTime" := CurrentDateTime;
        LoanCustomNormViewSetup."Last Updated By" := UserId;
        LoanCustomNormViewSetup.Modify();
        LoanCustomNormView.Reset();
        LoanCustomNormView.SetRange("View Code", ViewCode);
        LoanCustomNormView.DeleteAll();
        Progress.Open(ProcessingMsg);
        if Loans.FindSet() then begin
            Progress.Update(2, Loans.Count);
            repeat
                Counter := Counter + 1;
                Progress.Update(1, Counter);
                LoanCustomNormView."View Code" := ViewCode;
                LoanCustomNormView."Loan No." := Loans."No.";
                LoanCustomNormView."Custom Text 1" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 1");
                LoanCustomNormView."Custom Text 2" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 2");
                LoanCustomNormView."Custom Text 3" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 3");
                LoanCustomNormView."Custom Text 4" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 4");
                LoanCustomNormView."Custom Text 5" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 5");
                LoanCustomNormView."Custom Text 6" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 6");
                LoanCustomNormView."Custom Text 7" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 7");
                LoanCustomNormView."Custom Text 8" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 8");
                LoanCustomNormView."Custom Text 9" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 9");
                LoanCustomNormView."Custom Text 10" := GetTextValue(Loans."No.", LoanCustomNormViewSetup."Custom Text 10");
                LoanCustomNormView."Custom Decimal 1" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 1");
                LoanCustomNormView."Custom Decimal 2" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 2");
                LoanCustomNormView."Custom Decimal 3" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 3");
                LoanCustomNormView."Custom Decimal 4" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 4");
                LoanCustomNormView."Custom Decimal 5" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 5");
                LoanCustomNormView."Custom Decimal 6" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 6");
                LoanCustomNormView."Custom Decimal 7" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 7");
                LoanCustomNormView."Custom Decimal 8" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 8");
                LoanCustomNormView."Custom Decimal 9" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 9");
                LoanCustomNormView."Custom Decimal 10" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 10");
                LoanCustomNormView."Custom Decimal 11" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 11");
                LoanCustomNormView."Custom Decimal 12" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 12");
                LoanCustomNormView."Custom Decimal 13" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 13");
                LoanCustomNormView."Custom Decimal 14" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 14");
                LoanCustomNormView."Custom Decimal 15" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 15");
                LoanCustomNormView."Custom Decimal 16" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 16");
                LoanCustomNormView."Custom Decimal 17" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 17");
                LoanCustomNormView."Custom Decimal 18" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 18");
                LoanCustomNormView."Custom Decimal 19" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 19");
                LoanCustomNormView."Custom Decimal 20" := GetDecimalValue(Loans."No.", LoanCustomNormViewSetup."Custom Decimal 20");
                LoanCustomNormView."Custom Date 1" := GetDateValue(Loans."No.", LoanCustomNormViewSetup."Custom Date 1");
                LoanCustomNormView."Custom Date 2" := GetDateValue(Loans."No.", LoanCustomNormViewSetup."Custom Date 2");
                LoanCustomNormView."Custom Date 3" := GetDateValue(Loans."No.", LoanCustomNormViewSetup."Custom Date 3");
                LoanCustomNormView."Custom Date 4" := GetDateValue(Loans."No.", LoanCustomNormViewSetup."Custom Date 4");
                LoanCustomNormView."Custom Date 5" := GetDateValue(Loans."No.", LoanCustomNormViewSetup."Custom Date 5");
                LoanCustomNormView.Insert(true);
            until Loans.Next() = 0;
        end;
        Progress.Close();
    end;

    local procedure GetTextValue(LoanNo: Code[20]; FieldNo: Integer) FieldValue: Text[250]
    var
        LoanValue: Record lvngLoanValue;
    begin
        if FieldNo > 0 then
            if LoanValue.Get(LoanNo, FieldNo) then
                exit(LoanValue."Field Value")
            else
                exit('')
        else
            exit('');
    end;

    local procedure GetDecimalValue(LoanNo: Code[20]; FieldNo: Integer) FieldValue: Decimal
    var
        LoanValue: Record lvngLoanValue;
    begin
        if FieldNo > 0 then
            if LoanValue.Get(LoanNo, FieldNo) then
                exit(LoanValue."Decimal Value")
            else
                exit(0)
        else
            exit(0);
    end;

    local procedure GetDateValue(LoanNo: Code[20]; FieldNo: Integer) FieldValue: Date
    var
        LoanValue: Record lvngLoanValue;
    begin
        if FieldNo > 0 then
            if LoanValue.Get(LoanNo, FieldNo) then
                exit(LoanValue."Date Value")
            else
                exit(0D)
        else
            exit(0D);
    end;

    local procedure GetCaption(var LoanCustNormView: Record lvngLoanNormalizedView; FieldNo: Integer) CaptionValue: Text[50]
    begin
        case FieldNo of
            10:
                exit(LoanCustNormView.FieldCaption("Custom Text 1"));
            11:
                exit(LoanCustNormView.FieldCaption("Custom Text 2"));
            12:
                exit(LoanCustNormView.FieldCaption("Custom Text 3"));
            13:
                exit(LoanCustNormView.FieldCaption("Custom Text 4"));
            14:
                exit(LoanCustNormView.FieldCaption("Custom Text 5"));
            15:
                exit(LoanCustNormView.FieldCaption("Custom Text 6"));
            16:
                exit(LoanCustNormView.FieldCaption("Custom Text 7"));
            17:
                exit(LoanCustNormView.FieldCaption("Custom Text 8"));
            18:
                exit(LoanCustNormView.FieldCaption("Custom Text 9"));
            19:
                exit(LoanCustNormView.FieldCaption("Custom Text 10"));
            30:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 1"));
            31:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 2"));
            32:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 3"));
            33:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 4"));
            34:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 5"));
            35:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 6"));
            36:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 7"));
            37:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 8"));
            38:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 9"));
            39:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 10"));
            40:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 11"));
            41:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 12"));
            42:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 13"));
            43:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 14"));
            44:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 15"));
            45:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 16"));
            46:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 17"));
            47:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 18"));
            48:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 19"));
            49:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 20"));
            50:
                exit(LoanCustNormView.FieldCaption("Custom Decimal 21"));
            100:
                exit(LoanCustNormView.FieldCaption("Custom Date 1"));
            101:
                exit(LoanCustNormView.FieldCaption("Custom Date 2"));
            102:
                exit(LoanCustNormView.FieldCaption("Custom Date 3"));
            103:
                exit(LoanCustNormView.FieldCaption("Custom Date 4"));
            104:
                exit(LoanCustNormView.FieldCaption("Custom Date 5"));
        end
    end;

}