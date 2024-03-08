require "io/console"
# Define the symbols that will be used in the slot machine
# Should include
# - cherry
# - lemon
# - money
# - grape
# - horse shoe
SLOT_SYMBOLS = {
  "🍒" => [ 10, 100, 1000 ],
  "🍋" => [ 0,  0, 1    ],
  "💰" => [ 1,  10, 2000 ],
  "🍇" => [ 0, 10, 100 ],
  "🍀" => [ 5, 50, 500 ],
  "🍊" => [ 0, 10, 100 ]
}

def single_loop(sleep_time = 0.1)
  results = 3.times.map { SLOT_SYMBOLS.keys.sample }
  print results.join(" ")
  sleep sleep_time
  print "\r"
  STDOUT.flush
end

def animation
  3.times { single_loop(0.2) }
  7.times { single_loop(0.1) }
  10.times { single_loop(0.07) }
  7.times { single_loop(0.1) }
  3.times { single_loop(0.2) }
  single_loop(0.3)
  single_loop(0.4)
end

def score(results)
  results.uniq.sum { SLOT_SYMBOLS[_1][results.count(_1) - 1] }
end

def hoops_to_jump_through_to_exit
  puts "Do you want to leave already? Please answer yes or no."
  answer = gets.chomp
  return false unless answer.downcase == "yes"

  puts "I'm afraid I can't just let you do that. You'll have to answer a trivia question first to make sure you mean it!"

  require 'net/http'
  require 'json'
  require 'cgi'

  uri = URI("https://opentdb.com/api.php?amount=1&type=multiple")
  response = Net::HTTP.get(uri)
  trivia = JSON.parse(response)['results'][0]

  puts CGI.unescapeHTML(trivia['question'])

  correct_answer = trivia['correct_answer']
  possible_answers = trivia['incorrect_answers'] << correct_answer
  possible_answers.shuffle!

  possible_answers.each_with_index do |answer, index|
    puts "#{index + 1}. #{CGI.unescapeHTML(answer)}"
  end

  selection = gets.chomp.to_i - 1

  puts "Correct answer is #{correct_answer}, index is #{possible_answers.index(correct_answer)}"
  puts "You answered #{selection + 1}"

  return selection == possible_answers.index(correct_answer)
  selection == possible_answers.index(correct_answer)
end

def main_loop
  keep_playing = true

  while(keep_playing) do
    begin
    puts "Insert credit card (or press spacebar to play for free)"
    STDIN.getch

    # Draw 3 random emoji for the three wheels
    animation

    results = 3.times.map { SLOT_SYMBOLS.keys.sample }
    puts results.join(" ")

    sleep 0.5

    final_score = score(results)
    final_score > 0 ? puts("You win #{final_score}c! I'm sure you'll beat that next time!") : puts("Ah, too bad! Try again!")
    rescue Interrupt
      puts
      puts
      keep_playing = hoops_to_jump_through_to_exit

      if keep_playing
        puts "I was hoping you'd say that! Let's play again!"
      else
        puts "Goodbye! Come back soon!"
      end
    end
  end
end

main_loop
