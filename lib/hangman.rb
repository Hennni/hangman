require 'yaml'

class PlayGame
  @@hangman_states = {
    1 => [" ", "_", "_", " ", "\n", " ", " ", " ", "|", "\n", " ", " ", " ", "|", "\n", " ", " ", " ", "|", "\n", "_", "_", "_", "|", "\n",],
    2 => [" ", "_", "_", " ", "\n", " ", "O", " ", "|", "\n", " ", " ", " ", "|", "\n", " ", " ", " ", "|", "\n", "_", "_", "_", "|", "\n",],
    3 => [" ", "_", "_", " ", "\n", " ", "O", " ", "|", "\n", " ", "|", " ", "|", "\n", " ", " ", " ", "|", "\n", "_", "_", "_", "|", "\n",],
    4 => [" ", "_", "_", " ", "\n", " ", "O", " ", "|", "\n", "-", "|", " ", "|", "\n", " ", " ", " ", "|", "\n", "_", "_", "_", "|", "\n",],
    5 => [" ", "_", "_", " ", "\n", " ", "O", " ", "|", "\n", "-", "|", "-", "|", "\n", " ", " ", " ", "|", "\n", "_", "_", "_", "|", "\n",],
    6 => [" ", "_", "_", " ", "\n", " ", "O", " ", "|", "\n", "-", "|", "-", "|", "\n", " ", "/", " ", "|", "\n", "_", "_", "_", "|", "\n",],
    7 => [" ", "_", "_", " ", "\n", " ", "O", " ", "|", "\n", "-", "|", "-", "|", "\n", " ", "/", "\\", "|", "\n", "_", "_", "_", "|", "\n",]
  }

  def start
    hangman_file = File.open "5desk.txt"
    @hangman_words = hangman_file.readlines.map(&:chomp)
    hangman_file.close
    select_word(@hangman_words)
    game_loop
  end

  def select_word(word_arr)
    @@selected_word = word_arr[rand(0..word_arr.length)]
    if @@selected_word.length < 5 || @@selected_word.length > 12
      @@selected_word = word_arr[rand(0..word_arr.length)]
    else
      @@selected_word
    end
  end

  def game_loop
    @@guesses = 1
    @@guess_word_arr = ["_"] * @@selected_word.length
    @@used_words = []
    if File.exists?("./hangman_save.yml")
      puts "Would you like to load your previous save? (y, n)" 
      @load_selection = gets.chomp.downcase
      load_game(@load_selection)
    end
    until @@guesses == 7
      print @@hangman_states[@@guesses].join()
      print "Used words: " + @@used_words.join() + "\n"
      print @@guess_word_arr.join() + "\n"
      puts "Would you like to save your game? (y, n)"
      @save_selection = gets.chomp.downcase
      saving?(@save_selection)
      puts "Please take a guess"
      @player_selection = gets.chomp.downcase
      hangman_check(@player_selection)
      if endgame_check?
        puts @@selected_word
        puts "You win!!"
        break
      end
    end
    puts "You lose! The word was #{@@selected_word}" if @@guesses == 7
  end

  def hangman_check(letter)
    letter = letter[0] if letter.length > 1
    @@guess_word_arr[0] = letter.capitalize if @@selected_word[0] == letter.capitalize
    if @@used_words.include?(letter)
      puts "Oops already tried that letter"
    elsif @@selected_word.include?(letter)
      @@used_words.push(letter)
      @@selected_word.split('').each_index do |x|
        @@guess_word_arr[x] = letter if @@selected_word[x] == letter
      end
    else
      @@used_words.push(letter)
      @@guesses += 1
    end
  end

  def endgame_check?
    if @@selected_word == @@guess_word_arr.join()
      return true
    else
      return false
    end
  end

  def saving?(choice)
    if choice == "y"
      File.open("./hangman_save.yml", 'w') { |f| YAML.dump([@@selected_word, @@guesses, @@used_words, @@guess_word_arr], f) }
      exit
    end
  end

  def load_game(choice)
    if choice == 'y'
      yaml = YAML.load_file('./hangman_save.yml')
      @@selected_word = yaml[0]
      @@guesses = yaml[1]
      @@used_words = yaml[2]
      @@guess_word_arr = yaml[3]
      File.delete('./hangman_save.yml')
    end
  end

end

new_game = PlayGame.new

new_game.start