require 'deface'
require 'default_hostgroup_managed_host_patch'

module ForemanDefaultHostgroup
  #Inherit from the Rails module of the parent app (Foreman), not the plugin.
  #Thus, inherits from ::Rails::Engine and not from Rails::Engine
  class Engine < ::Rails::Engine

    # Load this before the Foreman config initizializers, so that the Setting.descendants
    # list includes the plugin STI setting class
    initializer 'foreman_discovery.load_default_settings', :before => :load_config_initializers do |app|
      require_dependency File.expand_path("../../../app/models/setting/default_hostgroup.rb", __FILE__) if (Setting.table_exists? rescue(false))
    end

    config.to_prepare do
      ::Host::Managed.send :include, DefaultHostgroupManagedHostPatch
    end

  end
end
