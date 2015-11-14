class Card
  include Comparable
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other)
    (@rank <=> other.rank) <=> (@suit <=> other.suit)
  end

  def to_s
    "#{@rank.to_s.capitalize} of #{@suit.to_s.capitalize}"
  end
end

class Deck
  attr_accessor :cards

  include Enumerable

  def initialize(ranks = nil)
    @suits = [:spades, :hearts, :diamonds , :clubs]

    if ranks != nil
      @cards = []
      @ranks = ranks

      initialize_cards
    end
  end

  def initialize_cards
    @suits.reverse.each do |suit|
      @ranks.each do |rank|
        @cards << Card.new(rank, suit)
      end
    end
  end

  def size
    @cards.length
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards[0]
  end

  def bottom_card
    @cards[-1]
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort_by! { |card| @ranks.reverse.index(card.rank) }
    @cards.sort_by! { |card| @suits.index(card.suit) }
  end

  def each(&block)
    @cards.each &block
  end

  def to_s
    string = ""
    @cards.each { |card| string = "#{string}\n#{card.to_s}"}
    string
  end
end

class Hand < Deck
  attr_accessor :hand

  def initialize(size, deck)
    @cards = deck.shift(size)
    super()
  end
end

class WarDeckHand < Hand
  def initialize(size = 0, deck)
    super(size, deck)
  end

  def play_card
    @cards.shift
  end

  def allow_face_up?
    @cards.size <= 3
  end
end

class BeloteDeckHand < Hand
  def initialize(size = 0, deck)
    super(size, deck)
    @ranks = [7, 8, 9, :jack, :queen, :king, 10, :ace]
  end

  def highest_of_suit(suit)
    @cards.find_all { |card| card.suit == suit}.max_by { |card| @ranks.index(card.rank) }
  end

  def belote?
    counters = {clubs: 0, diamonds: 0, hearts: 0, spades: 0}
    @cards.find_all { |card| card.rank == :king || card.rank == :queen}
      .each{ |card| counters[card.suit] += 1}

    counters.values.any? { |count| count >= 2 }
  end

  def consecutive(n)
    self.sort
    different = @cards.group_by { |card| card.suit}.values
      .each do |cards|
        cards.slice_when do |i, j|
          @ranks.index(i.rank) + 1 != @ranks.index(j.rank)
        end
      end.any? { |parts| parts.length >= n}
  end

  def tierce?
    consecutive(3)
  end

  def quarte?
    consecutive(4)
  end

  def quint?
    consecutive(5)
  end

  def carre_of(rank)
    @cards.find_all { |card| card.rank == rank}
      .group_by {|card| card.suit}.values.length >= 4
  end

  def carre_of_jacks?
    carre_of(:jack)
  end

  def carre_of_nines?
    carre_of(9)
  end

  def carre_of_aces?
    carre_of(:ace)
  end
end

class SixtySixDeckHand < Hand
  def initialize(size = 0, deck)
    super(size, deck)
  end

  def twenty?(trump_suit)
    cards.group_by { |card| card.suit }
      .reject { |k, v| k == trump_suit}.values
      .each do |arr|
        arr.select! { |card| card.rank == :queen || card.rank == :king}
      end.any? {|arr| arr.length >= 2}
  end

  def forty?(trump_suit)
    cards.group_by { |card| card.suit }[trump_suit]
      .select! { |card| card.rank == :queen || card.rank == :king}
      .size >= 2
  end
end

class WarDeck < Deck
  def initialize(deck = nil)
    @ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    if deck == nil
      super(@ranks)
    else
      @cards = deck
      super()
    end
  end

  def deal
    WarDeckHand.new(26, @cards)
  end
end

class BeloteDeck < Deck
  def initialize(deck = nil)
    @ranks = [7, 8, 9, :jack, :queen, :king, 10, :ace]
    if deck == nil
      super(@ranks)
    else
      @cards = deck
      super()
    end
  end

  def deal
    BeloteDeckHand.new(8, @cards)
  end
end

class SixtySixDeck < Deck
  def initialize(deck = nil)
    @ranks = [9, :jack, :queen, :king, 10, :ace]
    if deck == nil
      super(@ranks)
    else
      @cards = deck
      super()
    end
  end

  def deal
    SixtySixDeckHand.new(6, @cards)
  end
end
