
Encoding.default_external = 'UTF-8'
Encoding.default_internal = 'UTF-8'

require_relative 'manager'
require_relative 'location'
require_relative 'sport'
require_relative 'team'
require_relative 'competition'

class App
  def initialize
    @manager = Manager.new
    load_initial_data
  end

  def run
    loop do
      show_menu
      choice = gets.chomp.to_i
      
      break if choice == 0
      
      execute_command(choice)
    end
  ensure
    puts "\n Auto-saving data before exit..."
    @manager.save_to_yaml("data.yaml")
  end

  private

  def load_initial_data
    if File.exist?("data.yaml")
      @manager.load_from_yaml("data.yaml")
    elsif File.exist?("data.json")
      @manager.load_from_json("data.json")
    end
  end

  def show_menu
    puts "\n--- SPORTS COMPETITIONS CATALOG MENU ---"
    puts "1. List all competitions"
    puts "2. Add new competition"
    puts "3. Edit competition"
    puts "4. Delete competition"
    puts "5. Search and filter"
    puts "6. Save to JSON"
    puts "0. Exit"
    print "Select an action: "
  end

  def execute_command(choice)
    case choice
    when 1 then @manager.list_competitions
    when 2 then create_competition_dialog
    when 3 then edit_competition_dialog
    when 4 then delete_competition_dialog
    when 5 then search_dialog
    when 6 then @manager.save_to_json("data.json")
    else puts "Invalid choice!"
    end
  end


  def create_competition_dialog
    puts "\n--- ADD NEW COMPETITION ---"
    
    print "Title: "
    title = gets.chomp

    print "City (Location): "
    city = gets.chomp
    location = Location.new(city)

    print "Start date (YYYY-MM-DD): "
    start_date = gets.chomp

    print "End date (YYYY-MM-DD): "
    end_date = gets.chomp

    print "Prize fund (e.g. 100000): "
    prize_fund = gets.chomp.to_f

    print "Status (upcoming/ongoing/completed/cancelled): "
    status = gets.chomp

    comp = Competition.new(title, location, start_date, end_date, prize_fund, status)

    print "Sports (comma-separated, e.g., Football, Tennis) or press Enter to skip: "
    sports_input = gets.chomp
    unless sports_input.empty?
      sports_input.split(',').map(&:strip).each do |s|
        comp.add_sport(Sport.new(s))
      end
    end

    print "Teams (comma-separated, e.g., Dynamo, Shakhtar) or press Enter to skip: "
    teams_input = gets.chomp
    unless teams_input.empty?
      teams_input.split(',').map(&:strip).each do |t|
        comp.add_team(Team.new(t))
      end
    end

    @manager.add_competition(comp)
  end

  def edit_competition_dialog
    print "\nEnter ID to edit: "
    id = gets.chomp.to_i

    if @manager.collection[id].nil?
      puts "❌ Error: Competition with ID #{id} doesn't exist."
      return
    end

    new_data = {}
    puts "--- EDITING (Leave field blank to keep current value) ---"

    print "New title: "
    val = gets.chomp
    new_data[:title] = val unless val.empty?

    print "New prize fund: "
    val = gets.chomp
    new_data[:prize_fund] = val.to_f unless val.empty?

    print "New status (upcoming/ongoing/completed/cancelled): "
    val = gets.chomp
    new_data[:status] = val unless val.empty?

    print "Add sports (comma-separated): "
    val = gets.chomp
    new_data[:add_sports] = val.split(',').map { |s| Sport.new(s.strip) } unless val.empty?

    print "Remove sports by name (comma-separated): "
    val = gets.chomp
    new_data[:remove_sports] = val.split(',').map(&:strip) unless val.empty?

    print "Add teams (comma-separated): "
    val = gets.chomp
    new_data[:add_teams] = val.split(',').map { |t| Team.new(t.strip) } unless val.empty?


    print "Remove teams by name (comma-separated): "
    val = gets.chomp
    new_data[:remove_teams] = val.split(',').map(&:strip) unless val.empty?

    @manager.edit_competition(id, new_data)
  end

  def delete_competition_dialog
    print "\nEnter ID to delete: "
    id = gets.chomp.to_i
    @manager.delete_competition(id)
  end

  def search_dialog
    puts "\n--- SEARCH & FILTER ---"
    puts "1. Search by title"
    puts "2. Filter by sport"
    puts "3. Filter by status"
    print "Select option: "
    choice = gets.chomp.to_i

    print "Enter search query: "
    query = gets.chomp

    case choice
    when 1 then @manager.find_by_title(query)
    when 2 then @manager.filter_by_sport(query)
    when 3 then @manager.filter_by_status(query)
    else puts "Invalid choice!"
    end
  end

end

App.new.run