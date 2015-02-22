module WeakParameters
  class Validator
    attr_reader :block, :controller

    def initialize(controller, &block)
      @controller = controller
      instance_eval(&block)
    end

    def validate
      validators.each(&:validate)
    end

    def validators
      @validators ||= []
    end

    private

    def with_validators(&block)
      old_validators = @validators

      begin
        @validators = []
        block.call
        @validators
      ensure
        @validators = old_validators
      end
    end

    def params
      controller.params
    end

    def any(key, options = {}, &block)
      validators << WeakParameters::AnyValidator.new(controller, key, options, &block)
    end

    def string(key, options = {}, &block)
      validators << WeakParameters::StringValidator.new(controller, key, options, &block)
    end

    def integer(key, options = {}, &block)
      validators << WeakParameters::IntegerValidator.new(controller, key, options, &block)
    end

    def boolean(key, options = {}, &block)
      validators << WeakParameters::BooleanValidator.new(controller, key, options, &block)
    end

    def hash(key, options = {}, &block)
      validators << WeakParameters::HashValidator.new(controller, key, options, &block)
    end

    def array(key, options = {}, &block)
      validators << WeakParameters::ArrayValidator.new(controller, key, options, &block)
    end

    def float(key, options = {}, &block)
      validators << WeakParameters::FloatValidator.new(controller, key, options, &block)
    end

    def file(key, options = {}, &block)
      validators << WeakParameters::FileValidator.new(controller, key, options, &block)
    end

    def object(key, options = {}, &block)
      children = with_validators { instance_eval(&block) }
      validators << WeakParameters::ObjectValidator.new(controller, key, children, options)
    end

    def list(key, type, options = {}, &block)
      children = with_validators { send type, nil, options, &block }
      validators << WeakParameters::ListValidator.new(controller, key, children.first)
    end
  end
end
