module IDology
  class Service
    include HTTParty
    base_uri 'https://web.idologylive.com/api'
    # pem File.read(File.dirname(__FILE__) + '/certs/cacert.pem')
    parser lambda{|r| IDology::Response.parse(r)}
    
    attr_accessor :api_challenge_verification_response  

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