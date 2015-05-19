module Business
  module ClassMethods
    def perform(context)
      new(context).perform
    end

    def const_missing(const_name)
      begin
        Facade.new(self, const_name)
      rescue NameError
        super
      end
    end
  end
end