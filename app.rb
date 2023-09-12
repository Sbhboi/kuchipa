require 'sinatra'

def determine_winner(player_choice, computer_choice)
    if player_choice == computer_choice
        "Draw !"
    elsif (player_choice == "Rock" && computer_choice == "Scissors") ||
          (player_choice == "Paper" && computer_choice == "Rock") ||
          (player_choice == "Scissors" && computer_choice == "Paper")
        "You Win !"
    else
        "Computer.....Win !"
    end
end

set :player_scores, {}

get '/' do
    erb :index
end

post '/play' do
    @player_name = params[:name]
    @rounds = params[:rounds].to_i
    erb :rounds
end

post '/result' do
    @player_name = params[:name]
    @player_choice = params[:choice]
    @rounds = params[:rounds].to_i
    @results = []
    @rounds.times do |round|
        @player_choice = params["choice#{round}"]
        @computer_choice = %w[Rock Paper Scissors].sample
        result = determine_winner(@player_choice, @computer_choice)
      @results << { round: round + 1, player_choice: @player_choice, computer_choice: @computer_choice, result: result }
    end

    @player_scores ||= {}
    @player_scores[@player_name] ||= 0

    @results.each do |result|
        @player_scores[@player_name] += 1 if result[:result] == 'You Win !'
    end
    
    erb :result
end

