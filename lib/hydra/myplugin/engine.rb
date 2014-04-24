module Hydra
  module Myplugin

    def self.table_name_prefix
      'hydra_myplugin_'
    end

    def self.use_relative_model_naming?
      true
    end

    class Engine < ::Rails::Engine
      engine_name 'hydra_myplugin'

      initializer 'hydra-myplugin.initializer' do |app|
        app.config.paths.add 'app/services', eager_load: true
        app.config.autoload_paths += %W(
            #{config.root}/app/services
          )
      end
      
    end
  end
end
