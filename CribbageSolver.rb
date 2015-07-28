class Perm

	def initialize(card_vals)
		@vals = card_vals
	end

end

print "Cribbage Solver\n"


$magic_sum = 15
$perms = []

# cards are in the index of their face value, no cards in the 0 index
full_deck = [0,4,4,4,4,4,4,4,4,4,4,4,4,4]

hand = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
hand[0] = 0 #dummy spot. No such card
hand[1] = 0 #ace
hand[2] = 0 #two
hand[3] = 0 #three
hand[4] = 0 #four
hand[5] = 0 #five
hand[6] = 0 #six
hand[7] = 0 #seven
hand[8] = 0 #eight
hand[9] = 0 #nine
hand[10] = 0 #ten
hand[11] = 0 #jack
hand[12] = 0 #queen
hand[13] = 0 #king

# calculate the full deck, remove this to do individual hands
hand = full_deck

def countPairs hand
	points = 0;
	for i in 1..hand.size-1
		if hand[i] > 1
			points += hand[i] * hand[i] - hand[i]
		end
	end
	return points
end

def countRuns hand
	points = 0
	mult = 1
	run_len = 0
	for i in 0..hand.size
		if i < hand.size and hand[i] > 0
			run_len+=1
			mult*=hand[i]
		else
			if run_len > 2
				points += run_len * mult
			end
			mult = 1
			run_len = 0
		end
	end
	return points
end


def permute cards_left, curr_perm, big_val
    sum = 0
    for i in 0..curr_perm.size-1
    	sum += curr_perm[i] * i;
    end
    if (sum == $magic_sum)
		$perms << curr_perm
	elsif sum > $magic_sum
		return
    else
    	for i in big_val.downto(0)
    		if cards_left[i] > 0
    			next_perm = curr_perm.clone
    			next_perm[i] = next_perm[i] + 1
    			next_cards_left = cards_left.clone
    			next_cards_left[i] = next_cards_left[i] - 1
    			permute next_cards_left, next_perm, i
    		end
    	end
    end	
end

def count15 permutations, hand
	total_alts = 0;
	for perm in permutations
		total_alts += alternates perm, hand
	end
	# each 15 is worth 2 points
	return total_alts * 2
end

def alternates perm, hand
	alts = 1
	for i in 0..perm.size-1
		if i > 0
			alts *= factorial(hand[i]) / (factorial(perm[i]) * factorial(hand[i] - perm[i]))
		end
	end
	#print "alts for #{perm} are #{alts}\n"
	return alts
end

def factorial val
	if val > 0
		return (1..val).inject(:*)
	end
	return 1
	
end

def convert_card_values cards_hand
	values = cards_hand.clone
	values[10] += values [11]
	values[10] += values [12]
	values[10] += values [13]
	values[11] = 0
	values[12] = 0
	values[13] = 0
	return values
end

# 4 of a kinds first
pairs = countPairs hand

# plus the runs
runs = countRuns hand

card_values = convert_card_values hand

print "Card values #{card_values}\n"


empty_hand = [0,0,0,0,0,0,0,0,0,0,0]
permute card_values, empty_hand, card_values.size-1

fifteens = count15 $perms, hand

total = 0
total += fifteens
total += runs
total += pairs

print "Pair total is #{pairs}\n"
print "Run total is #{runs}\n"
print "Fifteens total is #{fifteens}\n"
print "Total is #{total}\n"


