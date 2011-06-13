require 'emilio/version'

require 'net/imap'
require 'net/http'

require 'emilio/logger'
require 'emilio/railtie' if defined?(Rails)
require 'emilio/checker'
require 'emilio/receiver'

module Emilio
  mattr_accessor :logger

  # Your parser class, must be defined
  mattr_accessor :parser

  # Optional label to be added to parsed emails
  mattr_accessor :add_label

  # In which mailbox look for new emails to be parsed. This is "Inbox" by
  # default, but can be changed to anything if you want custom behaviour. For
  # instance you can define a filter or a set of filters in your Gmail account to
  # move emails to be parsed into a specific folder (assign a label) and only
  # parse emails with that label (equivalent mailbox name).
  mattr_accessor :mailbox

  # Which sheduler use, if any
  mattr_accessor :scheduler

  # Settings of your IMAP account
  mattr_accessor :host
  mattr_accessor :port
  mattr_accessor :username
  mattr_accessor :password

  @@mailbox = "Inbox"

  def self.configure
    yield self
  end
end

Dir["#{File.dirname(__FILE__)}/emilio/schedulers/*.rb"].each{|f| require f}

