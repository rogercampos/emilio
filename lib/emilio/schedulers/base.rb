module Emilio
  module Schedulers
    mattr_accessor :last_check_at
    mattr_accessor :registered_schedulers
    @@registered_schedulers = []
  end

  def self.scheduler=(type)
    unless Schedulers.registered_schedulers.include?(type.to_sym)
      raise NotImplementedError, "This scheduler is not supported."
    end

    @@scheduler = "Emilio::Schedulers::#{type.to_s.classify}".constantize.setup
  end
end
