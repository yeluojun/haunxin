require 'spec_helper'
require 'yaml'
require 'active_support/core_ext/hash/keys'

describe Huanxin do
  before(:all) do
    CONFIG = YAML.load(File.open("#{Huanxin.root}/config.yml")).symbolize_keys
    @deault_config = CONFIG[:huanxin].symbolize_keys
  end

  it 'should setup config' do
    Huanxin.configure do |config|
      config.org = @deault_config[:org]
      config.app = @deault_config[:app]
      config.host = @deault_config[:host]
      config.client_id = @deault_config[:client_id]
      config.client_secret = @deault_config[:client_secret]
      config.log_file = @deault_config[:log_file]
      config.log_level = @deault_config[:log_level].to_sym
    end
    expect(Huanxin.config.org).to eql(@deault_config[:org])
    expect(Huanxin.config.app).to eql(@deault_config[:app])
    expect(Huanxin.config.host).to eql(@deault_config[:host])
    expect(Huanxin.config.client_id).to eql(@deault_config[:client_id])
    expect(Huanxin.config.client_secret).to eql(@deault_config[:client_secret])
  end
end
