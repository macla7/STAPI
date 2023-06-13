require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'associations' do
    it 'belongs to many posts' do
      shift = Shift.reflect_on_association(:post)
      expect(shift.macro).to eq(:belongs_to)
    end
  end
end
