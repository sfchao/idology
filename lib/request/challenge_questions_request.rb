module IDology
  class ChallengeQuestionsRequest < Request

    def initialize
      # corresponds to an IDology ExpectID Challenge API call
      self.url = '/idliveq-challenge.svc'

      super
    end

    def set_data(subject)
      self.data = super(subject).merge(:idNumber => subject.idNumber)
    end
  end
end