class Location
  attr_reader :city

  def initialize(city)
    @city = city
  end

  def to_s
    @city
  end

  def to_h()
    {city: @city}
  end

  def self.from_h(hash)
    new(hash[:city])
  end
end