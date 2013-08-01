# coding: utf-8
require 'spec_helper'

describe Evostream do
  after do
    Evostream.reset
  end

  describe '.configure' do
    Evostream::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do
        Evostream.configure do |config|
          config.send("#{key}=", key)
          Evostream.send(key).should == key
        end
      end
    end

    Evostream::Configuration::OPTIONAL_CONFIG_KEYS.each do |key|
      describe ".#{key}" do
        it 'should return the default value' do
          Evostream.send(key).should == Evostream::Configuration.const_get("DEFAULT_#{key.upcase}")
        end
      end
    end
  end
end
