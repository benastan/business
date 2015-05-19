module Business
  class Facade < SimpleDelegator
    def initialize(business, facade)
      @business = business
      @facade = facade
      @method_name = ActiveSupport::Inflector.underscore(facade).to_sym
      @method = @business.instance_method(@method_name)
    end

    def call(context)
      business = context.is_a?(Hash) ? @business.new(context) : context
      __setobj__(business)
      business.send(@method_name)
      self  
    end

    def to_s
      "#{@business}::#{@facade}"
    end
  end
end
