class PlayGame
  @hangman_states = {
    0 => 
  }

  def initialize
    hangman_file = File.open "hangman/5desk.txt"
    @hangman_words = hangman_file.readlines.map(&:chomp)
    hangman_file.close
    puts select_word(@hangman_words)
  end

  def select_word(word_arr)
    selected_word = word_arr[rand(0..word_arr.length)]
    if selected_word.length < 5 || selected_word.length > 12
      selected_word = word_arr[rand(0..word_arr.length)]
    else
      selected_word
    end
  end

  def game_loop
    @@guesses = 0
    until guesses == 7
      puts current_hangman(@@guesses)
      
    end
  end

end

PlayGame.new