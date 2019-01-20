codeunit 14135109 "lvngAPEventsSubscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeVendorLedgerEntryInsert(var Rec: Record "Vendor Ledger Entry")
    begin
        if not Rec.IsTemporary() then
            Rec.lvngEntryDate := Today();
    end;
}