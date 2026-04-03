require_relative 'sport'
require_relative 'location'
require_relative 'team'

require 'date'


class Competition
  attr_accessor :title, :location, :prize_fund
  attr_reader :sports, :teams, :status, :start_date, :end_date
  VALID_STATUSES = ['upcoming', 'ongoing', 'completed', 'cancelled'].freeze
  
  def initialize(title, location, start_date, end_date, prize_fund, status='upcoming')
    @title = title
    @location = location
    @start_date = parse_date(start_date)
    @end_date = parse_date(end_date)
    ensure_correct_date_order!
    @prize_fund = prize_fund
    @status = 'upcoming'
    self.status=status

    @sports = []
    @teams = []
  end

  def status=(value)
    @status = value if VALID_STATUSES.include?(value) 
  end

  def start_date=(value)
    @start_date = parse_date(value)
    ensure_correct_date_order! if @end_date
  end

  def end_date=(value)
    @end_date = parse_date(value)
    ensure_correct_date_order! if @start_date
  end

  private def parse_date(date)
    date.is_a?(String) ? Date.parse(date) : date
  end

  private def ensure_correct_date_order!
    if @start_date && @end_date && @start_date > @end_date
      puts "⚠️ Attention: Start date (#{@start_date}) is later then end date (#{@end_date})!"
      puts "🔄 Autocorrect: Dates was swapped."      
      @start_date, @end_date = @end_date, @start_date
    end
  end

  def add_sport(sport)
    @sports << sport
  end

  def remove_sport(name)
    @sports.reject! { |sport| sport.name.downcase == name.downcase }
  end

  def add_team(team)
    @teams << team
  end

  def remove_team(name)
    @teams.reject! { |team| team.name.downcase == name.downcase }
  end

  def to_h()
    {
      title: @title,
      location: @location.to_h,
      sports: @sports.map(&:to_h),
      teams: @teams.map(&:to_h),
      start_date: @start_date.to_s,
      end_date: @end_date.to_s,
      prize_fund: @prize_fund,
      status: @status
    }
  end

  def self.from_h(hash)
    loc_obj = Location.from_h(hash[:location])

    comp = new(
      hash[:title],
      loc_obj,
      hash[:start_date],
      hash[:end_date],
      hash[:prize_fund],
      hash[:status]
    )

    hash[:sports].each do |sport_hash|
      comp.add_sport(Sport.from_h(sport_hash))
    end
    hash[:teams].each do |team_hash|
      comp.add_team(Team.from_h(team_hash))
    end

    comp
  end

  def to_s()
    "#{title} (#{location})\n" +
    "Sports: #{sports.join(', ')}\n" +
    "Teams: #{teams.join(', ')}\n" +
    "Date: #{start_date} - #{end_date}\n" +
    "Prize fund: #{prize_fund} | Status: #{status}"
  end

end