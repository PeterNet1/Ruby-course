class Card
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{@rank.to_s.capitalize} of #{@suit.capitalize}"
  end

  def ==(other)
    @suit == other.suit && @rank == other.rank
  end
end

class Deck
  include Enumerable

  attr_accessor :deck

  def get_suits
    [:spades, :hearts, :diamonds, :clubs]
  end

  def get_ranks
    [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace].reverse
  end

  def get_standard_deck
    standard_deck = []
    ranks_and_suits = get_suits.product(get_ranks)

    ranks_and_suits.each do |rank_and_suit|
      standard_deck << Card.new(rank_and_suit[1], rank_and_suit[0])
    end

    standard_deck
  end

  def initialize(deck = get_standard_deck)
    @deck = deck
  end

  def size
    @deck.size
  end

  def draw_top_card
    @deck.shift
  end

  def draw_bottom_card
    @deck.pop
  end

  def top_card
    @deck.first
  end

  def bottom_card
    @deck.last
  end

  def shuffle
    @deck.shuffle!
  end

  def sort
    @deck.sort_by! { |card| get_ranks.find_index(card.rank) }
    @deck.sort_by! { |card| get_suits.find_index(card.suit) }
  end

  def to_s
    @deck.join("\n")
  end

  def deal
    @deck.shift(deck.size)
  end

  def each
    @deck.each { |card| yield card }
  end

  private

  def get_occurring_ranks_by_suit(suit)
    occurrences = Hash.new(0)
    get_ranks.each do |rank|
      card = Card.new(rank, suit)
      if not @deck.include?(card)
          occurrences[rank] = 0
      elsif @deck[@deck.find_index(card)].rank == rank
        occurrences[rank] += 1
      end
    end

    occurrences
  end

  def highest_consecutive_by_suit(hand_by_suit)
    consecutive = 0
    max_consecutive = 0
    get_ranks.each do |rank|
      consecutive = hand_by_suit[rank] == 1 ? consecutive + 1 : 0
      max_consecutive = consecutive if consecutive > max_consecutive
    end

    max_consecutive
  end
end

class WarDeck < Deck

  private

  class WarHand < WarDeck
    def self.size
      26
    end

    def play_card
      card = @deck.sample
      @deck.delete(card)
      card
    end

    def allow_face_up?
      @deck.size <= 3
    end
  end

  public

  def deal
    WarHand.new(@deck.shift(WarHand.size))
  end
end

class BeloteDeck < Deck
  def get_ranks
    [7, 8, 9, :jack, :queen, :king, 10, :ace].reverse
  end

  private

  class BeloteHand < BeloteDeck
    def self.size
      8
    end

    def highest_of_suit(suit)
      hand_by_suit = @deck.select { |card| card.suit == suit }
      hand_by_suit.sort_by! { |card| get_ranks.find_index(card.rank) }
      hand_by_suit[0]
    end

    def belote?
      get_suits.each do |suit|
        hand_by_suit = get_occurring_ranks_by_suit(suit)
        if hand_by_suit[:king] > 0 and hand_by_suit[:queen] > 0
          return true
        end
      end
      false
    end

    def tierce?
      get_suits.each do |suit|
        hand_by_suit = get_occurring_ranks_by_suit(suit)
        if highest_consecutive_by_suit(hand_by_suit) > 2
          return true
        end
      end
      false
    end

    def quarte?
      get_suits.each do |suit|
        hand_by_suit = get_occurring_ranks_by_suit(suit)
        if highest_consecutive_by_suit(hand_by_suit) > 3
          return true
        end
      end
      false
    end

    def quint?
      get_suits.each do |suit|
        hand_by_suit = get_occurring_ranks_by_suit(suit)
        if highest_consecutive_by_suit(hand_by_suit) > 4
          return true
        end
      end
      false
    end

    def get_occurring_ranks_for_all_suits
      occurrences = Hash.new(0)
      get_suits.each do |suit|
        hand_by_suit = get_occurring_ranks_by_suit(suit)
        occurrences.merge!(hand_by_suit) { |key, first, second| first + second }
      end

      occurrences
    end

    def carre_of_jacks?
      hand = get_occurring_ranks_for_all_suits
      return true if hand[:jack] == 4
      false
    end

    def carre_of_nines?
      hand = get_occurring_ranks_for_all_suits
      return true if hand[9] == 4
      false
    end

    def carre_of_aces?
      hand = get_occurring_ranks_for_all_suits
      return true if hand[:ace] == 4
      false
    end
  end

  public

  def deal
    BeloteHand.new(@deck.shift(BeloteHand.size))
  end
end

class SixtySixDeck < Deck
  def get_ranks
    [9, :jack, :queen, :king, 10, :ace].reverse
  end

  private

  class SixtySixHand < SixtySixDeck
    def self.size
      6
    end

    def twenty?(trump_suit)
      suits = get_suits
      suits.delete(trump_suit)
      suits.each do |suit|
        hand_by_suit = get_occurring_ranks_by_suit(suit)
        if hand_by_suit[:king] > 0 and hand_by_suit[:queen] > 0
          return true
        end
      end
      false
    end

    def forty?(trump_suit)
      hand_by_suit = get_occurring_ranks_by_suit(trump_suit)
      return true if hand_by_suit[:king] > 0 and hand_by_suit[:queen] > 0
      false
    end
  end

  public

  def deal
    SixtySixHand.new(@deck.shift(SixtySixHand.size))
  end
end
