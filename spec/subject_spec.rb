require 'spec_helper'

include IDology

share_examples_for "Any Request" do
  it "should be able to locate a person" do
    @result.should_not be_false
  end

  it "should set the ID" do
    @subject.idNumber.should == 5342889
  end

  it "should set any qualifiers" do
    expected = %w(resultcode.dob.does.not.match resultcode.address.does.not.match)
    @subject.qualifiers.map(&:key).to_set.should == expected.to_set
  end
end

describe Subject do
  
  before do
    FakeWeb.clean_registry
    IDology[:username] = 'fake'
    IDology[:password] = 'fake'
    IDology[:summary_results] = false
  end
  
  describe "locate" do
    it "should error if username is not set" do
      IDology[:username] = ''
      lambda { Subject.new.locate }.should raise_error(IDology::Error)
    end

    it "should error if password is not set" do
      IDology[:password] = ''
      lambda { Subject.new.locate }.should raise_error(IDology::Error)
    end
    
    describe "with a match" do
      before do
        fake_idology(:search, 'match_found_response')
        @subject = Subject.new
        @result = @subject.locate
      end
    
      it_should_behave_like "Any Request"
      
      it "should know if the subject is eligible for verification questions" do
        @subject.should be_eligible_for_verification
      end
    end
    
    it "should be false when it cannot locate" do
      fake_idology(:search, 'no_match_response')
      
      subject = Subject.new
      subject.locate.should be_false      
    end
    
  end
  
  describe 'get_questions' do
    before do
      fake_idology(:questions, 'questions_response')
      @subject = Subject.new
      @result = @subject.get_questions
    end
    
    it_should_behave_like "Any Request"
    
    it "should set the verification questions" do
      q = @subject.questions.detect{|q| q.prompt == 'With which name are you associated?'}
      q.should_not be_blank
      q.answers.should == ['ENDO', 'ENRIQUEZ', 'EATON', 'ECHOLS', 'EPPS', 'None of the above']
    end
  end
  
  describe 'submit_answers' do
    before do
      fake_idology(:questions, 'questions_response')      
      fake_idology(:answers, 'all_answers_correct_response')
      @subject = Subject.new
      @subject.get_questions
      @result = @subject.submit_answers
    end
    
    it_should_behave_like "Any Request"
    
    it "should set the verified flag" do
      @subject.should be_verified
    end
  end
  
  describe 'get_challenge_questions' do
    before do
      fake_idology(:challenge_questions, 'challenge_questions_response')
      @subject = Subject.new
      @result = @subject.get_challenge_questions
    end
    
    it_should_behave_like "Any Request"
    
    it "should set the challenge questions" do
      q = @subject.questions.detect{|q| q.prompt == 'Which street goes with your address number 840?'}
      q.should_not be_blank
      q.answers.should == ['ROBBIE VW', 'LUBICH DR', 'VICTOR WAY', 'VARSITY CT', 'VAQUERO DR', 'None of the above']
    end
  end
  
  describe 'submit_challenge_answers' do
    before do
      fake_idology(:challenge_questions, 'questions_response')      
      fake_idology(:challenge_answers, 'all_answers_correct_response')
      @subject = Subject.new
      @subject.get_challenge_questions
      @result = @subject.submit_challenge_answers
    end
    
    it_should_behave_like "Any Request"
    
    it "should set the verified flag" do
      @subject.should be_verified
    end
  end
  
  describe 'errors' do
    before do
      fake_idology(:search, 'error_response')
      @subject = Subject.new
    end
    
    describe 'from IDology' do    
      it "should raise any errors received from IDology" do
        lambda{@subject.locate}.should raise_error(IDology::Error)
      end
    end
    
    describe 'from HTTP' do
      it 'should catch Timeout::Error and re-raise' do
        Subject.stub(:post).and_raise(Timeout::Error)
        lambda{@subject.locate}.should raise_error(IDology::Error)
      end
      
      it 'should catch Net::HTTPError and re-raise' do
        Subject.stub(:post).and_raise(Net::HTTPError.new('fake', 'fake'))
        lambda{@subject.locate}.should raise_error(IDology::Error)
      end
    end
  end  
end
