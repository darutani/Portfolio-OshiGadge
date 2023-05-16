require 'rails_helper'

RSpec.describe 'header', type: :system do
  let!(:user) { create(:user) }

  context "ログイン前" do
    before do
      visit gadgets_path
    end

    context "画面幅が992px以上の場合", js: true do
      before do
        Capybara.current_session.driver.browser.manage.window.resize_to(1000, 800)
      end

      it 'ヘッダーのロゴをクリックするとトップページへ遷移する' do
        within('header') do
          find('.navbar-brand').click
          expect(current_path).to eq root_path
        end
      end

      it 'ヘッダーに"新着投稿一覧"、"ユーザー一覧"、"新規登録"、"ログイン"、"お問い合わせ"のリンクが表示されている' do
        within('header') do
          expect(page).to have_link '新着投稿一覧', href: gadgets_path
          expect(page).to have_link 'ユーザー一覧', href: users_path
          expect(page).to have_link '新規登録', href: new_user_registration_path
          expect(page).to have_link 'ログイン', href: new_user_session_path
          expect(page).to have_link 'お問い合わせ', href: contact_path
        end
      end

      it 'ドロップダウンメニューが表示されていない' do
        within('header') do
          expect(page).not_to have_selector('.dropdownMenuButton')
        end
      end

    end

    context "画面幅が991px以下の場合", js: true do
      before do
        Capybara.current_session.driver.browser.manage.window.resize_to(500, 800)
      end

      it 'ドロップダウンメニューが表示されており、クリックするとメニューが展開する' do
        find('#dropdownMenuButton').click
        within('.dropdown-menu') do
          expect(page).to have_link('新規登録', href: new_user_registration_path)
          expect(page).to have_link('ログイン', href: new_user_session_path)
          expect(page).to have_link('ユーザー一覧', href: users_path)
          expect(page).to have_link('新着投稿一覧', href: gadgets_path)
          expect(page).to have_link('お問い合わせ', href: contact_path)
        end
      end
    end
  end

  context "ログイン後" do
    before do
      sign_in user
      visit gadgets_path
    end

    it 'ログインユーザーのアイコン画像が表示されている' do
      expect(page).to have_selector('.avatar-wrapper')
    end

    it 'ドロップダウンメニューを正しいパスで表示する' do
      click_on class: 'avatar-link'

      expect(page).to have_link('マイページ', href: mygadgets_user_path(user))
      expect(page).to have_link('ガジェット登録', href: new_gadget_path)
      expect(page).to have_link('ユーザー一覧', href: users_path)
      expect(page).to have_link('新着投稿一覧', href: gadgets_path)
      expect(page).to have_link('アカウント情報', href: account_user_path(user))
      expect(page).to have_link('ログアウト', href: destroy_user_session_path)
      expect(page).to have_link('お問い合わせ', href: contact_path)
    end
  end
end
