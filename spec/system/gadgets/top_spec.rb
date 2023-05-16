require 'rails_helper'

RSpec.describe 'gadgets#top', type: :system do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:gadget) { create(:gadget, user: user) }

  context "ログイン前" do
    before do
      visit root_path
    end

    it 'いいねアイコンをクリックするとログイン画面へ遷移する' do
      within("#likes-#{gadget.id}") do
        find('.like-button').click
        expect(current_path).to eq new_user_session_path
      end
    end

    it 'コメントアイコンをクリックするとログイン画面へ遷移する' do
      find('.comment-button', match: :first).click
      expect(current_path).to eq new_user_session_path
    end

    it 'ユーザー一覧の各ユーザー名の横にフォローボタンが表示されない' do
      expect(page).not_to have_selector('.following-btn')
      expect(page).not_to have_selector('.follow-btn')
    end

  end

  context "ログイン後" do
    before do
      sign_in user
      visit root_path
    end

    it 'いいねアイコンをクリックするといいねアイコンが紺色に変化しいいね数が+1される、さらにいいねアイコンをクリックするとアイコンが白色に戻りいいね数が-1される', js: true do

      within("#likes-#{gadget.id}") do
        expect(find('.like-button i')['class']).to include('far')
        expect(find('.like-button i')['class']).not_to include('fas')
        expect(find('.like-button').text.to_i).to eq 0

        find('.like-button').click
        wait_for_ajax

        expect(page).to have_css('.like-button i.fas')
        expect(find('.like-button i')['class']).to include('fas')
        expect(find('.like-button i')['class']).not_to include('far')
        expect(find('.like-button').text.to_i).to eq 1

        find('.like-button').click
        wait_for_ajax

        # find('.like-button i.far')
        expect(page).to have_css('.like-button i.far')
        expect(find('.like-button i')['class']).to include('far')
        expect(find('.like-button i')['class']).not_to include('fas')
        expect(find('.like-button').text.to_i).to eq 0
      end
    end

    it 'いいねアイコンをクリックすると、その投稿のいいねしたユーザー一覧ページにいいねしたユーザーが追加されている。再度いいねアイコンをクリックすると、その投稿のいいねしたユーザー一覧ページからいいねを解除したユーザーが削除されている', js: true do
      within("#likes-#{gadget.id}") do
        find('.like-button').click
      end
      visit liked_users_gadget_path(gadget)
      expect(page).to have_content(user.name)

      visit root_path
      within("#likes-#{gadget.id}") do
        find('.like-button').click
      end
      visit liked_users_gadget_path(gadget)
      expect(page).not_to have_content(user.name)
    end

    it 'コメントアイコンをクリックすると、コメント一覧ページへ遷移する' do
      within("#comments-#{gadget.id}") do
        find('.comment-button').click
        expect(current_path).to eq gadget_comments_path(gadget)
      end
    end

    it 'ユーザー一覧の各ユーザー名の横にフォローボタンが表示される' do
      within("#follow-form-#{user2.id}") do
        expect(page).to have_selector('.follow-btn')
      end
    end

    it 'ログインユーザー自身のユーザー名の横にはフォローボタンが表示されない' do
      within("#follow-form-#{user.id}") do
        expect(page).not_to have_selector('.follow-btn')
      end
    end

    it 'フォローボタンをクリックすると、フォローボタンがフォロー中へ変わる。再度フォローボタンをクリックすると、フォローボタンがフォローへ変わる', js: true do
      within("#follow-form-#{user2.id}") do
        expect(page).to have_selector('.follow-btn')
        click_button 'フォロー'
        expect(page).to have_selector('.following-btn')
        click_button 'フォロー中'
        expect(page).to have_selector('.follow-btn')
      end
    end

    it 'フォローボタンをクリックすると、フォローされたユーザーのフォロワー一覧ページにフォローしたユーザーが追加される', js: true do
      within("#follow-form-#{user2.id}") do
        click_button 'フォロー'
      end
      visit user_followers_path(user2)
      expect(page).to have_content(user.name)

      visit root_path
      within("#follow-form-#{user2.id}") do
        click_button 'フォロー中'
      end
      visit user_followers_path(user2)
      expect(page).not_to have_content(user.name)
    end

    it '未フォローユーザーをフォローすると、自分のフォロー一覧ページにそのユーザーが追加される', js: true do
      within("#follow-form-#{user2.id}") do
        click_button 'フォロー'
      end
      visit user_followings_path(user)
      expect(page).to have_content(user2.name)

      visit root_path
      within("#follow-form-#{user2.id}") do
        click_button 'フォロー中'
      end
      visit user_followings_path(user)
      expect(page).not_to have_content(user2.name)
    end
  end
end
