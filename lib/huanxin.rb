require 'huanxin/version'
require 'huanxin/configuration'
require 'huanxin/service'

module Huanxin
  # Your code goes here..
  module_function
  def root
    File.dirname __dir__
  end

  # Return the lib path of this gem.
  #
  # @return [String] Path of the gem's lib.
  def lib
    File.join root, 'lib'
  end

  # Return the spec path of this gem.
  #
  # @return [String] Path of the gem's spec.
  def spec
    File.join root, 'spec'
  end
end
