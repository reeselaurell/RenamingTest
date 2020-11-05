table 14135138 "lvnQuickPayFilterPreset"
{
    Caption = 'Quick Pay Filter Preset';
    LookupPageId = lvnQuickPayPresets;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; View; Blob)
        {
            Caption = 'View';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    var
        LedgerEntriesLbl: Label 'Ledger Entries';

    procedure MakeFilter()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        FPBuilder: FilterPageBuilder;
        IStream: InStream;
        OStream: OutStream;
        ViewText: Text;
    begin
        CalcFields(View);
        FPBuilder.AddRecord(LedgerEntriesLbl, VendorLedgerEntry);
        FPBuilder.AddFieldNo(LedgerEntriesLbl, 172);
        FPBuilder.AddFieldNo(LedgerEntriesLbl, 22);
        FPBuilder.AddFieldNo(LedgerEntriesLbl, 23);
        FPBuilder.AddFieldNo(LedgerEntriesLbl, 24);
        FPBuilder.AddFieldNo(LedgerEntriesLbl, 27);
        FPBuilder.AddFieldNo(LedgerEntriesLbl, 50);
        FPBuilder.AddFieldNo(LedgerEntriesLbl, 14135101);
        if View.HasValue() then begin
            View.CreateInStream(IStream);
            IStream.ReadText(ViewText);
            FPBuilder.SetView(LedgerEntriesLbl, ViewText);
        end;
        if FPBuilder.RunModal() then begin
            Clear(View);
            View.CreateOutStream(OStream);
            OStream.WriteText(FPBuilder.GetView(LedgerEntriesLbl, false));
            Modify();
        end;
    end;

    procedure ApplyVendorLedgerEntries(var VendorLedgerEntry: Record "Vendor Ledger Entry"): Boolean
    var
        IStream: InStream;
        ViewText: Text;
    begin
        CalcFields(View);
        if View.HasValue() then begin
            View.CreateInStream(IStream);
            IStream.ReadText(ViewText);
            VendorLedgerEntry.SetView(ViewText);
            exit(true);
        end else
            exit(false);
    end;
}