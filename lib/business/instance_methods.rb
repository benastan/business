module Business
  module InstanceMethods

    def initialize(context)
      @context = context
      set_params
      setup
    end

    def setup
    end

    def update(updated_context)
      @context.merge!(updated_context)
      set_params
      setup
    end

    def perform
      defaults.each { |param| send(param) }
      self
    end

    def fail!(message: nil)
      @failed = true
      @message = message if message
    end

    def success?
      !@failed
    end

    protected

    def set_params
      params.each { |param| set_param(param) }
    end

    def set_param(param)
      if param.is_a?(Hash)
        param.each do |(key, val)|
          instance_variable_set(:"@#{key}", context.fetch(key, val))
        end
      else
        instance_variable_set(:"@#{param}", context.fetch(param))
      end
    end

    def defaults
      self.class.instance_variable_get(:@defaults)
    end

    def params
      self.class.instance_variable_get(:@params)
    end
  end
end