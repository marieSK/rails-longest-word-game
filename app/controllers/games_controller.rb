require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    charset = Array('A'..'Z')
    @letters = Array.new(10) { charset.sample }
  end

  def score
    word = params[:word].upcase
    grid = params[:grid].split(',')
    validate(word, grid)
  end

  def validate(word, grid)
    attempt_array = word.chars
    valid_grid = attempt_array.all? { |letter| attempt_array.count(letter) <= grid.count(letter) }
    if valid_grid
      valid_english = english?(word)
      if valid_english
        @result = "Congratulations! #{word} is a valid English word!"
      else
        @result = "Sorry but #{word} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{word} can't be built out of #{grid.join(', ')}"
    end
    @result
  end

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    answer_serialized = URI.open(url).read
    answer = JSON.parse(answer_serialized)
    answer['found']
  end
end
