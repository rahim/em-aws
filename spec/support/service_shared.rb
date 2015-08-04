shared_examples "a Service" do
  context "on initializing" do
    def new_subject(*args)
      subject.class.new(*args)
    end
  
    it "knows its endpoint" do
      expect(subject.url).to be =~ /^https:.*amazonaws\.com\//
    end
  
    it "defaults to the global region" do
      expect(subject.region).to be == 'us-east-1'
    end
  
    it "can override the region" do
      expect(new_subject(region: 'ap-southeast-1').region).to be == 'ap-southeast-1'
    end
  
    it "defaults to the global SSL setting" do
      expect(subject.ssl).to be_truthy
    end
  
    it "can override the SSL setting" do
      expect(new_subject(ssl: false).ssl).to be false
    end
  
    it "computes the endpoint from the provided region and SSL settings" do
      this = new_subject(ssl: false, region: 'eu-west-1')
      expect(this.url).to be =~ /^http:.*eu-west-1/
    end
  
    it "can override the endpoint" do
      this = new_subject(url: 'http://blahblah.org')
      expect(this.url).to be == 'http://blahblah.org'
    end  
    
    it "defaults to the global AWS credentials" do
      expect(subject.aws_access_key_id).to be == EventMachine::AWS.aws_access_key_id
      expect(subject.aws_secret_access_key).to be == EventMachine::AWS.aws_secret_access_key
    end
    
    it "can override the credentials" do
      this = new_subject(aws_access_key_id: "FAKE_OVERRIDE_ACCESS", aws_secret_access_key: "FAKE_OVERRIDE_SECRET")
      expect(this.aws_access_key_id).to be == "FAKE_OVERRIDE_ACCESS"
      expect(this.aws_secret_access_key).to be == "FAKE_OVERRIDE_SECRET"
    end
    
    it "defaults to POST queries" do
      expect(subject.method).to be == :post
    end
    
    it "can override the HTTP method" do
      this = new_subject(method: :get)
      expect(this.method).to be == :get
    end
  end
  
  context "making requests", :mock do
    before(:all) do
      @old_retries = EM::AWS.retries
    end
    
    before(:each) do
      @request = EM::AWS::Request.new(subject, :post, foo: 'bar')
      @response = nil
      @request.callback {|r| @response = r; EM.stop}
      @request.errback {|r| @response = r; EM.stop}
    end
    
    context "on network errors", :slow do
      before(:each) do
        stub_request(:post, subject.url).to_timeout.to_timeout.to_timeout.to_return(status: 200, body: 'Success')
      end
      
      it "retries on HTTP request failure" do
        EM.run {subject.send(:send_request, @request)}
        expect(@response.body).to be == 'Success'
        expect(@request.attempts).to be == 4
      end
    
      it "fails out if the retry limit is exceeded" do
        EM::AWS.retries = 2
        EM.run {subject.send(:send_request, @request)}
        expect(@response).to be_instance_of(EM::AWS::FailureResponse)
        expect(@request.attempts).to be == 3
      end
      
      it "delays based on Fibonacci sequence" do
        start_time = Time.now
        EM.run {subject.send(:send_request, @request)}
        expect((Time.now - start_time)).to be_within(0.1).of(4)
      end
    end
    
    context "on Amazon 500 errors" do
      before(:each) do
        stub_request(:post, subject.url).to_return(status: 500).to_return(status: 503).to_return(status: 502).to_return(status: 200, body: 'Success')
      end
      
      it "retries until success" do
        EM.run {subject.send(:send_request, @request)}
        expect(@response.body).to be == 'Success'
        expect(@request.attempts).to be == 4
      end

      it "fails out if the retry limit is exceeded" do
        EM::AWS.retries = 2
        EM.run {subject.send(:send_request, @request)}
        expect(@response).to be_instance_of(EM::AWS::Query::QueryFailure)
        expect(@request.attempts).to be == 3
      end

      it "delays based on Fibonacci sequence" do
        start_time = Time.now
        EM.run {subject.send(:send_request, @request)}
        expect((Time.now - start_time)).to be_within(0.1).of(4)
      end
    end
    
    after(:each) do
      EM::AWS.retries = @old_retries
    end
  end
  

end