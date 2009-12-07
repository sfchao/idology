module IDology
  class VelocityResult
    include HappyMapper
    tag 'velocity-result'
    element :key, String
    element :message, String
  end
end