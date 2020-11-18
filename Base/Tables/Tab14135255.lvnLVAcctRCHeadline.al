table 14135255 "lvnLVAcctRCHeadline"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            DataClassification = CustomerContent;
        }
        field(2; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(10; "Net Change"; Decimal)
        {
            Caption = 'Net Change';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Dimension Code", Code) { Clustered = true; }
        key(Name; Name) { }
    }

    procedure FillDimensions()
    var
        DimensionValue: Record "Dimension Value";
        LoanVisionSetup: Record lvnLoanVisionSetup;
    begin
        Reset();
        DeleteAll();
        LoanVisionSetup.Get();
        DimensionValue.Reset();
        DimensionValue.SetRange(Blocked, false);
        DimensionValue.SetRange(Totaling, '');
        DimensionValue.SetFilter("Dimension Code", '%1|%2', LoanVisionSetup."Cost Center Dimension Code", LoanVisionSetup."Loan Officer Dimension Code");
        if DimensionValue.FindSet() then
            repeat
                "Dimension Code" := DimensionValue."Dimension Code";
                Code := DimensionValue.Code;
                Name := DimensionValue.Name;
                Insert();
            until DimensionValue.Next() = 0;
    end;

    procedure SetNetChange()
    var
        GLAccount: Record "G/L Account";
    begin
        Reset();
        FindSet();
        repeat
            GLAccount.Reset();
            SetGLAccountFilters(GLAccount, "Dimension Code", Code);
            if GLAccount.FindSet() then begin
                GLAccount.CalcFields("Net Change");
                "Net Change" := GLAccount."Net Change";
                Modify();
            end;
        until Next() = 0;
    end;

    procedure SetGLAccountFilters(var GLAccount: Record "G/L Account"; DimCode: Code[20]; DimValueCode: Code[20])
    var
        HeadlineSetup: Record lvnLVAcctRCHeadlineSetup;
        DimensionMgmt: Codeunit lvnDimensionsManagement;
        DimNo: Integer;
        DateFilter: Text;
    begin
        HeadlineSetup.Get();
        DimNo := DimensionMgmt.GetDimensionNo(DimCode);
        case DimNo of
            1:
                GLAccount.SetFilter("Global Dimension 1 Filter", DimValueCode);
            2:
                GLAccount.SetFilter("Global Dimension 2 Filter", DimValueCode);
        end;
        DateFilter := GetDateFilter(DimCode);
        GLAccount.SetFilter("Date Filter", DateFilter);
        GLAccount.SetRange("No.", HeadlineSetup."Net Income G/L Account No.");
    end;

    procedure GetDateFilter(DimensionCode: Code[20]): Text
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        HeadlineSetup: Record lvnLVAcctRCHeadlineSetup;
    begin
        HeadlineSetup.Get();
        LoanVisionSetup.Get();
        if DimensionCode = LoanVisionSetup."Cost Center Dimension Code" then
            case HeadlineSetup."Branch Performace Date Range" of
                HeadlineSetup."Branch Performace Date Range"::"Year to Date":
                    exit('-CY..t');
                HeadlineSetup."Branch Performace Date Range"::"Quarter to Date":
                    exit('-CQ..t');
                HeadlineSetup."Branch Performace Date Range"::"Month to Date":
                    exit('-CM..t');
                HeadlineSetup."Branch Performace Date Range"::"Week to Date":
                    exit('-CW..t');
                else
                    exit('');
            end
        else
            case HeadlineSetup."LO Performace Date Range" of
                HeadlineSetup."LO Performace Date Range"::"Year to Date":
                    exit('-CY..t');
                HeadlineSetup."LO Performace Date Range"::"Quarter to Date":
                    exit('-CQ..t');
                HeadlineSetup."LO Performace Date Range"::"Month to Date":
                    exit('-CM..t');
                HeadlineSetup."LO Performace Date Range"::"Week to Date":
                    exit('-CW..t');
                else
                    exit('');
            end;
    end;

    procedure GetBranchInsightText(): Text
    var
        HeadlineSetup: Record lvnLVAcctRCHeadlineSetup;
    begin
        HeadlineSetup.Get();
        case HeadlineSetup."Branch Performace Date Range" of
            HeadlineSetup."Branch Performace Date Range"::"Year to Date":
                exit('YTD');
            HeadlineSetup."Branch Performace Date Range"::"Quarter to Date":
                exit('QTD');
            HeadlineSetup."Branch Performace Date Range"::"Month to Date":
                exit('MTD');
            HeadlineSetup."Branch Performace Date Range"::"Week to Date":
                exit('WTD');
            else
                exit('ALL TIME');
        end;
    end;

    procedure GetLOInsightText(): Text
    var
        HeadlineSetup: Record lvnLVAcctRCHeadlineSetup;
    begin
        HeadlineSetup.Get();
        case HeadlineSetup."LO Performace Date Range" of
            HeadlineSetup."LO Performace Date Range"::"Year to Date":
                exit('YTD');
            HeadlineSetup."LO Performace Date Range"::"Quarter to Date":
                exit('QTD');
            HeadlineSetup."LO Performace Date Range"::"Month to Date":
                exit('MTD');
            HeadlineSetup."LO Performace Date Range"::"Week to Date":
                exit('WTD');
            else
                exit('ALL TIME');
        end;
    end;
}