table 50150 "Stock Adjustment"
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
        field(6; "Load Transfer Order Date"; Date)
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
        field(19; Indentation; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Transfer Header Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "LQ < AS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "High Demand"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(PK2; "Item Code", Indentation, "Transfer to Code")
        {

        }
    }



    trigger OnInsert()
    var
        RecSITAllocation: Record "Stock Adjustment";
    begin
        Clear(RecSITAllocation);
        RecSITAllocation.SetRange("Item Code", Rec."Item Code");
        if RecSITAllocation.FindFirst() then
            Rec.Indentation := 1
        else
            Rec.Indentation := 0;
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure GetStyleText(): Text
    begin
        if Indentation = 0 then
            exit('Strong')
        else
            exit('');
    end;

    procedure GetStyleTextForSales(): Text
    begin
        if "Avrg Sales" > "Loading Quantity" then
            exit('Unfavorable')
        else
            exit('');

    end;

}