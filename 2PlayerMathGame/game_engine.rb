require_relative 'player'
require_relative 'question'

class GameEngine

  class InvalidGuessError < ArgumentError
  end

  def initialize
    @players        = []
    @gameover       = false
    @gameover_text = ''
  end

  def clear_screen
    # system = evil and besides, it wont work since clearing console entails spawning a new one - a funny unexpected effect - when executed inside the loop,
    # it spawns the new console and the loop in it but forsaken anything outside of the loop - in effect creating infinite loop
    # use only when you have to, preferably if you restart the process itself
    system ("cls")
    system ("clear")
  end

  def add_player
    name = get_input
    if name.empty?
      name = "Player#{@players.count + 1}"
    end
    @players << Player.new(name)
  end

  def initialize_game(greeting, play_text, continue_text, gameover_text)
    setup_counter   = 0
    @gameover_text = gameover_text
    @continue_text  = continue_text
    clear_screen
    greeting.call
    get_input.to_i.times do
      setup_counter += 1
      clear_screen
      play_text.call("#{setup_counter}")
      add_player
    end
  end

  def true_answer
    Question.solution.to_s
  end

  def verify_answer(answer)
    raise InvalidGuessError, 'Argument is not numeric' unless answer.is_a? Numeric
    true_answer == answer ? true : false
  end

  def get_input
    gets.chomp.to_s
  end

  def loop(question_text, p_q_text1, p_q_text2, resolution_text, correct_text, incorrect_text, answer_text, score_text, p_score_text, continue_text)
    @question_text   = question_text
    @p_q_text1       = p_q_text1
    @p_q_text2       = p_q_text2
    @resolution_text = resolution_text
    @correct_text    = correct_text
    @incorrect_text  = incorrect_text
    @answer_text     = answer_text
    @score_text      = score_text
    @p_score_text    = p_score_text
    @continue_text   = continue_text
    until @gameover do
      get_question
      resolve
      judge
    end
    top_score if @gameover
    @continue_text.call
    restart = get_input
    if restart == 'y' || restart == 'yes'
      system ("ruby main.rb")
    else
      print "Good Bye!"
    end
  end

  def get_question
    question = Question.generate
    @question_text.call("#{question}")
    @players.each do |player|
      @p_q_text1.call("#{player.name} ? : ")
      player.answer = get_input
      @p_q_text2.call("#{player.name}!")
    end
  end

  def resolve
    @resolution_text.call
    @players.each do |player|
      if verify_answer(player.answer)
        @correct_text.call("#{player.name}")
        player.score += 1
      else
        @incorrect_text.call("#{player.name}")
        player.life -= 1
      end
    end
    @answer_text.call("#{true_answer}")
  end

  def judge
    @score_text.call
    @players.each do |player|
      @p_score_text.call("#{player.name}", "#{player.score}", "#{player.life}")
      @gameover = true if player.life == 0
    end
  end

  def top_score
    @top_score = 0
    @winner    = nil
    @players.each do |player|
      if player.score > @top_score
        @top_score = player.score
        @winner    = player.name
      end
      @winner = 'Nobody' if @winner == nil || @winner.empty?
    end
    @gameover_text.call("#{@winner}", "#{@top_score}")
  end
end
