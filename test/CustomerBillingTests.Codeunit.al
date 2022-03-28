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
        // [SCENARIO] Billing parameters on the customer card are reset to defaults after assigning a blank group code

        // [GIVEN] Set Priority = 1, "Billing Period Date Calc." = 5D on a customer card
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate(Priority, LibraryRandom.RandInt(10));
        Evaluate(Customer."TD Billing Period Date Calc.", StrSubstNo(PeriodFormulaTxt, LibraryRandom.RandInt(10)));
        Customer.Modify(true);

        // [WHEN] Set a blank billing group code on the customer card
        Customer.Validate("TD Billing Group Code", '');

        // [THEN] Priority is reset to 0
        Assert.AreEqual(0, Customer.Priority, WrongBillingParamsErr);

        // [THEN] Date formula is reset to empty value
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
        // [SCENARIO] When a billing group is updated on a customer card, billing parameters are copied from the group to the customer

        // [GIVEN] Customer "C" with no billing group, Priority = 0, "Billing Period Date Calc." is blank
        LibrarySales.CreateCustomer(Customer);

        // [GIVEN] Create customer billing group "G" with Priority = 2 and billing period formula "5D"
        CreateCustomerBillingGroup(CustomerBillingGroup);

        // [WHEN] Set the billing group code "G" on the customer card "C"
        Customer.Validate("TD Billing Group Code", CustomerBillingGroup.Code);

        // [THEN] Billing fields are updated on the customer "C": Priority = 2, "Billing Period Date Calc." = "5D"
        Assert.AreEqual(CustomerBillingGroup.Priority, Customer.Priority, WrongBillingParamsErr);
        Assert.AreEqual(CustomerBillingGroup."Billing Period", Customer."TD Billing Period Date Calc.", WrongBillingParamsErr);
    end;

    [Test]
    procedure SetAutomaticInvoicingBillingPeriodDefined()
    var
        Customer: Record Customer;
    begin
        LibrarySales.CreateCustomer(Customer);
        ValidateCustomerBillingPeriodFormula(Customer, StrSubstNo(PeriodFormulaTxt, LibraryRandom.RandInt(10)));
        Customer.Modify(true);

        Customer.Validate("TD Automatic Invoicing", true);
    end;

    [Test]
    procedure SetAutomaticInvoicingBillingPeriodUndefinedError()
    var
        Customer: Record Customer;
        FieldMustNotBeEmptyErr: Label 'The value of %1 must not be blank.', Comment = '%1: Field caption';
    begin
        LibrarySales.CreateCustomer(Customer);
        asserterror Customer.Validate("TD Automatic Invoicing", true);
        Assert.ExpectedError(StrSubstNo(FieldMustNotBeEmptyErr, Customer.FieldCaption("TD Billing Period Date Calc.")));
    end;

    [Test]
    procedure ClearBillingPeriodAutoInvoicingReset()
    var
        Customer: Record Customer;
        AutoInvoicingMustBeOffErr: Label 'Automatic invoicing must be disabled';
    begin
        CreateCustomerWithBillingGroup(Customer);
        Customer.Validate("TD Automatic Invoicing", true);

        // [WHEN]
        ValidateCustomerBillingPeriodFormula(Customer, '');

        // [THEN]
        Assert.IsFalse(Customer."TD Automatic Invoicing", AutoInvoicingMustBeOffErr);
    end;

    local procedure CreateCustomerBillingGroup(var CustomerBillingGroup: Record "TD Customer Billing Group")
    begin
        CustomerBillingGroup.Validate(Code, LibraryUtility.GenerateGUID());
        CustomerBillingGroup.Validate(Priority, LibraryRandom.RandInt(10));
        Evaluate(CustomerBillingGroup."Billing Period", StrSubstNo(PeriodFormulaTxt, LibraryRandom.RandInt(10)));
        CustomerBillingGroup.Insert(true);
    end;

    local procedure CreateCustomerWithBillingGroup(var Customer: Record Customer)
    var
        CustomerBillingGroup: Record "TD Customer Billing Group";
    begin
        LibrarySales.CreateCustomer(Customer);
        CreateCustomerBillingGroup(CustomerBillingGroup);
        Customer.Validate("TD Billing Group Code", CustomerBillingGroup.Code);
        Customer.Modify(true);
    end;

    local procedure ValidateCustomerBillingPeriodFormula(var Customer: Record Customer; BillingDateCalc: Text)
    begin
        Evaluate(Customer."TD Billing Period Date Calc.", BillingDateCalc);
        Customer.Validate("TD Billing Period Date Calc.");
    end;

    var
        LibrarySales: Codeunit "Library - Sales";
        LibraryRandom: Codeunit "Library - Random";
        LibraryUtility: Codeunit "Library - Utility";
        Assert: Codeunit Assert;
        PeriodFormulaTxt: Label '<%1D>', Comment = '%1: number of days', Locked = true;
}