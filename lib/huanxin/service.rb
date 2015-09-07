require 'rest-client'
require 'logging'
require 'json'
require 'uri'
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
      header = { 'Content-Type': 'application/json' }
      params =  { 'grant_type': 'client_credentials', 'client_id': @client_id, 'client_secret': @client_secret }
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
    def register(username, password, token = nil)
      url = "#{@host}/#{@org}/#{@app}/users"
      if token == nil or token == ''
        header = { 'Content-Type': 'application/json' }
      else
        header = { 'Content-Type': 'application/json', 'Authorization': "Bearer #{token}" }
      end
      params = { 'username': "#{username}", "password": "#{password}" }
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
    # users = [{ username: , password: }] or users = { username:, password: }
    def register_s(users = {}, token = nil)
      url = "#{@host}/#{@org}/#{@app}/users"
      if token == nil or token == ''
        header = { 'Content-Type': 'application/json' }
      else
        header = { 'Content-Type': 'application/json', 'Authorization': "Bearer #{token}" }
      end
      rg_users = users
      begin
        ret = RestClient.post url, rg_users.to_json, header
        return json(ret)
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 获取单个用户
    def get_user(username, token)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}"
      header = { 'Authorization': "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.get url, header
        return json(ret)
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 批量获取用户
    def get_users(token, limit = 10, cursor = nil)
      url = "#{@host}/#{@org}/#{@app}/users"
      if cursor == nil or cursor == nil
        params = {params: {limit: limit}, Authorization: "Bearer #{token}", accept: :json}
      else
        params = {params: {limit: limit, cursor: cursor}, Authorization: "Bearer #{token}", accept: :json}
      end
      begin
        ret = RestClient.get(url, params)
        return json(ret)
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 删除单个用户
    def delete_user(username, token)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}"
      header = { 'Authorization': "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.delete url, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 批量删除用户
    # 删除哪些用户是不是道的，要出response,坑爹的环信
    # 默认删除2个用户
    def delete_users(token, limit = 2)
      url = "#{@host}/#{@org}/#{@app}/users"
      header = {params: {limit: limit}, Authorization: "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.delete url, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 重置IM用户密码
    def reset_password(token, username, password)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/password"
      header = { Authorization: "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.put url, {newpassword: password}.to_json, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 修改用户昵称
    def set_nickname(token, username, nickname)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}"
      header = { Authorization: "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.put url, {nickname: nickname}.to_json, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 给IM用户添加朋友
    # owner_username=>自己; friend_username=>朋友
    def add_friend(token, owner_username, friend_username)
      url = "#{@host}/#{@org}/#{@app}/users/#{owner_username}/contacts/users/#{friend_username}"
      header = { Authorization: "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.post url, {}.to_json, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 从IM用户的好友列表中移除一个用户
    def remove_friend(token, owner_username, friend_username )
      url = "#{@host}/#{@org}/#{@app}/users/#{owner_username}/contacts/users/#{friend_username}"
      header = { Authorization: "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.delete url, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 查看某个IM用户的好友信息
    def get_friends(token, username)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/contacts/users"
      header = { Authorization: "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.get url, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 往一个IM用户的黑名单中加人(可以多个)
    # users可以为一个也可以多个
    def block_add_users(token, username, users)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/blocks/users"
      header = { Authorization: "Bearer #{token}", accept: :json }
      params = {usernames: users}
      begin
        ret = RestClient.post url, params.to_json, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    private

    def json(ret)
      res = JSON.parse ret
      res['code'] = ret.code
      return res
    end

    def url_encode(str)
      return str.gsub!(/[^\w$&\-+.,\/:;=?@]/) { |x| x = format("%%%x", x[0]) }
    end
  end
end