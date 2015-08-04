require_relative '../spec_helper'

describe EventMachine::AWS::Inflections do
  include EventMachine::AWS::Inflections
  
  describe "#snakecase" do
    it "makes everything lowercase" do
      expect(snakecase('Foo')).to eq('foo')
    end
    
    it "turns word separators into underscores" do
      expect(snakecase('HeyYou')).to eq('hey_you')
    end    
  end
  
  
end