require "byebug"
require_relative "game.rb"

require "set"

class Set

    def sample
        new_arr = self.map {|ele| ele}
        sample = new_arr.sample
    end
end

class AIPlayer

    attr_reader :name
    attr_accessor :lives

    def initialize(lives_count)
        @name = "AI Player"
        @lives = lives_count
    end

    def player_input(fragment, nr_players)
        # This is for speeding up the choosing of letter if AI is the first one.
        if fragment == ""
            fragment += Game.LETTERS.sample 
            puts fragment    
            return fragment
        end
        
        potential_g = potential_guesses(fragment, nr_players)
        good_g = good_guesses(fragment, nr_players)
        winning_g = winning_guesses(fragment, nr_players)
        if winning_g.length > 0
            guess = winning_g.sample
        elsif good_g.length > 0
            guess = good_g.sample
        else
            guess = potential_g.keys.sample
        end
        puts guess[fragment.length]
        fragment += guess[fragment.length]
        
    end

    def potential_guesses(fragment, nr_players)
        selected = Game.dictionary.select { |word| word.start_with?(fragment)}
        potential_g = {}
        selected.map { |word| potential_g[word] = word.length - fragment.length}
        potential_g
    end

    def wrong_guesses(fragment, nr_players)
        potential_g = potential_guesses(fragment, nr_players)
        wrong_round_nr = nr_players + 1
        wrong_guess_lengths = [1, wrong_round_nr, wrong_round_nr * 2, wrong_round_nr * 3, wrong_round_nr * 4]
        
        wrong_g = {}
        wrong_guess_lengths.each do |length|
            potential_g.each do |key, value| 
                wrong_g[key] = value if length == value
            end
        end
        
        wrong_g.keys
    end

    def good_guesses(fragment, nr_players)
        
        potential_g = potential_guesses(fragment, nr_players).keys
        wrong_g = wrong_guesses(fragment, nr_players)

        good_g = potential_g.reject { |pot_word| wrong_g.include?(pot_word)}
        
        good_g.reject! do |word|
            wrong_g.any? { |wrong_word| word.start_with?(wrong_word)}
        end
        good_g
    end

    def winning_guesses(fragment, nr_players)

        good_g = good_guesses(fragment, nr_players)
        winning_g_max_length = fragment.length + nr_players
        winning_g = good_g.reject { |word| word.length > winning_g_max_length}
        winning_g
    end

end
