module WeakParameters
  class ObjectValidator < WeakParameters::HashValidator
    attr_reader :validators
    def initialize(controller, key, validators, options = {})
      super controller, key, options
      @validators = validators
    end

    def validate(*keys, index: nil)
      super
      validators.each { |validator| validator.validate(*(keys + [ key ]).compact, index: index) } if valid? && exist?
    end

    private

    def valid?
      case
      when required? && nil?
        false
      when exist? && invalid_type?
        false
      when exist? && exceptional?
        false
      else
        true
      end
    end

    def error_message
      prefix = keys.map { |k| "[#{k.inspect}]" }.join ''
      "params#{prefix}[#{key.inspect}] must be a valid Hash"
    end
  end
end
