module PuppetX
  module Common
    def self.ds_url
      "https://#{Puppet.settings[:certname]}:4433/rbac-api/v1/ds"
    end

    def self.get(options = {})
      request(:get, **options)
    end

    def self.post(options = {})
      request(:post, **options)
    end

    def self.put(options = {})
      request(:put, **options)
    end

    def self.delete(options = {})
      request(:delete, **options)
    end

    def self.request(type, data: nil)
      uri = URI(ds_url)
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

      Puppet.debug("Sending #{type.upcase} request to #{ds_url}")

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
