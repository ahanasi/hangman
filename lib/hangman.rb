require_relative "player.rb"
require_relative "display.rb"
require_relative "secret_word.rb"
require "pry"

class Hangman
  attr_reader :word, :guesses_left, :player_guess, :word, :display, :misses

  def initialize()
    @player_guess = Player.new().guess
    @word = SecretWord.new().word
    @display = Display.new().blank_slate(@word)
    @guesses_left = 6
    @misses = []
  end

  def ask_player_for_guess()
    #Ask player for guess
    puts "\nGuess a letter in the secret word!\n"
    @player_guess = gets.chomp.upcase
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
    ask_player_for_guess()
    puts "\nYour guess: #{@player_guess}"
    if correct_guess?() && @display.split(" ").include?(@player_guess)
      puts "Uh-oh! You lose a try for repeating a previous guess."
      @guesses_left -= 1
    elsif correct_guess?()
      update_display()
    else
      puts "Wrong guess!"
      @misses.push(@player_guess)
      @misses = @misses.uniq
      @guesses_left -= 1
    end

    puts "Tries left: #{@guesses_left}"
    puts "Misses: #{@misses.join(", ")}"
  end
end

test = Hangman.new()

until test.victory? || (test.guesses_left == 0)
  puts test.display
  test.play_round
end

if test.victory?
  puts "#{test.display}\nYou won!"
else
  puts "You lost!\nThe secret word was #{test.word}"
end
