require_relative 'game'
require 'yaml'

def save_game(game)
  filename = set_name
  dump = YAML.dump(game)
  File.open("saved/#{filename}.yaml", 'w') { |file| file.write dump }
end

def set_name
  files = Dir.glob('saved/*').map { |file| file.split('/')[1].split('.')[0] }
  print 'Choose a name for your save: '
  name = gets.chomp

  while files.include? name
    print "#{name} already exists. Do you want to overwrite the file? (Yes/No): "
    answer = gets[0].downcase
    until answer == 'y' || answer == 'n'
      print 'Invalid input. Overwrite the file? (Yes/No)'
      answer = gets[0].downcase
    end
    if answer == 'y'
      name
      break
    else
      print 'Then choose another name: '
      name = gets.chomp
    end
  end
  puts 'Your game has been saved. Thanks for playing!'
  name
end

def get_name
  files = Dir.glob('saved/*').map { |file| file.split('/')[1].split('.')[0] }
  puts '~~~~files~~~~~'
  puts files
  puts '~~~~~~~~~~~~~~'
  print 'Choose your save: '
  name = gets.chomp

  until files.include? name
    print 'File not found. Input an existing file or exit (file/exit): '
    answer = gets.chomp
    answer == 'exit' ? break : name = answer
  end
  name
end

def load_game
  filename = get_name
  begin
    file = File.open("saved/#{filename}.yaml", 'r')
    loading = YAML.safe_load(file, permitted_classes: [Game])
    file.close
    puts("- #{filename} loaded...")
  rescue Errno::ENOENT
  end
  loading
end

print "Welcome to Hangman! (n)- New Game
                    (l)- Load Game
Answer: "
answer = gets[0].downcase
until answer == 'n' || answer == 'l'
  puts 'Invalid input! try again'
  print 'Answer: '
  answer = gets[0].downcase
end

begin
  game = answer == 'n' ? Game.new : load_game
  until game.over?
    game.play
    if game.save
      save_game(game)
      break
    end
  end
rescue NoMethodError
end