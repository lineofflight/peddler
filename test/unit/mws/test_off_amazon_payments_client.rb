require 'helper'
require 'mws/off_amazon_payments/client'

class TestMWSOffAmazonPaymentsClient < MiniTest::Test
  def setup
    @client = MWS::OffAmazonPayments::Client.new
  end

  def test_sandboxes
    @client.primary_marketplace_id = 'A1F83G8C2ARO7P'
    refute_includes @client.aws_endpoint, 'Sandbox'
    assert_includes @client.sandbox.aws_endpoint, 'Sandbox'
  end

  def test_creates_order_reference_for_id
    operation = {
      'Action' => 'CreateOrderReferenceForId',
      'Id' => '1',
      'IdType' => '2'
    }

    @client.stub(:run, nil) do
      @client.create_order_reference_for_id('1', '2')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_billing_agreement_details
    operation = {
      'Action' => 'GetBillingAgreementDetails',
      'AmazonBillingAgreementId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_billing_agreement_details('1')
    end

    assert_equal operation, @client.operation
  end

  def test_sets_billing_agreement_details
    operation = {
      'Action' => 'SetBillingAgreementDetails',
      'AmazonBillingAgreementId' => '1',
      'BillingAgreementAttributes.Foo' => '1'
    }

    @client.stub(:run, nil) do
      @client.set_billing_agreement_details('1', 'Foo' => '1')
    end

    assert_equal operation, @client.operation
  end

  def test_confirms_billing_agreement
    operation = {
      'Action' => 'ConfirmBillingAgreement',
      'AmazonBillingAgreementId' => '1'
    }

    @client.stub(:run, nil) do
      @client.confirm_billing_agreement('1')
    end

    assert_equal operation, @client.operation
  end

  def test_validates_billing_agreement
    operation = {
      'Action' => 'ValidateBillingAgreement',
      'AmazonBillingAgreementId' => '1'
    }

    @client.stub(:run, nil) do
      @client.validate_billing_agreement('1')
    end

    assert_equal operation, @client.operation
  end

  def test_authorizes_on_billing_agreement
    operation = {
      'Action' => 'AuthorizeOnBillingAgreement',
      'AmazonBillingAgreementId' => '1',
      'AuthorizationReferenceId' => '2',
      'AuthorizationAmount.Foo' => '1'
    }

    @client.stub(:run, nil) do
      @client.authorize_on_billing_agreement('1', '2', 'Foo' => '1')
    end

    assert_equal operation, @client.operation
  end

  def test_closes_billing_agreement
    operation = {
      'Action' => 'CloseBillingAgreement',
      'AmazonBillingAgreementId' => '1'
    }

    @client.stub(:run, nil) do
      @client.close_billing_agreement('1')
    end

    assert_equal operation, @client.operation
  end

  def test_sets_order_reference_details
    operation = {
      'Action' => 'SetOrderReferenceDetails',
      'AmazonOrderReferenceId' => '1',
      'OrderReferenceAttributes.OrderTotal' => '2'
    }

    @client.stub(:run, nil) do
      @client.set_order_reference_details('1', '2')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_order_reference_details
    operation = {
      'Action' => 'GetOrderReferenceDetails',
      'AmazonOrderReferenceId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_order_reference_details('1')
    end

    assert_equal operation, @client.operation
  end

  def test_confirms_order_reference
    operation = {
      'Action' => 'ConfirmOrderReference',
      'AmazonOrderReferenceId' => '1'
    }

    @client.stub(:run, nil) do
      @client.confirm_order_reference('1')
    end

    assert_equal operation, @client.operation
  end

  def test_cancels_order_reference
    operation = {
      'Action' => 'CancelOrderReference',
      'AmazonOrderReferenceId' => '1'
    }

    @client.stub(:run, nil) do
      @client.cancel_order_reference('1')
    end

    assert_equal operation, @client.operation
  end

  def test_closes_order_reference
    operation = {
      'Action' => 'CloseOrderReference',
      'AmazonOrderReferenceId' => '1'
    }

    @client.stub(:run, nil) do
      @client.close_order_reference('1')
    end

    assert_equal operation, @client.operation
  end

  def test_authorizes
    operation = {
      'Action' => 'Authorize',
      'AmazonOrderReferenceId' => '1',
      'AuthorizationReferenceId' => '2',
      'AuthorizationAmount' => '3'
    }

    @client.stub(:run, nil) do
      @client.authorize('1', '2', '3')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_authorization_details
    operation = {
      'Action' => 'GetAuthorizationDetails',
      'AmazonAuthorizationId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_authorization_details('1')
    end

    assert_equal operation, @client.operation
  end

  def test_captures
    operation = {
      'Action' => 'Capture',
      'AmazonAuthorizationId' => '1',
      'CaptureReferenceId' => '2',
      'CaptureAmount' => '3'
    }

    @client.stub(:run, nil) do
      @client.capture('1', '2', '3')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_capture_details
    operation = {
      'Action' => 'GetCaptureDetails',
      'AmazonCaptureId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_capture_details('1')
    end

    assert_equal operation, @client.operation
  end

  def test_closes_authorization
    operation = {
      'Action' => 'CloseAuthorization',
      'AmazonAuthorizationId' => '1'
    }

    @client.stub(:run, nil) do
      @client.close_authorization('1')
    end

    assert_equal operation, @client.operation
  end

  def test_refunds
    operation = {
      'Action' => 'Refund',
      'AmazonCaptureId' => '1',
      'RefundReferenceId' => '2',
      'RefundAmount' => '3'
    }

    @client.stub(:run, nil) do
      @client.refund('1', '2', '3')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_refund_details
    operation = {
      'Action' => 'GetRefundDetails',
      'AmazonRefundId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_refund_details('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_service_status
    operation = {
      'Action' => 'GetServiceStatus'
    }

    @client.stub(:run, nil) do
      @client.get_service_status
    end

    assert_equal operation, @client.operation
  end
end
