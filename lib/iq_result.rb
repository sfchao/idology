module Idology
  class IQResult
    include HappyMapper
    tag 'idliveq-result'
    element :key, String
    element :message, String

  end
end