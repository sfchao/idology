require 'spec_helper'

include IDology

describe IDology do
  
  it "should default to using summary results" do
    IDology[:summary_results].should be_true
  end

end