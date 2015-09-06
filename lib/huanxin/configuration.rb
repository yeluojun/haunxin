require 'active_support/configurable'
module Huanxin
  class << self
    # Configures global settings for Rongcloud
    #   Rongcloud.configure do |config|
    #     config.app_key = 10
    #   end
    def configure(&block)
      yield @config ||= Huanxin::Configuration.new
    end

    def config
      @config
    end
  end

  class Configuration  #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :org, :app, :client_id, :client_secret, :host, :log_file, :log_level
  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.org = ''
    config.app = ''
    config.client_id = ''
    config.client_secret = ''
    config.host = 'https://a1.easemob.com'
    config.log_file = ''
    config.log_level = :error
  end
end