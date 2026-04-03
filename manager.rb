require 'json'
require 'yaml'

require_relative 'competition'

class Manager
  attr_reader :collection

  def initialize()
    @collection = {}
  end

  def add_competition(comp)
    new_id = @collection.empty? ? 1 : @collection.keys.max + 1
    @collection[new_id] = comp
    puts "Added: #{comp.title} (ID: #{new_id})"
  end

  def list_competitions()
    if @collection.empty?
      puts 'Collection is empty.'
      return
    end

    @collection.each do |id, comp|
      puts "ID: #{id} | #{comp}"
      puts '-' * 40
    end
  end

  def delete_competition(id)
    if @collection.delete(id)
      puts "Competition with ID #{id} was deleted successfully."
    else
      puts "Error: Competition with ID #{id} not found."
    end
  end

  def edit_competition(id, new_data)
    comp = @collection[id]
    if comp.nil?
      puts "Error: Competition with ID #{id} not found."
      return
    end
    
    comp.title = new_data[:title] if new_data[:title] 
    comp.prize_fund = new_data[:prize_fund] if new_data[:prize_fund]
    comp.status = new_data[:status] if new_data[:status]
    new_data[:add_sports].each { |sport| comp.add_sport(sport) } if new_data[:add_sports]
    new_data[:add_teams].each { |team| comp.add_team(team) } if new_data[:add_teams]
    new_data[:remove_teams].each { |name| comp.remove_team(name) } if new_data[:remove_teams]
    new_data[:remove_sports].each { |name| comp.remove_sport(name) } if new_data[:remove_sports]

    puts "Competition with ID #{id} was changed successfully."
  end

  def find_by_title(title)
    @collection.select { |id, comp| comp.title.downcase.include?(title.downcase) }
  end

  def filter_by_sport(sport_name)
    @collection.select do |id, comp|
      comp.sports.map { |s| s.name.downcase }.include?(sport_name.downcase)
    end
  end

  def filter_by_status(status)
    @collection.select { |id, comp| comp.status.include?(status.downcase) }
  end

  def save_to_json(filename)
    hash_collection = {}
    @collection.each { |id, comp| hash_collection[id] = comp.to_h }

    File.write(filename, JSON.pretty_generate(hash_collection))
    puts "Data saved to JSON"
  end

  def load_from_json(filename)
    file_content = File.read(filename)
    raw_data = JSON.parse(file_content, symbolize_names: true)

    @collection = {}
    raw_data.each do |id, comp_hash|
      @collection[id.to_s.to_i] = Competition.from_h(comp_hash)
    end
    puts "Data loaded from JSON."
  
  rescue Errno::ENOENT
    puts "File #{filename} not found. Created empty collection."
    @collection = {}
  rescue JSON::ParserError => e
    puts "Error: #{e.message}"
    @collection = {}
  end

  def save_to_yaml(filename)
    File.write(filename, YAML.dump(@collection))
    puts "Data saved to YAML."
  end

  def load_from_yaml(filename)
    @collection = YAML.load_file(
      filename, 
      permitted_classes: [Competition, Location, Sport, Team, Date, Symbol]
    ) || {}
    puts "Data loaded from YAML."
  
  rescue Errno::ENOENT
    puts "File #{filename} not found. Created empty collection."
    @collection = {}
  rescue Psych::SyntaxError => e
    puts "Error: #{e.message}"
    @collection = {}
  end
end