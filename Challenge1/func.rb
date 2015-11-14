def complement(f)
  ->(x) { !f.call x }
end

def compose(f, g)
  ->(x) { f.call g.call x }
end
