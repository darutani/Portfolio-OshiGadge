require 'rails_helper'

RSpec.describe "Gadgets", type: :system do
  let(:user) { create(:user) }
  let!(:gadget1) { create(:gadget, user: user, rakuten_url: 'http://image_url1') }
  let!(:gadget2) { create(:gadget, user: user) }

  before do
    allow(RakutenWebService::Ichiba::Item).to receive(:search).and_return(
      [
        double("RakutenItem", name: "iphone14 128GB", url: "http://test1.com", small_image_urls: ["http://image_url1"]),
        double("RakutenItem", name: "iphone14 256GB", url: "http://test2.com", small_image_urls: ["http://image_url2"]),
      ]
    )
  end

  describe "rakuten_url" do
    context "ガジェットのrakuten_urlに値が保存されている" do
      before do
        sign_in user
        visit edit_gadget_path(gadget1.id)
      end

      it "選択された楽天リンク欄にDBに保存されているrakuten_urlと削除ボタンが表示されている", js: true do
        expect(page).to have_selector("#rakuten_url_text", text: "http://image_url1")
        expect(page).to have_field('gadget_rakuten_url', with: 'http://image_url1', type: 'hidden')
        expect(page).to have_selector('#remove_rakuten_url_button')
      end

      it "選択された楽天リンク欄の削除ボタンをクリックすると、”選択された楽天リンク”欄が”なし”という表記に変わりhidden_fieldからも削除され、更新ボタンをクリックするとrakuten_urlカラムの値も削除される", js: true do
        find('#remove_rakuten_url_button').click
        expect(page).to have_selector("#rakuten_url_text", text: "なし")
        expect(page).to have_field('gadget_rakuten_url', with: "", type: 'hidden')
        click_on '更新'
        gadget1.reload
        expect(gadget1.rakuten_url).to eq ''
      end

      it "新たな楽天URLを選択し、更新ボタンをクリックすると新たに選択したURLがrakuten_urlとして保存される", js: true do
        find('#rakuten-link-button').click
        fill_in 'q', with: 'iphone14'
        click_on '検索'
        sleep 1
        all('.rakuten-add-button')[1].click
        expect(page).to have_selector("#rakuten_url_text", text: "http://test2.com")
        expect(page).to have_field('gadget_rakuten_url', with: 'http://test2.com', type: 'hidden')
        click_on '更新'
        gadget1.reload
        expect(gadget1.rakuten_url).to eq 'http://test2.com'
      end
    end

    context "ガジェットのrakuten_urlに値が保存されていない" do
      before do
        sign_in user
        visit edit_gadget_path(gadget2.id)
      end

      it "選択された楽天リンク欄に”なし”と表示されており、削除ボタンが表示されていない", js: true do
        expect(page).to have_selector("#rakuten_url_text", text: "なし")
        expect(page).to have_field('gadget_rakuten_url', with: '', type: 'hidden')
        expect(page).to have_selector('#remove_rakuten_url_button', visible: false)
      end

      it "新たな楽天URLを選択し、更新ボタンをクリックすると新たに選択したURLがrakuten_urlとして保存される", js: true do
        find('#rakuten-link-button').click
        fill_in 'q', with: 'iphone14'
        click_on '検索'
        sleep 1
        find('.rakuten-add-button', match: :first).click
        expect(page).to have_selector("#rakuten_url_text", text: "http://test1.com")
        expect(page).to have_field('gadget_rakuten_url', with: 'http://test1.com', type: 'hidden')
        click_on '更新'
        gadget2.reload
        expect(gadget2.rakuten_url).to eq 'http://test1.com'
      end
    end
  end
end
