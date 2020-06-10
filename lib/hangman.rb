require_relative "player.rb"
require_relative "display.rb"
require_relative "secret_word.rb"
require "pry"
require "yaml"

class Hangman
  attr_accessor :word, :guesses_left, :player_guess, :display, :misses

  def initialize(player_guess = Player.new().guess,
                 word = SecretWord.new().word,
                 display = Display.new().blank_slate(word),
                 guesses_left = 6,
                 misses = [])
    @player_guess = player_guess
    @word = word
    @display = display
    @guesses_left = guesses_left
    @misses = misses
  end

  def to_yaml
    YAML.dump ({
      :word => @word,
      :guesses_left => @guesses_left,
      :player_guess => @player_guess,
      :display => @display,
      :misses => @misses,
    })
  end

  def from_yaml(string)
    data = YAML.load(string)
    @player_guess = data[:player_guess]
    @word = data[:word]
    @display = data[:display]
    @guesses_left = data[:guesses_left]
    @misses = data[:misses]
  end

  def display_tries_and_misses()
    puts "\nTries left: #{@guesses_left}"
    puts "Misses: #{@misses.join(", ")}"
  end

  def reload_display()
    puts `clear`
    puts "Type in: 'Save' -  Save and exit
         'Load' -  Load a previously saved game
         'Exit' -  Exit the current game\n\n"
    puts @display
  end

  def guess_or_save()

    #Ask player for guess, save or exit
    puts "\nGuess a letter in the secret word!\n"

    while @player_guess = gets.chomp.upcase # loop while getting user input
      case @player_guess
      when "SAVE"
        puts "Your game has been saved!"
        @player_guess = ""
        create_user_yml(self)
        exit
      when "EXIT"
        exit
      when "LOAD"
        Hangman.new(from_yaml(File.read("saves/saved_game.yml")))
        reload_display
        break
      when /^[A-Z]$/
        break
      else
        puts "Please enter a valid input"
        print "> " # print the prompt, so the user knows to re-enter input
      end
    end
  end

  def correct_guess?()
    @word.include?(@player_guess)
  end

  def update_display()
    display_array = @display.split(" ")
    @word.split(//).each_with_index do |char, idx|
      if char == @player_guess
        display_array[idx] = @player_guess
      end
    end
    @display = display_array.join(" ")
  end

  def victory?
    @word == @display.gsub(/\s+/, "")
  end

  def play_round()
    display_tries_and_misses()
    guess_or_save()
    if correct_guess?() && @display.split(" ").include?(@player_guess)
      @guesses_left -= 1
    elsif correct_guess?()
      update_display()
    else
      @misses.push(@player_guess)
      @misses = @misses.uniq
      @guesses_left -= 1
    end
  end

  def create_user_yml(obj)
    Dir.mkdir("saves") unless Dir.exist?("saves")
    File.open("saves/saved_game.yml", "w+") { |file| file.write(obj.to_yaml) }
  end

  def play_game()
    until victory? || (@guesses_left == 0)
      reload_display()
      play_round()
    end
    reload_display
    if victory?
      puts "\nYou won!"
    else
      puts "You lost!\nThe secret word was #{@word}"
    end
  end
end

puts`clear`
puts "Welcome to Hangman! Press 'S' to start a new game. Press enter to exit."
gets.chomp.upcase == "S" ? Hangman.new().play_game() : exit

