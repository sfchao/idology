module Idology
  class Response
    include HappyMapper
    
    element :id, Integer, :tag => 'id-number'
    element :failed, String
    element :error, String
    element :iq_indicated, Idology::Boolean, :tag => 'idliveq-indicated', :parser => :parse
    element :eligible_for_questions, Idology::Boolean, :tag => 'eligible-for-questions', :parser => :parse
    
    has_one :result, Idology::Result
    has_one :summary_result, Idology::SummaryResult
    has_one :iq_result, Idology::IQResult
    # has_one :iq_error, Idology::IQError
    has_many :qualifiers, Idology::Qualifier
    has_many :questions, Idology::Question
    
    def eligible_for_verification?
      result.match? && eligible_for_questions && !flagged_qualifier?
    end
    
    def verified?
      case iq_result.key
      when "error"
        # if there are any errors, fail right away
        return false
      when "result.timeout"
        # timeouts fail right away
        return false
      when "result.questions.0.incorrect"
        # all correct passes
        return true
      when "result.questions.1.incorrect"
        # one incorrect answer passes
        return true
      when "result.questions.2.incorrect"
        # two incorrect passes, but we will challenge
        return true
      when "result.questions.3.incorrect"
        # three incorrect fails
        return false
      else
        # fail by default
        return false
      end
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