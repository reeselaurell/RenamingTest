page 14135161 "lvnChooseCompany"
{
    Caption = 'Choose Company';
    PageType = Card;
    SourceTable = Company;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SaveValues = false;
    AutoSplitKey = false;

    layout
    {
        area(Content)
        {
            field(CompanyNameField; CompanyNameVar)
            {
                Caption = 'Copy To Company';
                ApplicationArea = All;
                TableRelation = Company.Name;
                Lookup = true;

                trigger OnValidate()
                begin
                    Rec.SetRange(Name, CompanyNameVar);
                    if Rec.FindFirst() then;
                end;
            }
            field(WarnIfRecordExists; WarnIfRecordExists)
            {
                Caption = 'Warn if record already exists';
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Name, CompanyName);
        if Rec.FindFirst() then;
        WarnIfRecordExists := false;
    end;

    var
        CompanyNameVar: Text[50];
        WarnIfRecordExists: Boolean;

    procedure GetParameters(var pWarnIfRecordExists: Boolean)
    begin
        pWarnIfRecordExists := WarnIfRecordExists;
    end;
}