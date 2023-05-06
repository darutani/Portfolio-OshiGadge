require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe '.guest' do
    subject { User.guest }

    it 'creates a guest user with the guest email' do
      expect(subject.email).to eq 'guest@example.com'
    end

    it 'creates a guest user with a name "ゲスト"' do
      expect(subject.name).to eq 'ゲスト'
    end

    it 'creates a guest user with an avatar image' do
      expect(subject.avatar).to be_attached
    end
  end

  describe '#update_without_current_password' do
    let(:params) { { name: 'Updated Name' } }

    it 'updates the user without the current password' do
      expect(user.update_without_current_password(params)).to be_truthy
      expect(user.reload.name).to eq 'Updated Name'
    end
  end

  describe '#follow' do
    it 'follows another user' do
      expect { user.follow(other_user) }.to change { user.followings.count }.by(1)
      expect(user.followings).to include(other_user)
    end
  end

  describe '#unfollow' do
    before { user.follow(other_user) }

    it 'unfollows another user' do
      expect { user.unfollow(other_user) }.to change { user.followings.count }.by(-1)
      expect(user.followings).not_to include(other_user)
    end
  end

  describe '#following?' do
    before { user.follow(other_user) }

    it 'returns true when following another user' do
      expect(user.following?(other_user)).to be_truthy
    end

    it 'returns false when not following another user' do
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsy
    end
  end
end
