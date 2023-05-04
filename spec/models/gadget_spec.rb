require 'rails_helper'

RSpec.describe Gadget, type: :model do

  let(:user) { create(:user) }
  let(:gadget) { create(:gadget, user: user) }

  describe '#liked_by?' do

    context 'いいねされている時' do
      before { create(:like, user: user, gadget: gadget) }

      it 'returns true' do
        expect(gadget.liked_by?(user)).to be true
      end
    end

    context 'いいねされていない場合' do
      it 'returns false' do
        expect(gadget.liked_by?(user)).to be false
      end
    end
  end
end
