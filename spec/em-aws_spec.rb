require_relative 'spec_helper'

describe EventMachine::AWS do
  before(:each) do
    @original_access_key = EventMachine::AWS.aws_access_key_id
    @original_secret_key = EventMachine::AWS.aws_secret_access_key
  end
  
  it "lets you specify a global Access Key" do
    EventMachine::AWS.aws_access_key_id = 'BlahBlah'
    expect(EventMachine::AWS.aws_access_key_id).to be == 'BlahBlah'
  end

  it "lets you specify a global Secret Key" do
    EventMachine::AWS.aws_secret_access_key = 'BlahBlah'
    expect(EventMachine::AWS.aws_secret_access_key).to be == 'BlahBlah'
  end
  
  it "defaults the region to us-east-1" do
    expect(EventMachine::AWS.region).to be == 'us-east-1'
  end
  
  it "defaults to SSL being true" do
    expect(EventMachine::AWS.ssl).to be true
  end
  
  it "retries 10 times by default" do
    expect(EventMachine::AWS.retries).to be == 10
  end

  after(:each) do
    EventMachine::AWS.aws_access_key_id = @original_access_key
    EventMachine::AWS.aws_secret_access_key = @original_secret_key
  end
    
end

