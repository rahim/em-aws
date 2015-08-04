require_relative '../../spec_helper'

describe EventMachine::AWS::Query::QueryFailure do
  before(:each) do
    @response = DummyHttpError.new
  end
  
  subject {EventMachine::AWS::Query::QueryFailure.new @response}
  
  it_behaves_like "an AWS Response"
  
  it "knows its request ID" do
    expect(subject.request_id).to eq('f75889c3-520e-11e1-9f63-79e70d4e1f28')
  end
  
  it "knows its error type" do
    expect(subject.type).to eq('Sender')
  end
  
  it "knows its error code" do
    expect(subject.code).to eq('DummyFailure')
  end
  
  it "knows its error message" do
    expect(subject.message).to eq('This is a test failure.')
  end
  
  it "has an exception that can be raised" do
    expect(subject.exception).to be_instance_of(EventMachine::AWS::Query::QueryError)
  end
  
  it "can raise itself!" do
    expect(->{subject.exception!}).to raise_error(EventMachine::AWS::Query::QueryError, /DummyFailure/)
  end
  
  it "throws an exception when attempting to access any attributes" do
    expect(->{subject[:foo]}).to raise_error(EventMachine::AWS::Query::QueryError, /DummyFailure/)
  end

  it "throws an exception when calling dynamic methods" do
    expect(->{subject.foo}).to raise_error(EventMachine::AWS::Query::QueryError, /DummyFailure/)
  end
  
end