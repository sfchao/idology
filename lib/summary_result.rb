module IDology
  class SummaryResult
    include HappyMapper
    tag 'summary-result'
    
    element :key, String
    element :message, String
    
    def success?
      key == 'id.success'
    end
  end
end