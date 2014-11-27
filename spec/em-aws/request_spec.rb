require_relative '../spec_helper'

describe EventMachine::AWS::Request do
  subject {EM::AWS::Request.new DummyQuery.new, :get, 'Action' => 'DummyAction', 'SomeParam' => 5}
  
  it "knows its service" do
    expect(subject.service).to be_instance_of(DummyQuery)
  end
  
  it "knows its method" do
    expect(subject.method).to be == :get
  end
  
  it "knows its parameters" do
    expect(subject.params['SomeParam']).to be == 5
  end
  
  it "knows how many delivery tries it's had" do
    expect(subject.attempts).to be == 0
  end
  
  it "doesn't have a response when it's new" do
    expect(subject.response).to be_nil
  end
  
  it "doesn't have a status when it's new" do
    expect(subject.status).to be_nil
  end
  
  it "throws a method missing error on data access attempts" do
    expect(->{subject.dummy_value}).to raise_error(NoMethodError)
  end
  
  it "throws a method missing error on hash access attempts" do
    expect(->{subject[:dummy_value]}).to raise_error(NoMethodError)
  end
  
  
  it {should_not be_finished}
  
  it {should_not be_success}
    
  
  context "on successful response" do
    before(:each) do
      @response = EventMachine::AWS::Query::QueryResult.new DummyHttpResponse.new
      event {subject.succeed @response}
    end
    
    it {should be_finished}
    
    it {should be_success}
    
    it "knows its response" do
      expect(subject.response).to be == @response
    end
    
    it "makes the response data available as a hash" do
      expect(subject[:dummy_value]).to be == 'Garbonzo!'
    end
    
    it "makes the response data available as attributes" do
      expect(subject.dummy_value).to be == 'Garbonzo!'
    end
    
    it "knows its status after completion" do
      expect(subject.status).to be == 200
    end
    
    it "invokes any callback routines" do
      litmus = nil
      event {subject.callback {|r| litmus = r}}
      expect(litmus.dummy_value).to be == 'Garbonzo!'
    end
  end
  
  context "on failed response" do
    before(:each) do
      @response = EventMachine::AWS::Query::QueryFailure.new DummyHttpError.new
      event {subject.fail @response}
    end
    
    it {should be_finished}
    
    it {should_not be_success}
    
    it "knows its response" do
      expect(subject.response).to be == @response
    end
    
    it "knows its error from the response" do
      expect(subject.error).to be == 'DummyFailure'
    end
    
    it "throws an exception on data access" do
      expect(->{subject.dummy_value}).to raise_error(EM::AWS::Query::QueryError)
    end
    
    it "invokes any errback routines" do
      litmus = nil
      event {subject.errback {|r| litmus = r}}
      expect(litmus.code).to be == 'DummyFailure'
    end
    
  end
end