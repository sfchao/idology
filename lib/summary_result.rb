module IDology
  class SummaryResult
    include HappyMapper
    tag 'summary-result'
    
    element :key, String
    element :message, String
  end
end