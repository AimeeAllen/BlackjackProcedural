# Program for Week 1 assignment
# A procedurally coded Blackjack game
# Notes for later improvements- gambling options, ask to double down before hitting
#                               option to surrender - give up turn - lose half bet, after seeing dealers one card (can't do after hitting or seeing dealers full hand)

face = ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King']
suit = ['Hearts', 'Diamonds', 'Clubs', 'Spades']

deck = face.product(suit)

def deal(cards, deck, i)
  cards.push deck[i]
  i = i + 1
  return [cards, i]
end

def deal_hand(player_cards, dealer_cards, deck_current, i)
  2.times {
    player_cards, i = deal(player_cards, deck_current, i)
    dealer_cards, i = deal(dealer_cards, deck_current, i)
    }
  return [player_cards, dealer_cards, i]
end

def hand_value(cards)
  j = 0
  sum = 0
  num_aces = 0
  while j < cards.size
    if (cards[j][0] == 'Jack') || (cards[j][0] == 'Queen') || (cards[j][0] == 'King')
      sum = sum + 10
    elsif cards[j][0] == cards[j][0].to_i # this is only true for number cards
      sum = sum + cards[j][0]
    elsif
      num_aces = num_aces + 1
      sum = sum + 1
    end     
    j = j + 1
  end
  if (num_aces != 0) && (sum <= 11) # Ace can be counted as 11 not 1
    soft_sum = sum + 10
  else
    soft_sum = sum
  end
  [sum, soft_sum]
end

def display_hand(player_cards, player_total, player_soft_total)
k = 0
puts
puts 'Your hand consists of the cards:'
while k < player_cards.size
  puts "#{player_cards[k][0]} of #{player_cards[k][1]}"
  k = k + 1
end
if player_soft_total != player_total
  if player_soft_total != 21
  puts "You have a soft hand total of #{player_soft_total}, " +
    "but only a hard total of #{player_total}."
  end
else
  puts "You have a hand total of #{player_soft_total}."
end
end

def outcome(player_total, player_soft_total, numb_cards, name)
  puts
  if player_soft_total > 21
    puts "This means you are BUST... sorry #{name} :("
  elsif player_soft_total == 21
    if numb_cards == 2
      puts "CONGRATULATIONS #{name}!!! You have BLACKJACK!"
    else
      puts "CONGRATULATIONS #{name}! Your cards total #{player_soft_total}!"
    end
  elsif player_total >= 18 # hard total >= 18 forced to stay
  elsif player_soft_total < 18
    puts 'You currently have a low hand total (less than 18).'
  end
    
  if (player_soft_total < 21) && (player_total < 18)
    puts 'Would you like to "hit" (get an extra card) or "stay" (with the total you have)?'
    while true
      answer = gets.chomp
      if (answer.downcase == 'hit') || (answer.downcase == 'stay')
        return answer.downcase
      else
        puts 'Please enter "hit" or "stay".'
      end
    end
  end
end

def deal_outcome(dealer_total, dealer_cards)
  k = 0
  puts
  puts 'The dealer\'s hand consists of the cards:'
  while k < dealer_cards.size
    puts "#{dealer_cards[k][0]} of #{dealer_cards[k][1]}"
    k = k + 1
  end
  puts "Which gives the dealer a hand total of #{dealer_total}!"
  puts

  if dealer_total > 21
  puts "Dealer is BUST!"
  elsif dealer_total == 21
    if dealer_cards.size == 2
    puts 'Dealer has BLACKJACK!'
    end
  end
end

puts
puts 'Welcome to Blackjack!'
puts 'Please enter your name:'

player_name = gets.chomp

if player_name[/\d/] != nil
   puts 'Wow your name contains numbers, so do many of the cards.'
end

puts
puts "Hi #{player_name}!"
puts
puts 'Blackjack is a very simple game.'
puts 'Both you and the dealer will be dealt 2 cards at random.'
puts 'You will get to see both your cards, and one of the dealer\'s cards to begin with.'
puts 'The aim of the game is to get your cards to add up to 21 - or as close to 21 without going over.'
puts 'Jack, Queen and King count as 10, numbers count as their value,'
puts 'and an Ace can be either 1 or 11 (whatever will give you a better score).'
puts 'Once you have two cards, if your total is too low, you get the options;'
puts '\'hit\' and get an extra card to get closer to 21, or \'stay\'.'
puts 'Once you stay, the dealer gets a turn, and then cards are compared.'
puts 'Closest to 21 (but not over 21) wins!!'
puts 'Press \'enter\' when you\'re ready to play'

gets.chomp

game_count = 0
deck_current = deck.shuffle # later adapt to multiple decks
i = 0 # start of deck

while true
player_cards = []
dealer_cards = []

player_cards, dealer_cards, i = deal_hand(player_cards, dealer_cards, deck_current, i)

#player turn
puts
puts "The dealer's first card is #{dealer_cards[0][0]} of #{dealer_cards[0][1]}."

while true
  player_total, player_soft_total = hand_value(player_cards)

  display_hand(player_cards, player_total, player_soft_total)
  hit_stay = outcome(player_total, player_soft_total, player_cards.size, player_name)

  if hit_stay == 'hit'
    player_cards, i = deal(player_cards, deck_current, i)
  else
    break
  end
end

#dealer turn
dealer_total, dealer_soft_total = hand_value(dealer_cards)

while dealer_soft_total < 17
  dealer_cards, i = deal(dealer_cards, deck_current, i)
  dealer_total, dealer_soft_total = hand_value(dealer_cards)
end

deal_outcome(dealer_soft_total, dealer_cards)

#compare hands
if (player_soft_total > 21) && (dealer_soft_total > 21)
  puts 'Both you and the dealer are BUST - no one wins.'
elsif (player_soft_total <= 21) && (dealer_soft_total > 21)
  puts "You WIN #{player_name}!!!!"
elsif (player_soft_total > 21) && (dealer_soft_total <= 21)
  puts 'Dealer wins.'
elsif player_soft_total == dealer_soft_total
  puts 'Both you and the dealer have the same card total.'
  puts 'This hand is a push (tie).'
elsif player_soft_total > dealer_soft_total
  puts "CONGRATULATIONS #{player_name} - You WIN!!!!!"
else
  puts 'Dealer wins.'
end

puts
puts "Would you like to play again #{player_name}? 'yes' or 'no'"

while true
  replay = gets.chomp
  if (replay.downcase == 'no') || (replay.downcase == 'yes') ||
    (replay.downcase == 'n') || (replay.downcase == 'y')
    break
  else
    puts 'Please enter "yes" or "no".'
  end
end
  
if (replay.downcase == 'no') || (replay.downcase == 'n')
    break
else game_count = game_count + 1
  5.times {puts}
  if game_count == 5 # when this hits 5, need to start a fresh deck
    game_count = 0 
    deck_current = deck.shuffle
    i = 0
  end
end
end