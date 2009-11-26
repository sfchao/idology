module Idology
  class VerificationQuestionsRequest < Request

    def initialize
      # corresponds to an IDology ExpectID IQ API call
      self.url = 'https://web.idologylive.com/api/idliveq.svc'
      super
    end

    def set_data(subject)
      data_to_send = {
        :username => Idology[:username],
        :password => Idology[:password],
        :idNumber => subject.idNumber
      }

      self.data = data_to_send
    end
  end
end