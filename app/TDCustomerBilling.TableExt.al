tableextension 69100 "TD Customer Billing" extends Customer
{
    fields
    {
        field(50000; "TD Billing Period Date Calc."; DateFormula)
        {
            Caption = 'Billing Period Date Calc.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Format(Rec."TD Billing Period Date Calc.") = '' then
                    Rec.Validate("TD Automatic Invoicing", false);
            end;
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
        field(50002; "TD Automatic Invoicing"; Boolean)
        {
            Caption = 'Automatic invoicing';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateAutomaticInvoicing();
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
        CustomerBillingGroup.Get(BillingGroupCode);
        Rec.Validate(Priority, CustomerBillingGroup.Priority);
        Rec.Validate("TD Billing Period Date Calc.", CustomerBillingGroup."Billing Period");
    end;

    local procedure ValidateAutomaticInvoicing()
    begin
        if not Rec."TD Automatic Invoicing" then
            exit;

        if Format(Rec."TD Billing Period Date Calc.") = '' then
            Error(FieldMustNotBeEmptyErr, Rec.FieldCaption("TD Billing Period Date Calc."));
    end;

    var
        FieldMustNotBeEmptyErr: Label 'The value of %1 must not be blank.', Comment = '%1: Field caption';
}