module IDology
  class Qualifier
    include HappyMapper
    
    element :key, String
    element :message, String

  end
end