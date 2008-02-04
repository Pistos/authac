require 'spec/helper'
require 'hash'

describe 'Hash#recursive_merge!' do
  before do
  end
  
  it 'should merge single-level hashes' do
    h1 = { :a => 1 }
    h2 = { :b => 2 }
    h1.recursive_merge! h2
    h1.should.equal( {
      :a => 1, :b => 2
    } )
    
    h1 = { :a => 1 }
    h2 = { }
    h1.recursive_merge! h2
    h1.should.equal( {
      :a => 1, 
    } )
    
  end
  
  it 'should overwrite using the operand hash' do
    h1 = { :a => 1 }
    h2 = { :a => 2 }
    h1.recursive_merge! h2
    h1.should.equal( {
      :a => 2,
    } )
  end
  
  it 'should merge the second level of depth' do
    h1 = {
      :a => 1,
      :b => {
        :c => 3,
        :d => 4,
      },
    }
    h2 = {
      :b => {
        :c => 5,
      },
    }
    h1.recursive_merge! h2
    h1.should.equal( {
      :a => 1,
      :b => {
        :c => 5,
        :d => 4,
      },
    } )
  end
  
  it 'should merge the third level of depth' do
    h1 = {
      :a => 1,
      :b => {
        :c => 3,
        :d => {
          :e => 5,
        },
      },
    }
    h2 = {
      :b => {
        :d => {
          :e => 7,
        },
      },
    }
    h1.recursive_merge! h2
    h1.should.equal( {
      :a => 1,
      :b => {
        :c => 3,
        :d => {
          :e => 7,
        },
      },
    } )
  end
end