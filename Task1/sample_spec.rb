describe '#convert_to_bgn' do
  it 'converts usd' do
    expect(convert_to_bgn(1000, :usd)).to eq 1740.8
  end

  it 'converts bgn - test pesho' do
    expect(convert_to_bgn(1000, :bgn)).to eq 1000
  end

  it 'converts eur - test pesho' do
    expect(convert_to_bgn(1000, :eur)).to eq 1955.7
  end

  it 'converts gbp - test pesho' do
    expect(convert_to_bgn(1000, :gbp)).to eq 2641.5
  end
end

describe '#compare_prices' do
  it 'compares prices of the same currency' do
    expect(compare_prices(10, :usd, 13, :usd)).to be < 0
    expect(compare_prices(10, :eur, 10, :eur)).to eq 0
    expect(compare_prices(10, :gbp, 8, :gbp)).to be > 0
  end

  it 'compares prices of different currency - test pesho' do
    expect(compare_prices(10, :usd, 13, :gbp)).to be < 0
    expect(compare_prices(10, :eur, 7.404883588869959, :gbp)).to eq 0
    expect(compare_prices(22, :bgn, 8, :gbp)).to be > 0
    expect(compare_prices(100, :usd, 100, :bgn)).to be > 0
  end

  it 'comapres prives of different currency - test qvor' do
    expect(compare_prices(10, :gbp, 13, :usd)).to be > 0
    expect(compare_prices(10, :bgn, 13, :usd)).to be < 0
    expect(compare_prices(10, :usd, 8.9, :eur)).to eq 0
  end
end
