module PuppetX
  module Common
    def self.ds_url
      Puppet.initialize_settings
      "https://#{Puppet.settings[:certname]}:4433/rbac-api/v1/ds"
    end

    def self.get(ds_url, options = {})
      request(url, :get, **options)
    end

    def self.post(ds_url, options = {})
      request(url, :post, **options)
    end

    def self.put(ds_url, options = {})
      request(url, :put, **options)
    end

    def self.delete(ds_url, options = {})
      request(url, :delete, **options)
    end

    def self.request(url, type, data: nil)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.cert = OpenSSL::X509::Certificate.new(File.read(Puppet.settings[:hostcert]))
      http.key = OpenSSL::PKey::RSA.new(File.read(Puppet.settings[:hostprivkey]))
      http.ca_file = Puppet.settings[:localcacert]
      http.verify_mode = OpenSSL::SSL::VERIFY_CLIENT_ONCE

      request = case type
                when :post
                  Net::HTTP::Post.new(uri.request_uri)
                when :put
                  Net::HTTP::Put.new(uri.request_uri)
                when :delete
                  Net::HTTP::Delete.new(uri.request_uri)
                else
                  Net::HTTP::Get.new(uri.request_uri)
                end

      Puppet.debug("Sending #{type.upcase} request to #{url}")

      request.set_form_data(data) unless data.nil?

      response = http.request(request)

      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        JSON.load response.body
      else
        raise Puppet::Error, "A Puppet API error occured: HTTP #{response.code}, #{response.body}"
      end
    end
  end
end
