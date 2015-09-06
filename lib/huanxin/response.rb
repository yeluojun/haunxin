module Huanxin
  class << self
    def response(ret )
      case http_code.to_i
        when 200
        when 400
        when 401
      end
    end
  end
end