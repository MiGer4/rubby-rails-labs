class Team
  attr_reader :name

  def initialize(name)
      @name  = name
  end

  def to_s
    @name
  end

  def to_h()
    { name: @name }
  end

  def self.from_h(hash)
    new(hash[:name])
  end
end