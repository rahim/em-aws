shared_examples "an AWS Response" do

  it "knows its header" do
    expect(subject.header.content_type).to be == 'text/xml'
  end
  
  it "knows its status" do
    expect(subject.status).to be == @response.response_header.status
  end
  
  it "retains the raw result" do
    expect(subject.body).to be == @response.response
  end
  
end