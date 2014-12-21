require "dangerous_open_uri/version"
require 'open-uri'
require 'uri/ftp'

module OpenURI
  instance_eval { alias :original_open_http :open_http }

  def self.open_http(buf, target, proxy, options)
    if proxy
      proxy_uri, proxy_user, proxy_pass = proxy

      if proxy_uri.userinfo
        proxy_user = proxy_uri.user
        proxy_pass = proxy_uri.password
        proxy_uri.userinfo = ""
        proxy = [proxy_uri, proxy_user, proxy_pass]
      end
    end

    _target = target.dup

    if _target.userinfo
      options[:http_basic_authentication] = [_target.user, _target.password]
      _target.userinfo = ""
    end

    original_open_http(buf, _target, proxy, options)
  end
end

module URI
  class FTP
    alias_method :original_userinfo, :userinfo

    def userinfo
      _userinfo = original_userinfo.dup
      _userinfo.instance_variable_set(:@__user, user)
      _userinfo.instance_variable_set(:@__password, password)
      def _userinfo.split(*args)
        [@__user, @__password]
      end
      _userinfo
    end
  end
end
