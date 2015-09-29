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
      if users.is_a? Array
        params = {usernames: users}
      else
        data = []
        data << users
        params = {usernames: data}
      end
      begin
        ret = RestClient.post url, params.to_json, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 黑名单中减人
    def block_remove_users(token, username, blockuser)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/blocks/users/#{blockuser}"
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

    # 查看用户在线状态
    def online_status(token, username)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/status"
      header = { Authorization: "Bearer #{token}", accept: :json, 'Content-Type': 'application/json' }
      begin
        ret = RestClient.get url, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 查看用户的离线消息数
    def get_offline_msg_count(token, username)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/offline_msg_count"
      header = { Authorization: "Bearer #{token}", accept: :json, 'Content-Type': 'application/json' }
      begin
        ret = RestClient.get url, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 查看离线消息的状态
    # 通过离线消息的id查看用户的该条离线消息状态
    def offline_msg_status(token, username, msgid)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/offline_msg_status/#{msgid}"
      header = { Authorization: "Bearer #{token}", accept: :json, 'Content-Type': 'application/json'  }
      begin
        ret = RestClient.get url, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 禁用某个用户账号
    def deactivate_user(token, username)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/deactivate"
      header = { Authorization: "Bearer #{token}", accept: :json, 'Content-Type': 'application/json' }
      begin
        ret = RestClient.post url,{}, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 激活用户账号
    def activate_user(token, username)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/activate"
      header = { Authorization: "Bearer #{token}", accept: :json, 'Content-Type': 'application/json' }
      begin
        ret = RestClient.post url,{}, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 强制用户下线
    def force_offline_user(token, username)
      url = "#{@host}/#{@org}/#{@app}/users/#{username}/disconnect"
      header = { Authorization: "Bearer #{token}", accept: :json, 'Content-Type': 'application/json' }
      begin
        ret = RestClient.get url, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 导出聊天记录
    # 消息的数据结构详情请访问下面的网站
    # http://docs.easemob.com/doku.php?id=start:100serverintegration:30chatlog
    def export_chat_record(token, limit=10, cursor = nil, sq = nil)
      url = "#{@host}/#{@org}/#{@app}/chatmessages"
      params = {limit: limit}
      unless cursor == nil
        params.merge!({ cursor: cursor })
      end
      unless sq == nil
        params.merge!({ ql: URI::encode(sq) })
      end

      header = { Authorization: "Bearer #{token}", accept: :json , params: params }
      begin
        ret = RestClient.get(url, header)
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end


    # 群组管理
    # 获取群组
    # limit: 限制获取的数量
    # cursor: 游标
    def get_groups(token, cursor = nil, limit = nil)
      url = "#{@host}/#{@org}/#{@app}/chatgroups"
      header = { Authorization: "Bearer #{token}", accept: :json }
      if limit != nil
        header.merge!({ limit: limit })
      end
      if cursor != nil
        header.merge!({ cursor: cursor })
      end

      begin
        ret = RestClient.get(url, header)
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 创建群组
    def create_group(token, group_params)
      url = "#{@host}/#{@org}/#{@app}/chatgroups"
      header = { Authorization: "Bearer #{token}", accept: :json }

      group_private_or_not = group_params[:group_private_or_not] || true  # 默认为公开群，
      maxusers = group_params[:maxusers] || 300  # 群组成员最大数(包括群主),默认值300,可选
      approval = group_params[:approval] || true  # 默认需要群组批准, 可选

      params = {
        groupname: group_params[:groupname],  # 群组名称, 此属性为必须的
        desc: group_params[:desc],  # 群组描述, 此属性为必须的
        public: group_private_or_not,
        maxusers: maxusers,
        approval: approval,
        owner: group_params[:owner]  # 群组的管理员, 此属性为必须的
      }
      begin
        ret = RestClient.post url, params.to_json, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 修改群组信息
    def update_group(token, group_id, group_msg_params)
      url = "#{@host}/#{@org}/#{@app}/chatgroups/#{group_id}"
      header = { Authorization: "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.put url, group_msg_params.to_json, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 删除群组
    def destroy_group(token, group_id)
      url = "#{@host}/#{@org}/#{@app}/chatgroups/#{group_id}"
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

    # 获取群组的所有成员
    def get_group_usrs(token, group_id)
      url = "#{@host}/#{@org}/#{@app}/chatgroups/#{group_id}/users"
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

    # 群组加人
    def group_add_user(token, group_id, username)
      url = "#{@host}/#{@org}/#{@app}/chatgroups/#{group_id}/users/#{username}"
      header = { Authorization: "Bearer #{token}", accept: :json }
      begin
        ret = RestClient.post url, {}, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 群组加人，批量
    def group_add_users(token, group_id, users)
      url = "#{@host}/#{@org}/#{@app}/chatgroups/#{group_id}/users"
      header = { Authorization: "Bearer #{token}", accept: :json }
      params = {
        usernames: users
      }
      begin
        ret = RestClient.post url, params.to_json, header
        return json ret
      rescue => ex
        $logger.error(ex.response.inspect)
        ret = ex.response
        return json(ret)
      end
    end

    # 群组减人(单个多个均可)
    def group_remove_users(token, group_id, users)
      user_s = []
      user_names = ''
      if users.is_a? Array
        user_s = users
      else
        user_s << users
      end

      # 用户
      user_s.each do |user|
        user_names += user + ','
      end

      url = "#{@host}/#{@org}/#{@app}/chatgroups/#{group_id}/users/#{user_names.chop!}"
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