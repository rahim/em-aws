require_relative '../spec_helper'


describe EventMachine::AWS::SQS do
  before(:each) do
    @original_access_key = EventMachine::AWS.aws_access_key_id
    @original_secret_key = EventMachine::AWS.aws_secret_access_key

    EventMachine::AWS.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
    EventMachine::AWS.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  end

  it "lets you find a SQS queue" do
    sqs = EM::AWS::SQS.new  region: 'eu-west-1'
    queue = EM::AWS::SQS.get 'My-Interesting-Queue'
    expect(queue).not_to be nil
  end

  after(:each) do
    EventMachine::AWS.aws_access_key_id = @original_access_key
    EventMachine::AWS.aws_secret_access_key = @original_secret_key
  end

end

