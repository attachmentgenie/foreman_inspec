require 'deface'

module ForemanInspec
  class Engine < ::Rails::Engine
    engine_name 'foreman_inspec'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_inspec.load_app_instance_data' do |app|
      ForemanInspec::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_inspec.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_inspec do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_inspec do
          permission :view_foreman_inspec, :'foreman_inspec/hosts' => [:new_action]
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role 'ForemanInspec', [:view_foreman_inspec]

        # add menu entry
        menu :top_menu, :template,
             url_hash: { controller: :'foreman_inspec/hosts', action: :new_action },
             caption: 'ForemanInspec',
             parent: :hosts_menu,
             after: :hosts

        # add dashboard widget
        widget 'foreman_inspec_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_inspec.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_inspec.configure_assets', group: :assets do
      SETTINGS[:foreman_inspec] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanInspec::HostExtensions)
        HostsHelper.send(:include, ForemanInspec::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ForemanInspec: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanInspec::Engine.load_seed
      end
    end

    initializer 'foreman_inspec.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_inspec'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
