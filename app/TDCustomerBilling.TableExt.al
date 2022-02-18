tableextension 69100 "TD Customer Billing" extends Customer
{
    fields
    {
        field(50000; "TD Billing Period Date Calc."; DateFormula)
        {
            Caption = 'Billing Period Date Calc.';
            DataClassification = CustomerContent;
        }

        field(50001; "TD Billing Group Code"; Code[20])
        {
            Caption = 'Customer Billing Group';
            DataClassification = CustomerContent;
            TableRelation = "TD Customer Billing Group";

            trigger OnValidate()
            begin
                if Rec."TD Billing Group Code" = '' then
                    ResetBillingParams()
                else
                    AssignBillingParams("TD Billing Group Code");
            end;
        }
    }

    local procedure ResetBillingParams()
    var
        EmptyDateFormula: DateFormula;
    begin
        Evaluate(EmptyDateFormula, '');
        Rec.Validate(Priority, 0);
        Rec.Validate("TD Billing Period Date Calc.", EmptyDateFormula);
    end;

    local procedure AssignBillingParams(BillingGroupCode: Code[20])
    var
        CustomerBillingGroup: Record "TD Customer Billing Group";
    begin
        if not CustomerBillingGroup.Get(BillingGroupCode) then
            exit;

        Rec.Validate(Priority, CustomerBillingGroup.Piority);
        Rec.Validate("TD Billing Period Date Calc.", CustomerBillingGroup."Billing Period");
    end;
}