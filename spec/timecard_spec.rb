require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Timecard" do
  it "has DEBUG disabled" do
    Timecard::DEBUG.should == false
  end
end
