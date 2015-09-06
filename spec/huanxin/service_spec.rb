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
    p  Huanxin.config
    @service = Huanxin::Service.new
  end

  # get token test
  it 'should get token' do
    ret = @service.get_token
    expect(ret['code']).to eq 200
  end

  # 注册用户测试
  context 'POST#register users' do
    it 'register users success' do
      ret = @service.get_token
      ret = @service.register('yeluo', '12345678', ret['access_token'])
      expect(ret['code']).to eq 200
    end

    it 'register fail when username is not allow' do
      ret = @service.get_token
      ret = @service.register('修磊狮虎', '12345678', ret['access_token'])
      expect(ret['code']).to eq 400
    end
  end

end
