describe 'button_presses' do
  it 'counts the number of pressed buttons' do
    expect(button_presses('nvm')).to eq 6
  end
  it 'counts the number of pressed buttons #2' do
    expect(button_presses('WHERE DO U WANT 2 MEET L8R')).to eq 47
  end
  it 'counts the number of pressed buttons #3' do
    expect(button_presses('WHERE DO U WANT 2 MEET L8R?')).to eq 47
  end
end
