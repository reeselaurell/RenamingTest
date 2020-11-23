page 14135143 "lvnImportBufferErrors"
{
    PageType = ListPart;
    SourceTable = lvnImportBufferError;
    Caption = 'Import Errors';
    Editable = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure SetEntries(var ImportBufferError: Record lvnImportBufferError)
    begin
        ImportBufferError.Reset();
        ImportBufferError.FindSet();
        repeat
            Clear(Rec);
            Rec := ImportBufferError;
            Rec.Insert();
        until ImportBufferError.Next() = 0;
    end;
}