codeunit 14135100 "lvngGLEntryEventsSubscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        DimensionManagement: Codeunit DimensionManagement;
        ShortcutDimValues: array[8] of Code[20];
    begin
        if GLEntry.IsTemporary() then
            exit;
        DimensionManagement.GetShortcutDimensions(GLEntry."Dimension Set ID", ShortcutDimValues);
        GLEntry."Shortcut Dimension 3 Code" := ShortcutDimValues[3];
        GLEntry."Shortcut Dimension 4 Code" := ShortcutDimValues[4];
        GLEntry."Shortcut Dimension 5 Code" := ShortcutDimValues[5];
        GLEntry."Shortcut Dimension 6 Code" := ShortcutDimValues[6];
        GLEntry."Shortcut Dimension 7 Code" := ShortcutDimValues[7];
        GLEntry."Shortcut Dimension 8 Code" := ShortcutDimValues[8];
        GLEntry."Loan No." := GenJournalLine."Loan No.";
        GLEntry."Servicing Type" := GenJournalLine."Servicing Type";
        GLEntry."Entry Date" := Today();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure OnAfterPurchasePostBufferPrepate(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    begin
        InvoicePostBuffer."Additional Grouping Identifier" := Format(PurchaseLine."Line No.");
        InvoicePostBuffer."Loan No." := PurchaseLine."Loan No.";
        InvoicePostBuffer.Description := PurchaseLine.Description;
        InvoicePostBuffer."Reason Code" := PurchaseLine."Reason Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', false, false)]
    local procedure OnAfterSalesPostBufferPrepate(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var SalesLine: Record "Sales Line")
    begin
        InvoicePostBuffer."Additional Grouping Identifier" := Format(SalesLine."Line No.");
        InvoicePostBuffer."Loan No." := SalesLine."Loan No.";
        InvoicePostBuffer.Description := SalesLine.Description;
        InvoicePostBuffer."Servicing Type" := SalesLine."Servicing Type";
        InvoicePostBuffer."Reason Code" := SalesLine."Reason Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromInvPostBuffer(var GenJournalLine: Record "Gen. Journal Line"; InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        GenJournalLine."Servicing Type" := InvoicePostBuffer."Servicing Type";
        GenJournalLine."Loan No." := InvoicePostBuffer."Loan No.";
        GenJournalLine.Description := InvoicePostBuffer.Description;
        if InvoicePostBuffer."Reason Code" <> '' then
            GenJournalLine."Reason Code" := InvoicePostBuffer."Reason Code";
    end;
}