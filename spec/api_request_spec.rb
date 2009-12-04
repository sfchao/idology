require File.dirname(__FILE__) + '/spec_helper'

include IDology

describe Request do

  it "should set data with credentials from config.yml" do
    IDology.load_config File.dirname(__FILE__) + "/../spec/fixtures/sample_config.yml"
    IDology[:username].should eql("test_username")
    IDology[:password].should eql("test_password")
    
    request = Request.new
    request.set_data(Subject.new)
    request.data[:username].should eql("test_username")
    request.data[:password].should eql("test_password")
  end
  
  it "should not set data if username is not set" do
    IDology[:username] = ''
    IDology[:password] = 'something'
    request = Request.new
    lambda { request.set_data(Subject.new) }.should raise_error
  end
  
  it "should not set data if password is not set" do
    IDology[:username] = 'something'
    IDology[:password] = ''
    request = Request.new
    lambda { request.set_data(Subject.new) }.should raise_error
  end
end

describe ChallengeQuestionsRequest do

  include RequestSpecHelper

  before(:each) do
    IDology.load_config File.dirname(__FILE__) + "/../spec/fixtures/sample_config.yml"
    @challenge_questions_request = ChallengeQuestionsRequest.new
  end

  it "should initialze with a url" do
    @challenge_questions_request.url.should eql('/idliveq-challenge.svc')
  end

  it "should be able to set its own data given a subject" do
    @challenge_questions_request.data.should be_nil
    @challenge_questions_request.set_data(test_subject)
    @challenge_questions_request.data[:username].should eql("test_username")
    @challenge_questions_request.data[:password].should eql("test_password")
    @challenge_questions_request.data[:idNumber].should eql(12345)
  end

end

describe ChallengeVerificationRequest do

  include RequestSpecHelper

  before(:each) do
    IDology.load_config File.dirname(__FILE__) + "/../spec/fixtures/sample_config.yml"
    @challenge_verification_request = ChallengeVerificationRequest.new
  end

  it "should initiallize with a url" do
    @challenge_verification_request.url.should eql('/idliveq-challenge-answers.svc')
  end

  it "should be able to set its own data given a subject" do
    @challenge_verification_request.data.should be_nil
    @challenge_verification_request.set_data(test_subject)
    @challenge_verification_request.data[:username].should eql("test_username")
    @challenge_verification_request.data[:password].should eql("test_password")
    @challenge_verification_request.data[:idNumber].should eql(12345)

    # the question / answer data
    @challenge_verification_request.data[:question1Type] = "question.type1"
    @challenge_verification_request.data[:question1Answer] = "JANNE"
    @challenge_verification_request.data[:question2Type] = "question.type2"
    @challenge_verification_request.data[:question2Answer] = "142"
  end

end
