require_relative "player.rb"
require_relative "display.rb"
require_relative "secret_word.rb"
require "pry"

class Hangman
  attr_accessor :player_guess, :word, :display

  def initialize()
    @player_guess = Player.new().guess
    @word = SecretWord.new().word
    @display = Display.new().blank_slate(@word)
    @guesses_left = 6
  end

  def ask_player_for_guess()
    #Ask player for guess
    puts "Guess a letter in the secret word!"
    @player_guess = gets.chomp.upcase
  end

  def correct_guess?()
    @word.include?(@player_guess)
  end

  def update_display()
    display_array = @display.split(" ")
    @word.split(//).each_with_index do |char,idx|
      if char == @player_guess
        display_array[idx] = @player_guess
      end
    end
    @display = display_array.join(" ")
  end

  def victory?
    @word == @display.gsub(/\s+/, "")
  end

end

test = Hangman.new()
puts test.word
puts test.display
test.ask_player_for_guess


puts "Your guess: #{test.player_guess}"
puts "Was your guess correct? #{test.correct_guess?()}"

puts test.update_display
