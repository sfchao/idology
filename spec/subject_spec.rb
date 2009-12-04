require 'spec_helper'

include IDology

describe Subject do
  
  before do
    FakeWeb.clean_registry
    IDology[:username] = 'fake'
    IDology[:password] = 'fake'
  end
  
  describe "locate" do
    
    describe "with a match" do
      before do
        fake_idology(:search, 'match_found_response')
        @subject = Subject.new
      end
    
      it "should be able to locate a person" do
        @subject.locate.should_not be_false
      end
    
      it "should set the ID" do
        @subject.locate
        @subject.id.should == 5342889
      end
      
      it "should know if the subject is eligible for verification questions" do
        @subject.locate
        @subject.eligible_for_verification.should be_true
      end
    
      it "should set any qualifiers" do
        @subject.locate
        expected = %w(resultcode.dob.does.not.match resultcode.address.does.not.match)
        @subject.qualifiers.map(&:key).to_set.should == expected.to_set
      end
    end
    
    it "should be false when it cannot locate" do
      fake_idology(:search, 'no_match_response')
      
      subject = Subject.new
      subject.locate.should be_false      
    end
    
  end
  
end
