module IDology
  class Service
    include HTTParty
    base_uri 'https://web.idologylive.com/api'
    # pem File.read(File.dirname(__FILE__) + '/certs/cacert.pem')
    parser lambda{|r| IDology::Response.parse(r)}
    
    attr_accessor :api_challenge_question_response, :api_challenge_verification_response  

    def get_challenge_questions(subject)
      # get_challenge_questions is an IDology ExpectID Challenge API call - given a valid idNumber from an ExpectID IQ question
      # and response process, will return questions to further verify the subject

      question_request = ChallengeQuestionsRequest.new

      # assemble the data
      question_request.set_data(subject)

      # make the call
      response = Service.post(question_request.url, :body => question_request.data)
      self.api_challenge_question_response = response
    end

    def submit_challenge_answers(subject)
      # submit question type / answers to the IDology ExpectID Challenge API

      challenge_verification_request = ChallengeVerificationRequest.new

      # assemble the data
      challenge_verification_request.set_data(subject)

      # make the call
      response = Service.post(challenge_verification_request.url, :body => challenge_verification_request.data)
      self.api_challenge_verification_response = response
    end
  end
end