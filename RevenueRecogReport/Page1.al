page 50103 Storage
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Table Storage";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                }

                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                }

                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DownloadFile)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    IStream: InStream;
                    ExportFileName: Text;
                begin
                    ExportFileName := StrSubstNo('%1.pdf', CurrentDateTime);
                    Rec.CalcFields(Content);
                    if not Rec.Content.HasValue then
                        exit;
                    Rec.Content.CreateInStream(IStream);
                    DownloadFromStream(IStream, '', '', '', ExportFileName)
                end;
            }
        }
    }

    var
        myInt: Integer;
}