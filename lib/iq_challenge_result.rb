module Idology
  class IQChallengeResult
    include HappyMapper
    tag 'idliveq-challenge-result'
    element :key, String
    element :message, String
    
    def verified?
      case key
      when "error"
        # if there are any errors, fail right away
        return false
      when "result.timeout"
        # timeouts fail right away
        return false
      when "result.challenge.0.incorrect"
        # all correct passes
        return true
      when "result.challenge.1.incorrect"
        # one incorrect answer fails
        return false
      when "result.challenge.2.incorrect"
        # two incorrect passes, but we will challenge
        return false
      else
        # fail by default
        return false
      end
    end
  end
end