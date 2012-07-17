require 'active_support/core_ext/object/blank'

module ValidatesFormattingOf

  class MissingValidation < StandardError
    def initialize(method)
      super("The validation method #{method.to_sym.inspect} has not been defined.")
    end
  end

  module ValidationAddition
    attr_reader :validations

    def add(name, regex, message = nil)
      @validations ||= {}
      @validations[name.to_sym] = Validation.new(name.to_sym, regex, message)
    end

    def find(attribute, opts = {})
      method = opts.fetch(:using, attribute)
      raise MissingValidation.new(method) if missing? method
      if method.to_sym == :ip_address
        warn "[DEPRECATION] The :ip_address validation for `validates_formatting_of` is DEPRECATED. Please update your model validations to use :ip_address_v4. This method will be removed by version 0.7.0."
      end
      @validations[method.to_sym]
    end

    def missing?(name)
      !exists?(name)
    end

    def exists?(name)
      @validations[name.to_sym].present?
    end
  end
end
