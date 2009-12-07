module IDology
  class IQChallengeResult
    include HappyMapper
    tag 'idliveq-challenge-result'
    element :key, String
    element :message, String
    
    def incorrect
      key =~ /result\.challenge\.(\d)\.incorrect/ ? $1.to_i : nil
    end

    def verified?
      incorrect == 0
    end
  end
end