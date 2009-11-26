module Idology
  class Result
    include HappyMapper
    tag 'results'
    element :key, String
    element :message, String
    
    def match?
      key == 'result.match'
    end
  end
end