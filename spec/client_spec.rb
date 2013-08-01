# coding: utf-8
require 'spec_helper'

describe Evostream::Client do
  subject {
    Evostream::Client.new(:host => 'somehost', :path_prefix => '/some_path')
  }

  it "should respond to an empty liststreams" do
    stub_request(:get, "http://somehost:80/some_path/liststreams").
      to_return(:body => '{"data":null,"description":"","status":"SUCCESS"}')
    subject.liststreams.should be_nil
  end

  it "should respond to a non empty liststreams" do
    liststreams = '{"data":[{"appName": "evostreamms"}],"description":"Available streams","status":"SUCCESS"}'
    stub_request(:get, "http://somehost:80/some_path/liststreams").
      to_return(:body => liststreams)
    subject.liststreams.should == JSON.parse(liststreams)['data']
  end

  it "should respond to a non implemented method" do
    stub_request(:get, "http://somehost:80/some_path/liststreams").
      to_return(:body => '{"data":null,"description":"command non_existant_service not known. Type help for list of commands","status":"FAIL"}')
    expect { subject.non_existant_service }.to raise_error
  end

  it "should encode params with base64" do
    stub_request(:get, "http://somehost:80/some_path/some_service?params=Zmlyc3RfcGFyYW09eHh4IHNlY29uZF9wYXJhbT14eHg=").
      to_return(:body => '{"data":null,"description":"","status":"SUCCESS"}')
    subject.some_service(:first_param => 'xxx', :second_param => 'xxx').should be_nil
  end
end
