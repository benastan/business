require 'bundler'
Bundler.require
require 'business'

describe Business do
  class Car
    attr_reader :window, :gas

    def initialize(name)
      @name = name
      @gas = 100
    end

    def tow!
      @window = :broken
    end

    def deplete!(amount = 1)
      @gas -= amount
    end
  end

  class Factory
    include Business
    attr_reader :greeting, :exhaust, :car
    @params = [ :name, :sound ]
    @defaults = [ :create_car, :drive ]
    
    def create_car
      @car = Car.new(@name)
      @greeting = "Hello! My name is #{@name}"
    end

    def drive
      @exhaust = "#{@sound}! #{@sound}!"
      @car.deplete!
    end

    def tow
      car.tow!
      fail!(message: 'Oh Noes!')
    end

    def floor_it
      car.deplete!(9)
    end
  end

  subject{Factory}

  specify do
    factory = Factory.perform(name: 'Bentley', sound: 'Vroom')
    expect(factory.greeting).to eq 'Hello! My name is Bentley'
    expect(factory.exhaust).to eq 'Vroom! Vroom!'

    factory = Factory::CreateCar.perform(name: 'Tesla', sound: 'Jingle')
    expect(factory.greeting).to eq 'Hello! My name is Tesla'
    expect(factory.exhaust).to be_nil

    factory.drive
    expect(factory.exhaust).to eq 'Jingle! Jingle!'
    expect(factory.car.gas).to eq 99

    Factory::Tow.perform(factory)
    expect(factory.car.window).to eq :broken
    expect(factory).to_not be_success
    expect(factory.message).to eq 'Oh Noes!'

    begin
      Factory::Plow
    rescue NameError => e
      expect(e.message).to eq 'uninitialized constant Factory::Plow'
    end

    Factory::FloorIt.perform(factory)
    expect(factory.car.gas).to eq 90
  end
end
