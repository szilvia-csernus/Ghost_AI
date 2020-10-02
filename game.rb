require "set"
require_relative "player.rb"
require_relative "AI_player.rb"

class Game

    attr_accessor :fragment

    LETTERS = Set.new("a".."z")
    words = File.readlines("dictionary.txt").map(&:chomp)
    @@dict = Set.new(words)

    def self.dictionary     #Cleansing the dictionary from elements which start with an other element.
        dictionary = []
        dict_array = @@dict.to_a
        dict_array.inject do |prev_ele, next_ele|
            if next_ele.start_with?(prev_ele)
                prev_ele
            else
                dictionary << prev_ele
                next_ele
            end
        end
        dictionary.to_set
    end

    def self.LETTERS
        LETTERS
    end

    def self.input_invalid?(input)
        return true unless LETTERS.include?(input)
        false
    end

    def self.trial_invalid?(trial)
        Game.dictionary.none? { |word| word.start_with?(trial)}
    end

    def self.guess_invalid?(input, trial)
        return true if (Game.input_invalid?(input) || Game.trial_invalid?(trial))
        false
    end
   

    def initialize(lives_count, *players)
        
        @fragment = ""
        @players = players.map { |name| Player.new(name, lives_count)}
        @players << AIPlayer.new(lives_count)
        @current_player = @players[0]
        @previous_player = nil
        @remaining_players = @players.clone

    end

    def welcome
        puts "Welcome to the GHOST Game!"
        puts "----------------------"
        puts "Players:"
        @players.each {|player| puts player.name}
        puts "----------------------"
    end

    def display_lives
        puts "Remaining lives:"
        @players.each do |player| 
            puts "#{player.name}: #{player.lives}"
        end
        puts "----------------------"
    end

    def run
        system("clear")
        welcome
        play_round until game_over?
        puts "#{winner.name} has won the game!"
        puts "----------------------"
    end

    def game_over?
        @players.one? { |player| player.lives > 0}
    end

    def winner
        winner_arr = @players.select { |player| player.lives > 0}
        winner = winner_arr[0]
    end

    def play_turn
        input, trial = "", ""
        puts "It's #{@current_player.name}'s turn.'"
        puts "Current word fragment: #{@fragment}"
        puts "Write a letter:"
        
        @fragment = @current_player.player_input(@fragment, @remaining_players.length)
        puts "----------------------"
    end

    def play_round
        until word_found?
            play_turn
            take_turn
        end
        puts "'#{@fragment}' is a word! #{@previous_player.name} lost a life!"
        puts "----------------------"
        @previous_player.lives -= 1
        @remaining_players.delete(@previous_player) if @previous_player.lives == 0
        @fragment = ""
        display_lives
    end 


    

    def word_found?
        @@dict.include?(@fragment)
    end

    def take_turn
        @remaining_players.rotate!
        @previous_player = @current_player
        @current_player = @remaining_players[0]
    end



end

if __FILE__ == $PROGRAM_NAME
    game = Game.new(2, "Tony", "Barry", "Chris")

    game.run
end

        