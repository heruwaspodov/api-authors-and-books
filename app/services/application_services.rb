# frozen_string_literal: true

# ApplicationService is a base class for application services.
# It provides a basic implementation for calling services.
class ApplicationServices
  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError,
          "#{self.class} has not implemented method '#{__method__}'"
  end
end
