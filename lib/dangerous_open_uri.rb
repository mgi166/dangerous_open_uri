require "dangerous_open_uri/version"
require 'open-uri'

module OpenURI
  instance_eval { alias :original_open_http :open_http }

  def self.open_http(buf, target, proxy, options)
    if proxy
      proxy_uri, proxy_user, proxy_pass = proxy

      if proxy_uri.userinfo
        userinfo = proxy_uri.userinfo
        user, pass = userinfo.to_s.split(':', -1)
        proxy_user = user
        proxy_pass = pass
        proxy_uri.userinfo = ""
        proxy = [proxy_uri, proxy_user, proxy_pass]
      end
    end

    if target.userinfo
      userinfo = target.userinfo
      user, pass = userinfo.to_s.split(':', -1)
      options[:http_basic_authentication] = [user, pass]
      target.userinfo = ""
    end

    original_open_http(buf, target, proxy, options)
  end
end
