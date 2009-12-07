module IDology
  class IQError
    include HappyMapper
    tag 'idliveq-error'
    element :key, String
    element :message, String
  end
end