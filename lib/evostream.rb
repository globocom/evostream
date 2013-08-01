# coding: utf-8
require "evostream/version"
require "evostream/configuration"

module Evostream
  extend Configuration

  autoload :Client,  "evostream/client"
end
