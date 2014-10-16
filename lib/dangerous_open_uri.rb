require "dangerous_open_uri/version"
require 'open-uri'

OpenURI.module_eval do
  instance_eval { alias :original_open_http :open_http }

  def self.open_http(buf, target, proxy, options)
    if target.userinfo
      userinfo = target.userinfo
      user, pass = userinfo.to_s.split(':', -1)
      options[:http_basic_authentication] = [user, pass]
      target.userinfo = ""
    end

    original_open_http(buf, target, proxy, options)
  end
end
