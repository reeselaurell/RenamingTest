codeunit 14135109 "lvnAPEventsSubscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeVendorLedgerEntryInsert(var Rec: Record "Vendor Ledger Entry")
    begin
        if not Rec.IsTemporary() then
            Rec.lvnEntryDate := Today();
    end;
}