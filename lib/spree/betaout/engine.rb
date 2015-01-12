module Spree
  module Betaout
    class Engine < Rails::Engine
      require 'spree/core'
      isolate_namespace Spree
      engine_name 'spree_betaout'
      config.autoload_paths += %W(#{config.root}/lib)

      #def self.root
        #@root ||= Pathname.new(File.expand_path('../../../../', __FILE__))
        #puts "root: #{@root}"
        #@root
      #end

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      initializer "spree_betaout.environment", :before => :load_config_initializers do |app|
        puts "in spree::betaout intializer"
        Betaout::Config = Spree::Betaout::Configuration.new
      end

      def self.activate
        puts "gonna glob: #{File.join(File.dirname(__FILE__), '../../../app/**/*_decorator*.rb')}"
        Dir.glob(File.join(File.dirname(__FILE__), '../../../app/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end
