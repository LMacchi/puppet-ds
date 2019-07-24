require 'puppet_x/common'

Puppet::Type.type(:ds).provide(:ruby) do
  desc 'Ruby provider to manage directory services in Puppet Enterprise'
  mk_resource_methods
  
  def self.instances
    ds = PuppetX::Common.get()
    if ds
      ds[:ensure] = :present
      new(ds)
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    req_params = [:display_name, :hostname, :port, :login, :password, :base_dn, :user_lookup_attr, :user_email_attr, :user_display_name_attr]
    req_params.concat [:user_rdn, :group_object_class, :group_member_attr, :group_name_attr, :group_lookup_attr, :group_rdn]
    req_params.each do |param|
      raise Puppet::Error, "Parameter #{param} is mandatory" if resource[param].nil?
    end
    
    opt_params = [:help_link, :connect_timeout, :ssl, :start_tls, :ssl_hostname_validation, :ssl_wildcard_validation]
    opt_params.concat [:disable_ldap_matching_rule_in_chain, :search_nested_groups]

    params = req_params.concat(opt_params)

    Puppet.debug "DS: Creating new directory service #{resource[:display_name]}"

    ds = {}
    params.each do |param|
      ds[param] = resource[param]
    end

    PuppetX::Common.post(data: ds)

    @property_hash[:ensure] = :present
  end

  def destroy
    PuppetX::Common.delete()
    @property_hash[:ensure] = :absent
  end

end
