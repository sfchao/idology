module Idology
  class Qualifier
    include HappyMapper
    
    element :key, String
    element :message, String

  end
end