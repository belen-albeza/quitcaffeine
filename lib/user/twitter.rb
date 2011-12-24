require 'twitter_oauth'

module Social
  # Twitter OAuth flow inspired on https://github.com/moomerman/sinitter/blob/master/sinitter.rb
  class Twitter
    
    def initialize(config, session)
      @client = TwitterOAuth::Client.new(
        :consumer_secret => config[:secret],
        :consumer_key => config[:key],
        :token  => session[:tw_access_token],
        :secret => session[:tw_secret_token]
      )
      @oauth_callback_url = config[:callback_url]
    end  
        
    def get_auth_url(session)
      request_token = get_request_token()
      session[:tw_request_token] = request_token.token
      session[:tw_request_token_secret]= request_token.secret
      return request_token.authorize_url
    end
    
    def authenticate!(session)
      access_token = get_access_token(session)
      if @client.authorized? and not access_token.nil?
        session[:tw_access_token] = access_token.token
        session[:tw_secret_token] = access_token.secret
        session[:tw_screen_name] = @client.info['screen_name']
      end
      
      return !session[:tw_screen_name].nil?
    end
    
    def tweet!(message)
      @client.update(message)
    end
    
    protected    
    
    def get_access_token(session)
      begin
        @client.authorize(session[:tw_request_token],
                          session[:tw_request_token_secret])
      rescue OAuth::Unauthorized => e
        nil
      end
    end
    
    def get_request_token()      
      begin
        @client.authentication_request_token(:oauth_callback => @oauth_callback_url)
      rescue StandardError => e
        raise TwitterError.new('Error authenticating app. Check app key and secret')
      end
    end
    
  end
  
  # exception classes
  class TwitterError < Exception
  end
end