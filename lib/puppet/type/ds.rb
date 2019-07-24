Puppet::Type.newtype(:ds) do
  @doc = 'This type provides Puppet with the capabilities to manage directory service in Puppet Enterprise'

  ensurable

  newparam(:display_name, namevar: true) do
    desc 'The name of the directory service'
  end

  newproperty(:help_link) do
    desc 'This link is displayed to users when they have trouble logging in to Puppet Enterprise. Example: http://intranet/helpdesk.'
    defaultto ''
  end

  newproperty(:hostname) do
    desc 'Fully qualified domain name (FQDN) of the directory server.'
  end

  newproperty(:port) do
    desc 'Directory server port.'
    validate do |value|
      unless value.is_a? Integer
        raise ArgumentError, "%s should be an integer" % value
      end
    end
  end

  newproperty(:login) do
    desc 'Distinguished name of the user to perform directory lookups. Example: cn=admin,ou=users,dc=rgbank,dc=com'
    defaultto ''
  end

  newproperty(:password) do
    desc 'Password of the user to perform directory lookups.'
    defaultto ''
  end

  newproperty(:connect_timeout) do
    desc 'Puppet Enterprise attempts to connect to the directory server for the duration specified here.'
    defaultto 10
    validate do |value|
      unless value.is_a? Integer
        raise ArgumentError, "%s should be an integer" % value
      end
    end
  end

  newproperty(:ssl) do
    desc 'Whether to select SSL as the security protocol to use for communications between PE and your directory server.'
    newvalue(:true)
    newvalue(:false)
    defaultto :false
  end

  newproperty(:start_tls) do
    desc 'Whether to select TLS as the security protocol to use for communications between PE and your directory server.'
    newvalue(:true)
    newvalue(:false)
    defaultto :false
  end

  newproperty(:ssl_hostname_validation) do
    desc 'Verify that the Directory Services hostname used to connect to the LDAP server matches the hostname on the SSL certificate.'
    newvalue(:true)
    newvalue(:false)
    defaultto :false
  end

  newproperty(:ssl_wildcard_validation) do
    desc 'Allow connection to hosts with SSL certificates that use a wildcard specification.'
    newvalue(:true)
    newvalue(:false)
    defaultto :false
  end

  newproperty(:base_dn) do
    desc 'Where in the LDAP tree we can find users and groups.'
  end

  newproperty(:user_lookup_attr) do
    desc 'Users will log in with this value.'
  end

  newproperty(:user_email_attr) do
    desc 'Example: mail. Example query result: ries@rg-bank.com'
  end

  newproperty(:user_display_name_attr) do
    desc 'Example: displayName. Example query result: Ries Volkerink.'
  end

  newproperty(:user_rdn) do
    desc 'The base distinguished name for querying users. Example: cn=Users'
    defaultto ''
  end

  newproperty(:group_object_class) do
    desc 'The kind of object that represents groups. Example: group.'
  end

  newproperty(:group_member_attr) do
    desc 'The way to fetch group membership information. Example: member.'
  end

  newproperty(:group_name_attr) do
    desc 'The display name for a group. Example: name. Example query result: Domain admins.'
  end

  newproperty(:group_lookup_attr) do
    desc 'Example: cn. Example query result: cn=Domain admins,ou=Groups,dc=rgbank,dc=com.'
  end

  newproperty(:group_rdn) do
    desc 'The base distinguished name for querying groups. Example: cn=Groups.'
    defaultto ''
  end

  newproperty(:disable_ldap_matching_rule_in_chain) do
    desc 'Turn off the LDAP matching rule that looks up the chain of ancestry for an object until it finds a match.'
    newvalue(:true)
    newvalue(:false)
    defaultto :false
  end

  newproperty(:search_nested_groups) do
    desc 'Search for groups that are members of an external directory group.'
    newvalue(:true)
    newvalue(:false)
    defaultto :false
  end

end
