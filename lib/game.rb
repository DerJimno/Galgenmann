class Game
  attr_reader :save

  def initialize
    @secret_word = pick_word
    @display = display
    @used_letters = []
    @stick = stickman.length
  end

  def pick_word
    file = File.readlines('./google-10000-english.txt', chomp: true)
    big_words = []
    file.each do |word|
      big_words << word if word.length.between? 5, 12
    end
    secret_word = big_words.sample
  end

  def answer
    answer = gets.chomp.to_s
    @save = true if answer == 'save'
    if @save == false
      until answer.count('a-zA-Z') == 1
        print 'Bad Input! try again: '
        answer = gets.chomp.to_s
        @save = true if answer == 'save'
      end
    end
    answer
  end

  def display
    display = []
    @secret_word.length.times do
      display << '_'
    end
    display
  end

  def stickman
    "  O
 /|\\
 / \\"
  end

  def game
    @save = false
    @stickman = stickman[0..@stick]
    puts "Incorrect letters: #{@wrong_letters}"
    puts '~~~~~~~~~~~~~~~'
    puts @stickman
    puts '~~~~~~~~~~~~~~~'
    p @display.join(' ')
    print 'Input one letter or type save: '
    input = answer
    @secret_word.split('').each_with_index do |letter, index|
      @display[index] = letter if letter == input.downcase
    end
    @used_letters << input.downcase if input.length == 1
    @stick -= 1 unless @secret_word.include?(input) || @wrong_letters.to_a.include?(input)
    @wrong_letters = @used_letters.uniq.reject { |w| @secret_word.split('').include? w }
  end

  def over?
    @stick == 1 || !@display.include?('_') ? true : false
  end

  def result?
    message = "Word: #{@secret_word}!"
    if !@display.include?('_')
      puts 'You win!'
      puts message
    elsif @stick == 1 && @display.include?('_')
      puts 'You lose!'
      puts message
    end
  end

  def play
    game
    result?
  end
end