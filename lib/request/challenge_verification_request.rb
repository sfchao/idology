module IDology
  class ChallengeVerificationRequest < Request

    def initialize
      # corresponds to an IDology ExpectID Challenge API call
      self.url = '/idliveq-challenge-answers.svc'

      super
    end

    def set_data(subject)
      data_to_send = super(subject).merge(:idNumber => subject.idNumber)

      # each question has a chosen_answer that must be sent along with the question type
      count = 1
      subject.challenge_questions.each do |question|
        # the type / answer key pair takes the form of 'questionXType / questionXAnswer'
        type = "question#{count}Type"
        answer = "question#{count}Answer"

        data_to_send[type] = question.type
        data_to_send[answer] = question.chosen_answer

        count += 1
      end

      self.data = data_to_send
    end

  end
end