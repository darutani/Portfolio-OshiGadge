require 'rails_helper'

RSpec.describe "Gadgets", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:gadget) { create(:gadget, user: user) }
  let(:comment) { create(:comment, user: user, gadget: gadget) }

  before do
    sign_in user
    visit gadget_path(gadget)
  end

  context "ログインユーザーがガジェットの所有者の場合" do
    it "フォローボタンが表示されない" do
      expect(page).not_to have_selector('.follow-btn')
    end

    it "ガジェット編集ボタンが表示される" do
      expect(page).to have_link('編集する', href: edit_gadget_path(gadget))
    end
  end

  context "ログインユーザーがガジェットの所有者でない場合" do
    before do
      sign_out user
      sign_in other_user
      visit gadget_path(gadget)
    end

    it "フォローボタンが表示される" do
      expect(page).to have_css("#follow-form-#{user.id}")
    end

    it "編集ボタンが表示されない" do
      expect(page).not_to have_link('編集する', href: edit_gadget_path(gadget))
    end
  end

  describe "コメント" do
    before do
      comment
      visit gadget_path(gadget)
    end

    it "コメント未入力で送信してもコメントが登録（表示）されない" do
      fill_in 'comment-input', with: ''
      click_on '送信'
      expect(page).to have_content("Contentを入力してください")
      expect(page).to have_content("Contentは1文字以上で入力してください")
    end

    it "コメント削除をクリックすると、コメントが正常に削除される", js: true do
      expect(page).to have_content(comment.content)
      click_on '削除'
      page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_content(comment.content)
    end

    it "自分以外のユーザーが投稿したコメントには削除リンクが表示されない" do
      sign_out user
      sign_in other_user
      visit gadget_path(gadget)
      expect(page).not_to have_link('削除')
    end
  end
end
