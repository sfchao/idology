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
    has_one :iq_error, IDology::IQError
    has_many :qualifiers, IDology::Qualifier
    has_many :questions, IDology::Question
    has_many :velocity_results, IDology::VelocityResult
    
    def eligible_for_verification?
      result && result.match? && (eligible_for_questions || questions)
    end
    
    def verified?
      [iq_result, iq_challenge_result].compact.all?(&:verified?)
    end
    
    def identified?
      IDology[:summary_results] ? summary_result.success? : result.match?
    end
  end
end