module IDology
  class Response
    include HappyMapper
    
    element :id, Integer, :tag => 'id-number'
    element :failed, String
    element :error, String
    element :iq_indicated, IDology::Boolean, :tag => 'idliveq-indicated', :parser => :parse
    element :eligible_for_questions, IDology::Boolean, :tag => 'eligible-for-questions', :parser => :parse
    
    has_one :result, IDology::Result
    has_one :summary_result, IDology::SummaryResult
    has_one :iq_result, IDology::IQResult
    has_one :iq_challenge_result, IDology::IQChallengeResult
    # has_one :iq_error, IDology::IQError
    has_many :qualifiers, IDology::Qualifier
    has_many :questions, IDology::Question
    
    def eligible_for_verification?
      result && result.match? && eligible_for_questions && !flagged_qualifier?
    end
    
    def verified?
      [iq_result, iq_challenge_result].compact.all?(&:verified?)
    end

    def challenge?
      # the logic for challenge questions is not relayed via the API, so we must set the logic here

      # do we need to ask 2 follow-up challenge questions? - only when 1/3 questions were correct
      iq_result.key == 'result.questions.2.incorrect'
    end
    
  private
    def flagged_qualifier?
      # these qualifier messages mean the subject is cannot be asked questions
      # they come from the Admin section of the IDology account, and can be changed if needed

      flagged = ["Subject is Deceased", "SSN unavailable", "SSN4 Does Not Match", "SSN Issued Prior to DOB", "SSN Is Invalid", "Single Address in File"]

      self.qualifiers.any?{|qualifier| flagged.include?(qualifier.message)}
    end
    
  end
end