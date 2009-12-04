require 'net/http'
require 'net/https'
require 'logger'
require 'happymapper'
require 'httparty'
require 'yaml'
require File.dirname(__FILE__) + "/boolean"
require File.dirname(__FILE__) + "/iq_challenge_result"
require File.dirname(__FILE__) + "/iq_result"
require File.dirname(__FILE__) + "/question"
require File.dirname(__FILE__) + "/qualifier"
require File.dirname(__FILE__) + "/service"
require File.dirname(__FILE__) + "/subject"
require File.dirname(__FILE__) + "/result"
require File.dirname(__FILE__) + "/summary_result"
require File.dirname(__FILE__) + "/response"
require File.dirname(__FILE__) + "/request/request"
require File.dirname(__FILE__) + "/request/challenge_questions_request"
require File.dirname(__FILE__) + "/request/challenge_verification_request"
require File.dirname(__FILE__) + "/request/verification_questions_request"
require File.dirname(__FILE__) + "/request/verification_request"

module IDology
  def self.config
    @config ||= {}
  end
  
  def self.[](key)
    config[key]
  end

  def self.[]=(key, value)
    config[key.to_sym] = value
  end

  def self.load_config(file = nil)
    file ||= File.dirname(__FILE__) + "/../config.yml"
    YAML::load(File.open(file)).each{|k, v| config[k.to_sym] = v }
    config
  end
end