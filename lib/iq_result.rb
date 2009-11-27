module IDology
  class IQResult
    include HappyMapper
    tag 'idliveq-result'
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
  end
end