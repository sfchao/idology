module IDology
  class Subject
    include HTTParty
    base_uri 'https://web.idologylive.com/api'
    # pem File.read(File.dirname(__FILE__) + '/certs/cacert.pem')
    parser lambda{|r| IDology::Response.parse(r)}

    SearchAttributes = [:firstName, :lastName, :address, :city, :state, :zip, :ssnLast4, :dobMonth, :dobYear]
    CommonAttributes = [:idNumber, :uid]

    Paths = {
      :search => '/idiq.svc',
      :questions => '/idliveq.svc',
      :answers => '/idliveq-answers.svc'
    }

    attr_accessor *SearchAttributes
    attr_accessor *CommonAttributes
    attr_accessor :api_service, :qualifiers
    attr_accessor :verification_questions, :eligible_for_verification, :verified, :challenge
    attr_accessor :challenge_questions

    def initialize(data = nil)
      self.api_service = Service.new
      self.verified = self.challenge = self.eligible_for_verification = false
      self.qualifiers = ""

      data.each {|key, value| self.send "#{key}=", value } if data
    end

    def locate
      response = post(:search, SearchAttributes)
      
      response.result && response.result.match? ? response : false
    end

    def get_questions
      # get_questions is an IDology ExpectID IQ API call - which given a valid idNumber from an ExpectID API call
      # should return questions that can be asked to verify the ID of the person in question

      post(:questions)
    end

    def submit_answers
      answers = {}
      verification_questions.each_with_index do |question, index|
        answers["question#{index}Type"] = question.type 
        answers["question#{index}Answer"] = question.chosen_answer
      end
      
      response = post(:answers, [], answers)
      
      self.verified = response.verified?
      self.challenge = response.challenge?

      response
    end

    def get_challenge_questions
      response = self.api_service.get_challenge_questions(self)
      self.challenge_questions = response.questions

      return true

    rescue Exception
      return false
    end

    def submit_challenge_answers
      response = self.api_service.submit_challenge_answers(self)
      self.verified = response.verified?

      return true

    rescue Exception
      return false
    end

  private

    def post(url, attributes = [], data = {})
      data.merge!(:username => IDology[:username],
        :password => IDology[:password])
      
      (attributes | CommonAttributes).each do |key|
        data[key] = self.send(key) unless self.send(key).blank?
      end
    
      response = Subject.post(Paths[url], :body => data)
    
      copy_from_response response
      response
    end

    def copy_from_response(response)
      self.idNumber = response.id
      self.eligible_for_verification = response.eligible_for_verification?

      # we must track any qualifiers that come back
      self.qualifiers = response.qualifiers
      self.verification_questions = response.questions
    end
  end
end