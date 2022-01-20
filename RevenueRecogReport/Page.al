pageextension 50100 "SalesOrder" extends "Sales Order"
{
    actions
    {
        addafter(History)
        {
            action("Download Report")
            {
                ApplicationArea = All;
                Image = ExportFile;
                trigger OnAction()
                var
                    TempBlob_lRec: Codeunit "Temp Blob";
                    Out: OutStream;
                    Instr: InStream;
                    RecRef: RecordRef;
                    FileManagement_lCdu: Codeunit "File Management";
                    SalesHeader_lRec: Record "Sales Header";
                    Table: Record "Table Storage";
                begin
                    TempBlob_lRec.CreateOutStream(Out, TEXTENCODING::UTF8);
                    SalesHeader_lRec.Reset;
                    SalesHeader_lRec.SetRange("Document Type", Rec."Document Type");
                    SalesHeader_lRec.SetRange("No.", Rec."No.");
                    SalesHeader_lRec.FindFirst();
                    RecRef.GetTable(SalesHeader_lRec);
                    REPORT.SAVEAS(752, '', REPORTFORMAT::Pdf, Out, RecRef);
                    TempBlob_lRec.CreateInStream(Instr);
                    Table.Init();
                    Table.Content.CreateOutStream(Out, TEXTENCODING::UTF8);
                    CopyStream(Out, Instr);
                    Table.Insert(true);
                    //FileManagement_lCdu.BLOBExport(TempBlob_lRec, STRSUBSTNO('SalesOrder_%1.Pdf', Rec."No."), TRUE);
                end;
            }
        }
    }

    var
        myInt: Integer;
}