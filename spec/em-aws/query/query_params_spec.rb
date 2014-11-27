require_relative '../../spec_helper'
require 'em-aws/query/query_params'

describe "#queryize_params" do
  include EventMachine::AWS::Query::QueryParams
  
  subject do
    queryize_params zoo: 'zar',
      foo: {
        thingy: 'zingy',
        'Thangy' => 'zangy',
        complex: {
          value: '17',
          modify: true
        }
      },
      some_thing: 'else',
      'happy' => 'Fun Ball',
      attributes: "to clean living",
      an_array: [11, 'hello', false]
      
  end

  it "capitalizes symbol keys" do
    expect(subject['Zoo']).to be == 'zar'
  end
  
  it "doesn't touch string keys" do
    expect(subject['happy']).to be == 'Fun Ball'
  end
  
  it "camelcases symbol keys" do
    expect(subject['SomeThing']).to be == 'else'
  end
  
  it "splits out subhashes" do
    expect(subject['Foo.1.Name']).to be == 'Thingy'
    expect(subject['Foo.1.Value']).to be == 'zingy'
  end
  
  it "has multiple values from subhashes" do
    expect(subject['Foo.2.Name']).to be == 'Thangy'
    expect(subject['Foo.2.Value']).to be == 'zangy'
  end
  
  it "splits out values from sub-subhashes" do
    expect(subject['Foo.3.Name']).to be == 'Complex'
    expect(subject['Foo.3.Value']).to be == '17'
    expect(subject['Foo.3.Modify']).to be true
  end
  
  it "singularizes 'attributes' for readability" do
    expect(subject['Attribute']).to be == 'to clean living'
    expect(subject['Attributes']).to be_nil
  end
  
  it "splits out arrays" do
    expect(subject['AnArray.1']).to be == 11
    expect(subject['AnArray.2']).to be == 'hello'
    expect(subject['AnArray.3']).to be false
  end
end