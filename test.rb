class Base
  def Base.answer() 42 end
end

class Derived < Base
  def Derived.say_answer
    answer         # => 42
    Base.answer    # => 42
  end
end

Derived.answer     # => 42
Base.answer        # => 42

Derived.say_answer
