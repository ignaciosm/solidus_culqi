module Solidus
  class Gateway::CulqiGateway < SolidusCulqi::Gateway.parent_class
    extend SolidusCulqi::Gateway

    preference :public_key, :string
    preference :secret_key, :string

    partial_method 'culqi'

    def default_currency
      "PEN"
    end

    def provider_class
      self.class
    end

    def authorize(amount, creditcard, gateway_options)
      init_culqi
      commit(amount, creditcard, gateway_options, false)
    end

    def purchase(amount, creditcard, gateway_options)
      init_culqi
      commit(amount, creditcard, gateway_options, true)
    end

    def capture(_amount, response_code, _gateway_options)
      init_culqi
      charge = Culqi::Charge.capture(response_code)
      parse_response(charge)
    end

    def credit(amount, creditcard, _gateway_options)
      init_culqi
      # Culqi only accepts 'duplicado','fraudulento' o 'solicitud_comprador'
      # like reason's value
      refund = Culqi::Refund.create(
        amount: amount,
        charge_id: creditcard,
        reason: "solicitud_comprador"
      )
      parse_response(refund)
    end

    def void(creditcard, gateway_options)
      amount = gateway_options[:subtotal].to_i
      credit(amount, creditcard, gateway_options)
    end

    private

    def init_culqi
      Culqi.public_key = preferred_public_key
      Culqi.secret_key = preferred_secret_key
    end

    def commit(amount, creditcard, gateway_options, capture)
      installments = gateway_options[:installments]
      authorization = creditcard[:gateway_payment_profile_id]
      charge = Culqi::Charge.create(
        amount: amount,
        capture: capture,
        currency_code: default_currency,
        description: gateway_options[:description],
        email: gateway_options[:email],
        installments: installments || 0,
        source_id: authorization
      )
      parse_response(charge)
    end

    def parse_response(response)
      res = JSON.parse(response)
      ActiveMerchant::Billing::Response.new(
        res[:object] != "error",
        res[:merchant_message],
        res,
        authorization: res["id"]
      )
    end
  end
end
