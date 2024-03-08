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
puts "Insert credit card (or press spacebar to play for free)"

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
  single_loop(0.5)
end

def score(results)
  results.uniq.sum { SLOT_SYMBOLS[_1][results.count(_1) - 1] }
end

# Wait for spacebar to be pressed
STDIN.getch

# Draw 3 random emoji for the three wheels
animation

results = 3.times.map { SLOT_SYMBOLS.keys.sample }

puts results.join(" ")


# If all three emoji are the same, print a winning message
#
final_score = score(results)

final_score > 0 ? puts("You win #{final_score}c! I'm sure you'll beat that next time!") : puts("Ah, too bad! Try again!")
