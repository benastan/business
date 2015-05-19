require 'active_support'
require "business/version"

module Business
  autoload :Facade, 'business/facade'
  autoload :ClassMethods, 'business/class_methods'
  autoload :InstanceMethods, 'business/instance_methods'
  attr_reader :message, :context

  def self.included(klass)
    klass.include(InstanceMethods)
    klass.extend(ClassMethods)
  end
end
