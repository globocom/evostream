# coding: utf-8
require 'spec_helper'

describe Evostream::Client do
  subject {
    Evostream::Client.new(:host => 'somehost', :path_prefix => '/some_path')
  }

  it "should handle a SUCCESS response with null data" do
    stub_request(:get, "http://somehost:80/some_path/liststreams").
      to_return(status: 200, body: '{"data":null,"description":"Available streams","status":"SUCCESS"}')
    subject.liststreams.should be_nil
  end

  it "should handle a SUCCESS response with data" do
    liststreams = '{"data":[{"appName": "evostreamms"}],"description":"Available streams","status":"SUCCESS"}'
    stub_request(:get, "http://somehost:80/some_path/liststreams").
      to_return(status: 200, body: liststreams)
    subject.liststreams.should == JSON.parse(liststreams)['data']
  end

  it "should handle a FAIL response of command not known to a non existant service" do
    stub_request(:get, "http://somehost:80/some_path/non_existant_service").
      to_return(status: 200, body: '{"data":null,"description":"command non_existant_service not known. Type help for list of commands","status":"FAIL"}')
    expect { subject.non_existant_service }.to raise_error(NoMethodError)
  end

  it "should handle a FAIL response with the error message returned by the api" do
    stub_request(:get, "http://somehost:80/some_path/createingestpoint").
      to_return(status: 200, body: '{"data":null,"description":"Unable to create ingest point `private_name` -> `public_name`","status":"FAIL"}')
    expect { subject.createingestpoint }.to raise_error("Unable to create ingest point `private_name` -> `public_name`")
  end

  it "should rescue from an unexpected response" do
    stub_request(:get, "http://somehost:80/some_path/liststreams").
      to_return(status: 200, body: '<html><head><title>It works!</title></head><body>It works!</body></html>')
    expect { subject.liststreams }.to raise_error(/^Invalid response:/)
  end

  it "should handle a 500 response" do
    stub_request(:get, "http://somehost:80/some_path/liststreams").
      to_return(status: 500, body: 'Internal server error')
    expect { subject.liststreams }.to raise_error('Internal server error')
  end

  it "should handle a 404 response" do
    stub_request(:get, "http://somehost:80/some_path/liststreams").
      to_return(status: 404, body: 'Not found')
    expect { subject.liststreams }.to raise_error('Not found')
  end

  it "should encode params as symbols with base64" do
    stub_request(:get, /.*some_service.*/).
      to_return(status: 200, body: '{"data":null,"description":"","status":"SUCCESS"}')
    subject.some_service(:first_param => 'xxx', :second_param => 'xxx')
    WebMock.should have_requested(:get, "http://somehost:80/some_path/some_service?params=Zmlyc3RfcGFyYW09eHh4IHNlY29uZF9wYXJhbT14eHg=")
  end

  it "should encode params as strings with base64" do
    stub_request(:get, /.*some_service.*/).
      to_return(status: 200, body: '{"data":null,"description":"","status":"SUCCESS"}')
    subject.some_service('first_param' => 'xxx', 'second_param' => 'xxx')
    WebMock.should have_requested(:get, "http://somehost:80/some_path/some_service?params=Zmlyc3RfcGFyYW09eHh4IHNlY29uZF9wYXJhbT14eHg=")
  end

  it "should encode params with url safe base64 to support longer param values" do
    stub_request(:get, /.*some_service.*/).
      to_return(status: 200, body: '{"data":null,"description":"","status":"SUCCESS"}')
    subject.some_service(:first_param => 'xxx', :second_param => 'xxx', :third_param => 'xxx')
    WebMock.should have_requested(:get, "http://somehost:80/some_path/some_service?params=Zmlyc3RfcGFyYW09eHh4IHNlY29uZF9wYXJhbT14eHggdGhpcmRfcGFyYW09eHh4")
  end
end
