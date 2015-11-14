def button_presses(sms)
  buttons = {'1' => ['1'],                     '2' => ['A', 'B', 'C', '2'], '3' => ['D', 'E', 'F', '3'],
             '4' => ['G', 'H', 'I', '4'],      '5' => ['J', 'K', 'L', '5'], '6' => ['M', 'N', 'O', '6'],
             '7' => ['P', 'Q', 'R', 'S', '7'], '8' => ['T', 'U', 'V', '8'], '9' => ['W', 'X', 'Y', 'Z', '9'],
             '*' => ['*'],                     '0' => [' ', '0'],           '#' => ['#'],}
  number_of_presses = 0
  sms.upcase.each_char do |symbol|
    if buttons.has_key?(symbol)
      number_of_presses += buttons[symbol].index(symbol) + 1
    else
      buttons.each_value do |symbols|
        if symbols.include?(symbol)
          number_of_presses += symbols.index(symbol) + 1
        end
      end
    end
  end

  number_of_presses
end
