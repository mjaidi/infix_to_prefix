require 'infix_to_prefix'

describe '#infix_to_prefix' do
  it 'should work for 1 + 1' do
    expect(infix_to_prefix('1 + 1')).to eq('(+ 1 1)')
  end
  it 'should work for 2 * 5 + 1' do
    expect(infix_to_prefix('2 * 5 + 1')).to eq('(+ (* 2 5) 1)')
  end
  it 'should work for 2 * ( 5 + 1 )' do
    expect(infix_to_prefix('2 * ( 5 + 1 )')).to eq('(* 2 (+ 5 1))')
  end
  it 'should work for 3 * x + ( 9 + y ) / 4' do
    expect(infix_to_prefix('3 * x + ( 9 + y ) / 4')).to eq('(+ (* 3 x) (/ (+ 9 y) 4))')
  end
end
