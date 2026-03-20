require 'json'
require 'yaml'

# ```ruby
# competitions = {
#   1 => {
#     title: "Чемпіонат України з футболу",
#     sports: ["Футбол"],
#     teams: ["Динамо", "Шахтар", "Металіст"],
#     location: "Київ",
#     start_date: "2024-03-01",
#     end_date: "2024-05-30",
#     prize_fund: 100000.00,
#     status: "upcoming"  # upcoming/ongoing/completed/cancelled
#   },
#   2 => {
#     title: "Марафон Київ 2024",
#     sports: ["Легка атлетика"],
#     teams: ["Збірна України", "Збірна Польщі"],
#     location: "Київ",
#     start_date: "2024-04-21",
#     end_date: "2024-04-21",
#     prize_fund: 50000.00,
#     status: "upcoming"  # upcoming/ongoing/completed/cancelled
#   }
# }
# ```

STATUSES = ['upcoming', 'ongoing', 'completed', 'cancelled']

def add_competition(collection, title, sports, teams, location, start_date, end_date, prize_fund, status)
  new_id = collection.empty? ? 1 : collection.keys.max + 1
  if STATUSES.include?(status)
    puts "Invalid status #{status}, set default status 'upcoming'."
    status = 'upcoming'
  end
  collection[new_id] = {
    title: title, 
    sports: sports, 
    teams: teams, 
    location: location, 
    start_date: start_date, 
    end_date: end_date, 
    prize_fund: prize_fund, 
    status: status
  }
  puts "Added #{title} (ID: #{new_id})"
end

def edit_competition(collection, id, new_data)
    if collection.key?(id)
      collection[id].merge!(new_data)
      puts "Competition with ID #{id} updated successfully!"
    else
      puts "Error: Competition with #{id} doesn't exist"
    end
end

def delete_competition(collection, id)
  if collection.key?(id)
    collection.delete(id)
    puts "Competition with ID #{id} deleted successfully"
  else
    puts "Error: Competition with #{id} doesn't exist"
  end
end

def list_competitions(collection)
  if collection.empty?
    puts "Collection is empty"
    return
  end
  collection.each do |id, comp|
    puts "ID #{id} | #{comp[:title]} (#{comp[:location]}) #{comp[:start_date]} - #{comp[:end_date]}"
    puts "Disciplines: #{comp[:sports].join(', ')}"
    puts "Status: #{comp[:status]} | Prize fund: #{comp[:prize_fund]}"
    puts "-" * 40 
  end
end

def find_by_title(collection, query)
  collection.select do |id, comp|
    comp[:title].downcase.include?(query.downcase)
  end
end

def filter_by_sport(collection, sport)
  collection.select do |id, comp|
    comp[:sports].map(&:downcase).include?(sport.downcase)
  end
end

def filter_by_status(collection, status)
  unless STATUSES.include? status
    puts "status must be one of #{STATUSES}"
    return {}
  end
  collection.select do |id, comp|
    comp[:status] == (status)
  end
end

def save_to_json(collection, filename)
  File.write(filename, JSON.pretty_generate(collection))
  puts "Data saved in JSON file: #{filename}"
end

def load_from_json(filename)
  file_content = File.read(filename)
  raw_data = JSON.parse(file_content, symbolize_names: true)

  parsed_collection = {}
  raw_data.each do |str_key, data|
    parsed_collection[str_key.to_s.to_i] = data
  end

  puts "Data loaded successfully"
  parsed_collection
rescue Errno::ENOENT
  puts "Error: File #{filename} not found. Created new empty collection"
  {}
rescue JSON::ParserError => e
  puts "Error: #{e.message}"
  {}
end

def save_to_yaml(collection, filename)
  File.write(filename, YAML.dump(collection))
  puts "Data saved in YAML file: #{filename}"
end

def load_from_yaml(filename)
  raw_data = YAML.load_file(filename)
  puts "Data loaded successfully"
  raw_data
rescue Errno::ENOENT
  puts "Error: File #{filename} not found. Created new empty collection"
  {}
rescue Psych::SyntaxError => e
  puts "Error: #{e.message}"
  {}
end