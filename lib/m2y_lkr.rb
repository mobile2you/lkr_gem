require 'm2y_lkr/configuration/configuration'
require 'm2y_lkr/constants/constants'
require 'm2y_lkr/modules/base'
require 'm2y_lkr/modules/billet'
require 'm2y_lkr/modules/extract'
require 'm2y_lkr/modules/cards'
require 'm2y_lkr/modules/registration'
require 'm2y_lkr/modules/login'
require 'm2y_lkr/modules/addresses'
require 'm2y_lkr/modules/links'

module M2yLkr

  # Gives access to the current Configuration.
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    yield(config)
  end

  def self.with_configuration(config)
    original_config = {}

    config.each do |key, value|
      original_config[key] = configuration.send(key)
      configuration.send("#{key}=", value)
    end

    yield if block_given?
  ensure
    original_config.each { |key, value| configuration.send("#{key}=", value) }
  end

end
