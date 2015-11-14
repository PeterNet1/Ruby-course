def convert_to_bgn(currency_amount, currency_name)
  currency_to_bgn_rate = {bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415}

  bgn_amount = currency_amount * currency_to_bgn_rate[currency_name]

  bgn_amount.round(2)
end

def compare_prices(amount_1, currency_1, amount_2, currency_2)
  convert_to_bgn(amount_1, currency_1) - convert_to_bgn(amount_2, currency_2)
end
