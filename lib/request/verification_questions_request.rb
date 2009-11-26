module Idology
  class VerificationQuestionsRequest < Request

    def initialize
      # corresponds to an IDology ExpectID IQ API call
      self.url = 'https://web.idologylive.com/api/idliveq.svc'
      super
    end

    def set_data(subject)
      self.data = super(subject).merge(:idNumber => subject.idNumber)
    end
  end
end