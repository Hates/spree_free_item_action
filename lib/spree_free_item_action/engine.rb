module SpreeFreeItemAction
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_free_item_action'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'spree.promo.register.promotions.actions.free_item', after: 'spree.promo.register.promotions.actions' do |app|
      app.config.spree.promotions.actions += [Spree::Promotion::Actions::CreateFreeLineItems]
    end

    config.to_prepare &method(:activate).to_proc
  end
end
