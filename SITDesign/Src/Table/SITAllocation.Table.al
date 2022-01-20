table 50150 "SIT Allocation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(3; "Item Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
            trigger OnValidate();
            var
                ItemL: Record Item;
            begin
                if ItemL.Get(Rec."Item Code") then
                    Rec."Item Description" := ItemL.Description;
            end;
        }
        field(4; "Item Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Report Run Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Loadtransfer Order Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Date';
        }
        field(7; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(8; "Transfer Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Transfer Order Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Demand"; Decimal)
        {
            Caption = 'Demand';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Avrg Sales"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(12; "Proposed Load"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(13; "Loading Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "GrossRequirement"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(15; "ScheduledReceipt"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(16; "PlannedReceipt"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(17; "PlannedRelease"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(18; "Transfer to Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-To Code';
        }
    }

    keys
    {
        key("Entry No."; "Entry No.")
        {
            Clustered = true;
        }
        key("Item Code"; "Item Code")
        {

        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}