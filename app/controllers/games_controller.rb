require "open-uri"
require "json"

class GamesController < ApplicationController
  

  def new
    @letters = (0..9).map { ('A'..'Z').to_a.sample }
  end

  def score
    session[:total_score] ||= 0
    @answer = params[:answer].upcase
    @letters = params[:letters].split(" ")
    @word_found = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@answer}").read)["found"]
    if @answer.chars.sort !=  @answer.chars.select { |letter| @letters.include?(letter) }.sort
      @strong = @answer
      @result_start = "Sorry, but "
      @result_end = " can't be build of #{@letters.join(', ')}"
    elsif !@word_found
      @strong = @answer
      @result_start = "Sorry, but "
      @result_end = " does not seem to be a valid English word..."
    else
      @strong = "Congratulations!"
      @result_end = " #{@answer} is a valid English word!"
      session[:total_score] += @answer.length
    end

  end
end
