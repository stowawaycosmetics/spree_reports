require 'spree/core'

module SpreeReports
  class Engine < ::Rails::Engine
    isolate_namespace Spree
    engine_name "spree_reports"
    
    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
    
    # apply decorators
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      
      Rails.application.config.assets.precompile += %w( spree_reports/spree_reports.css )
    end

    config.to_prepare &method(:activate).to_proc

  end
end
