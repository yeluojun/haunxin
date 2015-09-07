require 'spec_helper'
require 'yaml'
require 'active_support/core_ext/hash/keys'

describe Huanxin do
  before(:all) do
    CONFIG = YAML.load(File.open("#{Huanxin.root}/config.yml")).symbolize_keys
    @deault_config = CONFIG[:huanxin].symbolize_keys
    Huanxin.configure do |config|
      config.org = @deault_config[:org]
      config.app = @deault_config[:app]
      config.host = @deault_config[:host]
      config.client_id = @deault_config[:client_id]
      config.client_secret = @deault_config[:client_secret]
      config.log_file = "#{Huanxin.root}/log/huanxin.log"
      config.log_level = @deault_config[:log_level].to_sym
    end
    @service = Huanxin::Service.new
    t = @service.get_token
    @token = t['access_token']
  end

  # get token test
  it 'should get token' do
    ret = @service.get_token
    expect(ret['code']).to eq 200
  end

  # 注册用户测试
  context 'POST#register' do
    it 'register user success' do
      ret = @service.register('yeluo', '12345678', @token)
      expect(ret['code']).to eq 200
    end

    it 'register fail when username is not allow' do
      ret = @service.register('修磊狮虎', '12345678', @token)
      expect(ret['code']).to eq 400
    end
  end

  # 批量注册用户测试
  context 'POST#register_s' do
    it 'should register one user' do
      ret = @service.register_s({ username: 'test2', password: '123456' }, @token)
      p ret
      expect(ret['code']).to eq 200
    end

    it 'should register two users' do
      ret = @service.register_s([{ username: 'test3', password: '123456' },
                                 { username: 'test4', password: '123456' }], @token)
      p ret
      expect(ret['code']).to eq 200
    end
  end

  # 获取单个用户
  context 'GET#get_user' do
    before do
      @service.register_s({ username: 'y_get_user', password: '123456' }, @token)
    end
    it 'should get one user' do
      ret = @service.get_user('y_get_user', @token)
      p ret
      expect(ret['code']).to eq 200
    end

    it 'should get 404' do
      ret = @service.get_user('no_name', @token)
      p ret
      expect(ret['code']).to eq 404
    end

    it 'should get 401' do
      ret = @service.get_user('y_get_user', '')
      p ret
      expect(ret['code']).to eq 401
    end
  end

  # 批量获取用户
  context  'GET#get_users' do
    before do
      @service.register_s([{ username: 'get_users_1', password: '123456' },
                           { username: 'get_users_2', password: '123456' },
                           { username: 'get_users_3', password: '123456' },
                           { username: 'get_users_4', password: '123456' },
                           { username: 'get_users_5', password: '123456' },
                           { username: 'get_users_6', password: '123456' },
                           { username: 'get_users_7', password: '123456' },
                           { username: 'get_users_8', password: '123456' },
                           { username: 'get_users_9', password: '123456' },
                           { username: 'get_users_10', password: '123456' },
                           { username: 'get_users_11', password: '123456' },
                           { username: 'get_users_12', password: '123456' },
                           { username: 'get_users_13', password: '123456' },
                           { username: 'get_users_14', password: '123456' },
                           { username: 'get_users_15', password: '123456' },
                           { username: 'get_users_16', password: '123456' },
                           { username: 'get_users_17', password: '123456' },
                           { username: 'get_users_18', password: '123456' },
                           { username: 'get_users_19', password: '123456' },
                           { username: 'get_users_20', password: '123456' },
                           { username: 'get_users_21', password: '123456' },
                           { username: 'get_users_22', password: '123456' },
                           { username: 'get_users_23', password: '123456' },
                           { username: 'get_users_24', password: '123456' },
                           { username: 'get_users_25', password: '123456' },
                           { username: 'get_users_26', password: '123456' },
                           { username: 'get_users_27', password: '123456' },
                           { username: 'get_users_28', password: '123456' },
                           { username: 'get_users_29', password: '123456' },
                           { username: 'get_users_30', password: '123456' },
                           { username: 'get_users_31', password: '123456' },
                           { username: 'get_users_32', password: '123456' },
                           { username: 'get_users_33', password: '123456' },
                           { username: 'get_users_34', password: '123456' },
                           { username: 'get_users_35', password: '123456'}], @token)
    end
    it 'should get two users' do
      ret = @service.get_users(@token, 30)
      expect(ret['code']).to eq 200
      expect(ret['entities'].length).to eq 30
      cursor = ret['cursor']

      # 获取下一页
      ret = @service.get_users(@token, 30, cursor)
      expect(ret['code']).to eq 200
      expect(ret['entities'].length).to eq 5
    end
  end

  # 测试删除用户
  context 'DELETE#delete_user' do
    before do
      @service.register('nimabi', '123456', @token)
    end
    it 'should delete a user named nimabi' do
      ret = @service.delete_user('nimabi', @token)
      p ret
      expect(ret['code']).to eq 200
    end
    it 'should be 404' do
      ret = @service.delete_user('no_this_user', @token)
      expect(ret['code']).to eq 404
    end
  end

  # 测试批量删除用户
  context  'DELETE#delete_users' do
    before do
      @service.register('delete_users_1', '123456', @token)
      @service.register('delete_users_2', '123456', @token)
    end
    it 'should delete two users' do
      ret = @service.delete_users @token, 2
      p ret
      expect(ret['code']).to eq 200
    end
  end

  # 测试重置用户密码
  context  'PUT#rest_password' do
    before do
      @service.register('rest_password_1', '123456', @token)
    end
    it 'should rest password' do
      ret = @service.reset_password @token, 'rest_password_1', '1234567'
      p ret
      expect(ret['code']).to eq 200
    end
  end

  # 测试修改用户昵称
  context  'PUT#set_nickname' do
    before do
      @service.register('set_nickname', '123456', @token)
    end
    it 'should rest password' do
      ret = @service.set_nickname @token, 'set_nickname', '雷洪'
      p ret
      expect(ret['code']).to eq 200
    end
  end

  context  'POST#add_friend' do
    before do
      @service.register('add_friend_owner', '123456', @token)
      @service.register('add_friend_friend', '123456', @token)
    end
    it 'should rest password' do
      ret = @service.add_friend @token, 'add_friend_owner', 'add_friend_friend'
      p ret
      expect(ret['code']).to eq 200
    end
  end

  context  'POST#remove_friend' do
    before do
      @service.register('remove_friend_owner', '123456', @token)
      @service.register('remove_friend_friend', '123456', @token)
      @service.add_friend @token, 'remove_friend_owner', 'remove_friend_friend'
    end
    it 'should rest password' do
      ret = @service.remove_friend @token, 'remove_friend_owner', 'remove_friend_friend'
      p ret
      expect(ret['code']).to eq 200
    end
  end

  context  'GET#get_friends' do
    before do
      @service.register('remove_friend_owner', '123456', @token)
      @service.register('remove_friend_friend', '123456', @token)
      @service.register('remove_friend_friend_2', '123456', @token)
      @service.add_friend @token, 'remove_friend_owner', 'remove_friend_friend'
      @service.add_friend @token, 'remove_friend_owner', 'remove_friend_friend_2'
    end
    it 'should rest password' do
      ret = @service.get_friends @token, 'remove_friend_owner'
      p ret
      expect(ret['code']).to eq 200
      expect(ret['data'].length).to eq 2
    end
  end

  context 'POST#blocks_add_users' do
    before do
      @service.register('block_friend_owner', '123456', @token)
      @service.register('block_friend_friend', '123456', @token)
      @service.register('block_friend_friend_2', '123456', @token)
      @service.add_friend @token, 'block_friend_owner', 'block_friend_friend'
      @service.add_friend @token, 'block_friend_owner', 'block_friend_friend_2'
    end
    it 'should rest password' do
      ret = @service.block_add_users @token, 'remove_friend_owner'
      p ret
      expect(ret['code']).to eq 200
      expect(ret['data'].length).to eq 2
    end
  end


end
