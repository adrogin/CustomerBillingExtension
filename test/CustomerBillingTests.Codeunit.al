codeunit 69151 "Customer Billing Tests"
{
    Description = 'Test coverage for the billing extension demo functionality';
    Subtype = Test;

    [Test]
    procedure ValidateEmptyBillingGroupCodeParametersReset()
    var
        Customer: Record Customer;
        EmptyDateFormula: DateFormula;
        WrongBillingParamsErr: Label 'Customer billing parameters must be reset';
    begin
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate(Priority, LibraryRandom.RandInt(10));
        Evaluate(Customer."TD Billing Period Date Calc.", StrSubstNo(PeriodFormulaTxt, LibraryRandom.RandInt(10)));
        Customer.Modify(true);

        Customer.Validate("TD Billing Group Code", '');

        Assert.AreEqual(0, Customer.Priority, WrongBillingParamsErr);

        Evaluate(EmptyDateFormula, '');
        Assert.AreEqual(EmptyDateFormula, Customer."TD Billing Period Date Calc.", WrongBillingParamsErr);
    end;

    [Test]
    procedure ValidateBillingGroupCodeParametersInheritedFromGroup()
    var
        Customer: Record Customer;
        CustomerBillingGroup: Record "TD Customer Billing Group";
        WrongBillingParamsErr: Label 'Customer billing parameters must be inherited from the billing group';
    begin
        LibrarySales.CreateCustomer(Customer);
        CreateCustomerBillingGroup(CustomerBillingGroup);

        Customer.Validate("TD Billing Group Code", CustomerBillingGroup.Code);

        Assert.AreEqual(CustomerBillingGroup.Priority, Customer.Priority, WrongBillingParamsErr);
        Assert.AreEqual(CustomerBillingGroup."Billing Period", Customer."TD Billing Period Date Calc.", WrongBillingParamsErr);
    end;

    local procedure CreateCustomerBillingGroup(var CustomerBillingGroup: Record "TD Customer Billing Group")
    begin
        CustomerBillingGroup.Validate(Code, LibraryUtility.GenerateGUID());
        CustomerBillingGroup.Validate(Priority, LibraryRandom.RandInt(10));
        Evaluate(CustomerBillingGroup."Billing Period", PeriodFormulaTxt);
        CustomerBillingGroup.Insert(true);
    end;

    var
        LibrarySales: Codeunit "Library - Sales";
        LibraryRandom: Codeunit "Library - Random";
        LibraryUtility: Codeunit "Library - Utility";
        Assert: Codeunit Assert;
        PeriodFormulaTxt: Label '<%1D>', Comment = '%1: number of days', Locked = true;
}