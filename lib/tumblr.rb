require 'omniauth-oauth'

module OmniAuth
  module Strategies
    class Tumblr < OAuth
      # Give your strategy a name.
      option :name, "tumblr"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "https://www.tumblr.com",
        :version => '1.0a'
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info['name'] }

      info do
        Rails.logger.debug("RawInfo: #{raw_info.inspect.to_s}")
        {
          :uid => raw_info['name'],
          :name => raw_info['name'],
          :following => raw_info['following']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        user_info_url = "http://api.tumblr.com/v2/user/info"
        @raw_info ||= MultiJson.decode(access_token.post(user_info_url).body)['response']['user']
      end
    end
  end
end