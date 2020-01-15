report 14135902 lvngBarcodePReportBatch
{
    Caption = 'Barcode Posted Report Batch';
    UsageCategory = Administration;
    RDLCLayout = '_DocumentExchange/Layouts/BarcodePReportBatch.rdl';

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(BarcodeValue; "Purch. Inv. Header"."No.") { }
        }
    }
}