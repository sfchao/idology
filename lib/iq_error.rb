module IDology
  class IQError
    include HappyMapper
    tag 'idliveq-error'
    element :key, String
    element :message, String
    
    def to_s
      "#{key}: #{message}"
    end
  end
end