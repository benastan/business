module Business
  module InstanceMethods

    def initialize(context)
      @context = context
      params.each { |param| set_param(param) }
      setup
    end

    def setup
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

    def set_param(param)
      instance_variable_set(:"@#{param}", context.fetch(param))
    end

    def defaults
      self.class.instance_variable_get(:@defaults)
    end

    def params
      self.class.instance_variable_get(:@params)
    end
  end
end