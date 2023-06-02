// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "../stylesheets/application.scss";
import 'bootstrap/dist/js/bootstrap.bundle';

// Rspecテストのエラー回避として、jQueryを使うために追記
import $ from 'jquery';
global.$ = global.jQuery = $;


Rails.start()
Turbolinks.start()
ActiveStorage.start()



// コメント一覧ページにてガジェット詳細を開く・閉じる
document.addEventListener('DOMContentLoaded', () => {
  const collapseButton = document.querySelector('[data-bs-toggle="collapse"]');

  if (collapseButton) {
    const collapseText = collapseButton.querySelector('.collapse-text');

    collapseButton.addEventListener('click', () => {
      if (collapseButton.getAttribute('aria-expanded') === 'true') {
        console.log('開く');
        collapseText.textContent = '▼ ガジェット詳細を閉じる';
      } else {
        console.log('閉じる');
        collapseText.textContent = '▲ ガジェット詳細を見る';
      }
    });
  }
});


// コメント入力欄が未入力の場合送信ボタンを無効化
function onCommentInputChange() {
  const commentInput = document.getElementById('comment-input');
  const submitButton = document.getElementById('submit-button');

  if (!commentInput || !submitButton) {
    return;
  }

  if (commentInput.value.trim() === '') {
    submitButton.disabled = true;
  } else {
    submitButton.disabled = false;
  }
}

function initializeCommentFormValidation() {
  const commentInput = document.getElementById('comment-input');

  if (!commentInput) {
    return;
  }

  onCommentInputChange();
  commentInput.addEventListener('input', onCommentInputChange);
}

document.addEventListener('DOMContentLoaded', initializeCommentFormValidation);
document.addEventListener('turbolinks:load', initializeCommentFormValidation);


// 検索結果ページにて検索対象タブ（投稿orユーザー）を保存しておくために、検索モデルをhidden_fieldにセット
$(document).on('turbolinks:load', function() {
  $('#gadget-link, #user-link, #category-link').on('click', function(e) {
    var model;
    switch ($(this).attr('id')) {
      case 'gadget-link':
        model = 'gadgets';
        break;
      case 'user-link':
        model = 'users';
        break;
      case 'category-link':
        model = 'categories';
        break;
    }
    $('#hidden-model').val(model);
  });
});

// 楽天URL検索ページのモーダルウィンドウ
$(document).on('turbolinks:load', function() {
  // ”楽天のリンクを追加する”ボタンをクリックしたときの処理
  $(document).on('click', '#rakuten-link-button', function(e) {
    e.preventDefault();

    // モーダルウィンドウを表示
    $('#rakuten-modal').modal('show');
  });
});

  // モーダルウィンドウ内の"追加"ボタンがクリックされたときの処理
$(document).on('click', '.rakuten-add-button', function(e) {
  e.preventDefault();

  // data-url 属性から楽天URLを取得
  var selectedRakutenUrl = $(this).data('url');

  // hidden_field に選択した楽天URLを設定
  $('#gadget_rakuten_url').val(selectedRakutenUrl);

  // "選択された楽天リンク"表示部分にURLを表示
  $('#rakuten_url_text').text(selectedRakutenUrl);

  // 削除ボタンを表示
  $('#remove_rakuten_url_button').show();

  // 選択されたURLをLocalStorageに保存
  localStorage.setItem('selectedRakutenUrl', selectedRakutenUrl);

  // モーダルウィンドウを閉じる
  $('#rakuten-modal').modal('hide');
});

  // 削除ボタンをクリックした時の処理
$(document).on('click', '#remove_rakuten_url_button', function(e) {
  e.preventDefault();

  // "選択された楽天リンク"表示部分を "なし" に戻す
  $('#rakuten_url_text').text('なし');

  // hidden_field の値も空にする
  $('#gadget_rakuten_url').val('');

  // localStorageの値も削除する
  localStorage.removeItem('selectedRakutenUrl');

  // 削除ボタンを非表示にする
  $(this).hide();
});
