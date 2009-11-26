require File.dirname(__FILE__) + '/spec_helper'

include Idology

describe Response do

  it "should check for an error from the API" do
    response = parse_response('error_response')
    response.error.should_not be_nil
    response.error.should eql("Your IP address is not registered. Please call IDology Customer Service (770-984-4697).")
  end

  it "should store the results key, message, and ID from any non-error response" do
    response = parse_response('no_match_response')
    response.result.key.should eql("result.no.match")
    response.result.message.should eql("ID Not Located")
    response.id.should eql(5342330)
  end

  describe 'search response' do

    it "should be eligible_for_verification? if there is a match" do
      search = parse_response('match_found_response')
      search.result.key.should eql("result.match")
      search.result.message.should eql("ID Located")
      search.id.should eql(5342889)
      search.eligible_for_verification?.should be_true
    end

    it "should not be eligible_for_verification? if there is no match" do
      search = parse_response('no_match_response')
      search.result.key.should eql("result.no.match")
      search.result.message.should eql("ID Not Located")
      search.id.should eql(5342330)
      search.eligible_for_verification?.should be_false
    end

    it "should not be eligible_for_verification? if the response qualifiers note 'Single Address in File'" do
      search = parse_response('match_found_single_address')
      search.id.should eql(5922430)
      search.qualifiers.map(&:key).should include("resultcode.single.address")
      search.qualifiers.detect{|q| q.key == 'resultcode.single.address'}.message.should eql("Single Address in File")
      search.eligible_for_verification?.should be_false
    end

    it "should not be eligible_for_verification? if the response qualifiers note 'SSN4 Does Not Match'" do
      search = parse_response('match_found_ssn_does_not_match')
      search.id.should eql(5922430)
      search.qualifiers.map(&:key).should include("resultcode.ssn.does.not.match")
      search.qualifiers.detect{|q| q.key == 'resultcode.ssn.does.not.match'}.message.should eql("SSN4 Does Not Match")
      search.eligible_for_verification?.should be_false
    end

    it "should not be eligible_for_verification? if the response qualifiers note 'SSN Is Invalid'" do
      search = parse_response('match_found_ssn_invalid')
      search.id.should eql(5922430)
      search.qualifiers.map(&:key).should include("resultcode.ssn.invalid")
      search.qualifiers.detect{|q| q.key == 'resultcode.ssn.invalid'}.message.should eql("SSN Is Invalid")
      search.eligible_for_verification?.should be_false
    end

    it "should not be eligible_for_verification? if the response qualifiers note 'SSN Issued Prior to DOB'" do
      search = parse_response('match_found_ssn_issued_prior_to_dob')
      search.id.should eql(5922430)
      search.qualifiers.map(&:key).should include("resultcode.ssn.issued.prior.to.dob")
      search.qualifiers.detect{|q| q.key == 'resultcode.ssn.issued.prior.to.dob'}.message.should eql("SSN Issued Prior to DOB")
      search.eligible_for_verification?.should be_false
    end

    it "should not be eligible_for_verification? if the response qualifiers note 'SSN unavailable'" do
      search = parse_response('match_found_ssn_unavailable')
      search.id.should eql(5922430)
      search.qualifiers.map(&:key).should include("resultcode.ssn.not.available")
      search.qualifiers.detect{|q| q.key == 'resultcode.ssn.not.available'}.message.should eql("SSN unavailable")
      search.eligible_for_verification?.should be_false
    end

    it "should not be eligible_for_verification? if the response qualifiers note 'Subject is Deceased'" do
      search = parse_response('match_found_subject_deceased')
      search.id.should eql(5922430)
      search.qualifiers.map(&:key).should include("resultcode.subject.deceased")
      search.qualifiers.detect{|q| q.key == 'resultcode.subject.deceased'}.message.should eql("Subject is Deceased")
      search.eligible_for_verification?.should be_false
    end

  #  it "should not be eligible_for_verification? if the response qualifiers note 'Thin File'" do
  #    search = parse_response('match_found_thin_file_response')
  #    search.id.should eql(5922430)
  #    search.qualifiers.map(&:key) include("resultcode.thin.file")
  #    search.qualifiers.detect{|q| q.key == 'resultcode.thin.file'}.message.should eql("Thin File")
  #    search.eligible_for_verification?.should be_false
  #  end

  end

  describe 'verification questions response' do

    it "should be able to parse the questions returned" do
      q_response = parse_response('questions_response')
      q_response.result.key.should eql("result.match")
      q_response.result.message.should eql("ID Located")
      q_response.id.should eql(5343388)
      q_response.questions.should_not be_empty
      q_response.questions.size.should eql(3)
    end

    it "should not have any questions if none are returned" do
      q_response = parse_response('match_found_response') # invalid question response
      q_response.result.key.should eql("result.match")
      q_response.result.message.should eql("ID Located")
      q_response.id.should eql(5342889)
      q_response.questions.should be_empty
    end

    it "should be able to parse the questions correctly" do
      q_response = parse_response('questions_response')

      # from the questions_response.xml fixture - three questions
      question = q_response.questions.find {|q| q.prompt == "With which name are you associated?"}
      question.should_not be_nil
      question.type.should eql("alternate.names.phone")

      question = q_response.questions.find {|q| q.prompt == "Where was your social security number issued?"}
      question.should_not be_nil
      question.type.should eql("ssn.issued.in")

      question = q_response.questions.find {|q| q.prompt == "In which county have you lived?"}
      question.should_not be_nil
      question.type.should eql("current.county")
    end

    it "should be able to parse the answers correctly" do
      q_response = parse_response('questions_response')

      # from the questions_response.xml fixture - three questions with six answers each
      answers = q_response.questions.find {|q| q.prompt == "With which name are you associated?"}.answers
      answers.find {|a| a == "ENDO"}.should_not be_nil
      answers.find {|a| a == "ENRIQUEZ"}.should_not be_nil
      answers.find {|a| a == "EATON"}.should_not be_nil
      answers.find {|a| a == "ECHOLS"}.should_not be_nil
      answers.find {|a| a == "EPPS"}.should_not be_nil
      answers.find {|a| a == "None of the above"}.should_not be_nil

      answers = q_response.questions.find {|q| q.prompt == "Where was your social security number issued?"}.answers
      answers.find {|a| a == "Michigan"}.should_not be_nil
      answers.find {|a| a == "Wyoming"}.should_not be_nil
      answers.find {|a| a == "Arkansas"}.should_not be_nil
      answers.find {|a| a == "North Carolina"}.should_not be_nil
      answers.find {|a| a == "Illinois"}.should_not be_nil
      answers.find {|a| a == "None of the above"}.should_not be_nil

      answers = q_response.questions.find {|q| q.prompt == "In which county have you lived?"}.answers
      answers.find {|a| a == "PICKENS"}.should_not be_nil
      answers.find {|a| a == "ST MARY"}.should_not be_nil
      answers.find {|a| a == "FRANKLIN"}.should_not be_nil
      answers.find {|a| a == "ANDREWS"}.should_not be_nil
      answers.find {|a| a == "MIAMI"}.should_not be_nil
      answers.find {|a| a == "None of the above"}.should_not be_nil
    end
  end

  describe 'verification response' do

    it "should be able to handle a timeout response" do
      v_response = parse_response('verification_timeout_response')
      v_response.iq_result.key.should eql("result.timeout")
      v_response.iq_result.message.should eql("result.timeout")
    end

    it "should be able to handle an all answers correct response" do
      v_response = parse_response('all_answers_correct_response')
      v_response.iq_result.key.should eql("result.questions.0.incorrect")
      v_response.iq_result.message.should eql("All Answers Correct")
      v_response.verified?.should be_true
      v_response.challenge?.should be_false
    end

    it "should be able to handle a 1 answer incorrect response" do
      v_response = parse_response('1_answer_incorrect_response')
      v_response.iq_result.key.should eql("result.questions.1.incorrect")
      v_response.iq_result.message.should eql("One Incorrect Answer")
      v_response.verified?.should be_true
      v_response.challenge?.should be_false
    end

    it "should be able to handle a 2 answers incorrect response" do
      v_response = parse_response('2_answers_incorrect_response')
      v_response.iq_result.key.should eql("result.questions.2.incorrect")
      v_response.iq_result.message.should eql("Two Incorrect Answers")
      v_response.verified?.should be_true
      v_response.challenge?.should be_true
    end

    it "should be able to handle a 3 answers incorrect response" do
      v_response = parse_response('3_answers_incorrect_response')
      v_response.iq_result.key.should eql("result.questions.3.incorrect")
      v_response.iq_result.message.should eql("Three Incorrect Answers")
      v_response.verified?.should be_false
      v_response.challenge?.should be_false
    end

  end

  describe 'challenge questions response' do

    it "should be able to parse the questions returned" do
      q_response = parse_response('challenge_questions_response')
      q_response.result.key.should eql("result.match")
      q_response.result.message.should eql("Pass")
      q_response.id.should eql(5444900)
      q_response.questions.should_not be_empty
      q_response.questions.size.should eql(2) # only two questions sent back for challenge
    end

    it "should be able to parse the questions correctly" do
      q_response = parse_response('challenge_questions_response')

      # from the questions_response.xml fixture - three questions
      question = q_response.questions.find {|q| q.prompt == "Which of the following people do you know?"}
      question.should_not be_nil
      question.type.should eql("person.known")

      question = q_response.questions.find {|q| q.prompt == "Which street goes with your address number 840?"}
      question.should_not be_nil
      question.type.should eql("street.name")
    end

    it "should be able to parse the answers correctly" do
      q_response = parse_response('challenge_questions_response')

      # from the questions_response.xml fixture - three questions with six answers each
      answers = q_response.questions.find {|q| q.prompt == "Which of the following people do you know?"}.answers
      answers.find {|a| a == "FREDDY JEFFERS"}.should_not be_nil
      answers.find {|a| a == "ARTHUR DAVIS"}.should_not be_nil
      answers.find {|a| a == "KACIE JACKSON"}.should_not be_nil
      answers.find {|a| a == "KRISTA GRIFFIN"}.should_not be_nil
      answers.find {|a| a == "MIRIAIN SANCHEZ"}.should_not be_nil
      answers.find {|a| a == "None of the above"}.should_not be_nil

      answers = q_response.questions.find {|q| q.prompt == "Which street goes with your address number 840?"}.answers
      answers.find {|a| a == "ROBBIE VW"}.should_not be_nil
      answers.find {|a| a == "LUBICH DR"}.should_not be_nil
      answers.find {|a| a == "VICTOR WAY"}.should_not be_nil
      answers.find {|a| a == "VARSITY CT"}.should_not be_nil
      answers.find {|a| a == "VAQUERO DR"}.should_not be_nil
      answers.find {|a| a == "None of the above"}.should_not be_nil
    end
  end

  describe 'challenge verification response' do

    it "should be able to handle an all answers correct response" do
      v_response = parse_response('all_answers_correct_challenge_response')
      v_response.iq_result.key.should eql("result.challenge.0.incorrect")
      v_response.iq_result.message.should eql("result.challenge.0.incorrect")
      v_response.verified?.should be_true
    end

    it "should be able to handle a 1 answer incorrect response" do
      v_response = parse_response('one_answer_incorrect_challenge_response')
      v_response.iq_result.key.should eql("result.challenge.1.incorrect")
      v_response.iq_result.message.should eql("result.challenge.1.incorrect")
      v_response.verified?.should be_false
    end

    it "should be able to handle a 2 answers incorrect response" do
      v_response = parse_response('2_answers_incorrect_response')
      v_response.iq_result.key.should eql("result.challenge.2.incorrect")
      v_response.iq_result.message.should eql("result.challenge.2.incorrect")
      v_response.verified?.should be_false
    end
  end
  
end
