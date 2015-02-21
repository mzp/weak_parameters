module WeakParameters
  class ListValidator < WeakParameters::ArrayValidator
    attr_reader :validator
    def initialize(controller, key, validator)
      super controller, key, {}
      @validator = validator
    end

    def validate(*keys)
      super

      if valid? && exist?
        params.each.with_index do |_, i|
          validator.validate(*keys, key, index: i)
        end
      end
    end

    def validators
      [ validator ]
    end
  end
end
