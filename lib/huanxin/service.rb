require 'rest-client'
require 'logging'
require 'json'
module Huanxin
  class Service
    def initialize
      $logger = Logging.logger['huanxin']
      $logger.level = Huanxin.config.log_level
      $logger.add_appenders Logging.appenders.stdout, Logging.appenders.file(Huanxin.config.log_file)

      @org = Huanxin.config.org
      @app = Huanxin.config.app
      @client_id = Huanxin.config.client_id
      @client_secret = Huanxin.config.client_secret
      @host =   Huanxin.config.host
    end

    # 获取token
    def get_token
      url = "#{@host}/#{@org}/#{@app}/token"
      header = {'Content-Type': 'application/json'}
      params =  {'grant_type': 'client_credentials', 'client_id': @client_id, 'client_secret': @client_secret}
      begin
        ret = RestClient.post url, params.to_json, header
        return json(ret)
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 注册im用户(单个用户)
    def register(username, password, token = '')
      url = "#{@host}/#{@org}/#{@app}/users"
      if token.empty?
        header = {'Content-Type': 'application/json'}
      else
        header = {'Content-Type': 'application/json', 'Authorization': "Bearer #{token}"}
      end
      params = {'username': "#{username}", "password": "#{password}"}
      begin
        ret = RestClient.post url, params.to_json, header
        return json(ret)
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 注册用户(批量)
    # 批量注册的用户数量不要过多, 建议在20-60之间
    def register_s(users = {}, token)

    end

    # # 批量注册用户
    # def register(user = [], token = '')
    #   url = "#{@host}/#{@org}/#{@app}/users"
    #   if token.blank?
    #     header = {'Content-Type': 'application/json'}
    #   else
    #     header = {'Content-Type': 'application/json', 'Authorization': "Bearer $#{token}"}
    #   end
    # end


    private

    def json(ret)
      res = JSON.parse ret
      res['code'] = ret.code
      return res
    end



  end
end