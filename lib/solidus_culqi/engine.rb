# frozen_string_literal: true

module SolidusCulqi
  class Engine < Rails::Engine
    engine_name 'solidus_culqi'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree.gateway.payment_methods', after: 'spree.register.payment_methods' do |app|
      app.config.spree.payment_methods << Solidus::Gateway::CulqiGateway
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
