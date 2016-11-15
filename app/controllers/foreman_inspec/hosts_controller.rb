module ForemanInspec
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::HostsController
    # change layout if needed
    # layout 'foreman_inspec/layouts/new_layout'

    def new_action
      # automatically renders view/foreman_inspec/hosts/new_action
    end
  end
end
