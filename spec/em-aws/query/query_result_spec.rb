require_relative '../../spec_helper'

describe EventMachine::AWS::Query::QueryResult do
  before(:each) do
    @response = DummyHttpResponse.new
  end
  
  subject {EventMachine::AWS::Query::QueryResult.new @response}
  
  it_behaves_like "an AWS Response"
  
  it "tracks its inner attributes" do
    expect(subject[:dummy_value]).to be == 'Garbonzo!'
  end
  
  it "gets attributes indifferently" do
    expect(subject['DummyValue']).to be == 'Garbonzo!'
  end
  
  it "can make dynamic method calls" do
    expect(subject.dummy_value).to be == 'Garbonzo!'
  end
  
  it "handles arrays of members" do
    expect(subject[:topics].size).to be == 2
    expect(subject.topics.first).to eq({topic_arn: 'arn:aws:sns:us-east-1:429167422711:EM-AWS-Test-Topic'})
  end
  
  it "treats multiple elements with the same name as an array" do
    expect(subject.plural_thing).to be == [17, 'hello', 9.2]
  end
  
  it "handles key/value entry pairs" do
    expect(subject[:attributes].size).to be == 3
    expect(subject.attributes[:foo]).to eq('Bar')
  end
  
  it "knows its action" do
    expect(subject.action).to be == 'DummyAction'
  end
  
  it "knows its request ID" do
    expect(subject.request_id).to be == 'd6252bf1-5210-11e1-892f-6dd5825e297d'
  end
  
  it "converts to integers appropriately" do
    expect(subject.attributes[:some_timestamp]).to be == 1328734660
  end
  
  it "converts to floats appropriately" do
    expect(subject.attributes[:some_num]).to be == 22.500
  end
  
  it "returns an empty value on dynamic method calls instead of failing" do
    expect(subject.empty_value).to be_nil
  end
  
  
end