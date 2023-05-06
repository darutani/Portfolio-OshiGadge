require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:user) { create(:user) }

  describe '#user_avatar_image_tag' do
    context 'when user has an attached avatar' do
      before do
        file_path = Rails.root.join('spec', 'support', 'assets', 'test_avatar.png')
        user.avatar.attach(io: File.open(file_path), filename: 'test_avatar.png', content_type: 'image/png')
      end

      it 'renders the attached avatar image' do
        image = helper.user_avatar_image_tag(user, alt: 'User Avatar')
        expect(image).to include('test_avatar.png')
      end
    end

    context 'when user does not have an attached avatar' do
      it 'renders the default avatar image' do
        image = helper.user_avatar_image_tag(user, alt: 'Default Avatar')
        expect(image).to include('default_icon_image')
      end
    end
  end
end
