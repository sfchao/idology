require 'spec_helper'

include Idology

describe Response do
  
  describe "error" do
    it "should set the error message" do
      response = parse_response('error_response')
      response.error.should == 'Your IP address is not registered. Please call IDology Customer Service (770-984-4697).'
    end
  end
  
  describe "with questions" do
    before do
      @response = parse_response('questions_response')
    end
    
    it "should set the questions" do
      @response.questions.should_not be_empty
      @response.questions.size.should == 3
    end
    
    it "should include answers" do
      @response.questions.each do |question|
        question.answers.size.should == 6
        question.answers.last.should == 'None of the above'
      end
    end
  end
  
  describe "with qualifiers" do
    before do
      @response = parse_response('match_found_ssn_does_not_match')
    end
    
    it "should set the qualifiers" do
      @response.qualifiers.should_not be_empty
      @response.qualifiers.size.should == 2
    end
  end
  
  describe "with IQ result" do
    before do
      @response = parse_response('challenge_questions_response')
    end
    
    it "should set the IQ result" do
      @response.iq_result.should_not be_nil
      @response.iq_result.key.should == 'result.questions.2.incorrect'
      @response.iq_result.message.should == 'Two Incorrect Answers'
    end
  end
end