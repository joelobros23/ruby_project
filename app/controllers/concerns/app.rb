require 'json'

# Module for reusable methods
module FileManager
  FILE_PATH = "users.json"

  def load_data
    if File.exist?(FILE_PATH)
      JSON.parse(File.read(FILE_PATH))
    else
      []
    end
  rescue JSON::ParserError
    puts "Error parsing JSON. Resetting file."
    []
  end

  def save_data(data)
    File.write(FILE_PATH, JSON.pretty_generate(data))
  end
end

# User class
class User
  attr_accessor :id, :name, :email

  def initialize(id:, name:, email:)
    @id = id
    @name = name
    @email = email
  end

  def to_hash
    { id: @id, name: @name, email: email }
  end
end

# Main App class
class UserApp
  include FileManager

  def initialize
    @users = load_data
  end

  def run
    loop do
      puts "\n--- User Management ---"
      puts "1. Add User"
      puts "2. List Users"
      puts "3. Delete User"
      puts "4. Exit"
      print "Choose option: "

      case gets.chomp
      when "1"
        add_user
      when "2"
        list_users
      when "3"
        delete_user
      when "4"
        save_data(@users)
        puts "Goodbye!"
        break
      else
        puts "Invalid option."
      end
    end
  end

  private

  def add_user
    print "Enter name: "
    name = gets.chomp

    print "Enter email: "
    email = gets.chomp

    id = (@users.map { |u| u["id"] }.max || 0) + 1

    user = User.new(id: id, name: name, email: email)
    @users << user.to_hash

    puts "User added!"
  end

  def list_users
    if @users.empty?
      puts "No users found."
      return
    end

    puts "\n--- Users ---"
    @users.each do |u|
      puts "ID: #{u["id"]}, Name: #{u["name"]}, Email: #{u["email"]}"
    end
  end

  def delete_user
    print "Enter user ID to delete: "
    id = gets.chomp.to_i

    before_count = @users.length
    @users.reject! { |u| u["id"] == id }

    if @users.length < before_count
      puts "User deleted."
    else
      puts "User not found."
    end
  end
end

# Run the app
app = UserApp.new
app.run