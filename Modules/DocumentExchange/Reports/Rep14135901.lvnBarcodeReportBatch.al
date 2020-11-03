report 14135901 "lvnBarcodeReportBatch"
{
    Caption = 'Barcode Report Batch';
    UsageCategory = Administration;
    RDLCLayout = 'Modules\DocumentExchange\Reports\Layouts\BarcodeReportBatch.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.";

            column(BarcodeValue; "Purchase Header"."No.") { }
        }
    }
}