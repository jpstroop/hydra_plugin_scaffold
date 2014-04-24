#How to build an engine - Core practices

[Rails guide](http://guides.rubyonrails.org/engines.html)

Curate and Sufia use mountable engines.
Resque is an explemlar of a mountable engine.

Would like to see Hydra::Engine.new (to handle conventions of Hydra engines)

Jeremy has a hydramaton plugin_generator.rb - good place to extract what we want.

It's a convention for rails plugins to have a namespace, but this behavior isn't available by default:

	Hydra::MyPlugin

More fully functional plugins may be Engines; smaller pieces (such as Works) could be Railties

Plugin demo:

	$ rails plugin -h  ## to get options

There are templates (-m PATH_TO_TEMPLATE)

Skip ActiveRecords (-O)

We'll move the dummy path (Hydra convention)

Namespace isolation will be complicated

	$ rails plugin new hydra_myplugin -T --dummy-path=spec/internal --mountable 
	... output ...

For Hydra, will have to replace MIT license with Apache, replace rdoc with md, add rspec to gemspec:

	s.add_development_dependency "rspec-rails"
	$ git init ##etc... omitting futher notes about git; commit as needed

You should not include the Gemfile.lock in the git repo; make sure it's in the .gitignore

	$ bundle install

Wire up rspec stuff:

	$ rspec --init 

Run rspec to test that it works

	$ rspec

####Time to do some namespace isolation work:

Edit namespaces in gemspec

Need to name hydra_myplugin files:

	$ mv hydra.myplugin.gemspec hydra-myplugin.gemspec

Maniupulate the app/\*/hyrda_myplugin dirs in to app/\*/hydra/myplugin (this is important for the namespacing):

	$ some bash magic, or do it the hard way like a prole

	$ vim app/controllers/hydra/myplugin/application_controller.rb
	s/HydraMyplugin/Hydra::Myplugin/

	$ vim lib/hydra-myplugin.rb
	require"hydra/myplugin/engine"

	module Hydra
		module Myplugin
		end
	end
	
edit to establish an alias for those who aren't paying attention to the code structure:

	$ vim lib/hydra_myplugin.rb

	require hydra_myplugin

engine.rb goes here:

	$ mkdir lib/hydra/myplugin
	$ vim lib/hydra/myplugin/engine.rb

	module Hydra
		Module Myplugin

			def self.table_name_prefix
				'hydra_myplugin_'
			end

			def self.use_relative_model_naming?
				true
			end

			class Engine < ::Rails::Engine
				engine_name 'hydra_myplugin'

				initializer 'hydra-myplugin.initializer' do |app|
					app.config.paths.add 'app/services', eager_load: true  ##these two lines will autofind services
					app.config.autoload_paths += %W(
						#{config.root}/app/services
					)
				end

			end
		end
	end

(The colons in the front above shortcuts to root when looking for the module)

Because we're not using isolate_namespace, we need method declaritions to find necessary routes.

Rails won't autoload second leve dependencies for Engines; so require dependencies within your engine code

Yay we have an engine!

Two types or rake tasks: ones for working on the engine, and some that the parent application can use.

Can also have custom generators; curate has one for creating works

Remove RDoc black from Rakefile

Add to gemspec:

	s.add_development_dependency 'yard'

Add Hydra module to version:

	$ vim lib/hydra/myplugin/version.rb

	module Hydra
		module Myplugin
			VERSION = "0.0.1"
		end
	end

### Next step, make a generator
[example generator](https://github.com/Hydramata/hydramaton/blob/master/lib/generators/hydramata/plugin/plugin_generator.rb)

You need a rails application to test your engine. Engine Cart rebuilds the rails app with the engine for you. [Github](https://github.com/cbeer/engine_cart)
