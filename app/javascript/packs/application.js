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
// document.addEventListener('DOMContentLoaded', () => {
//   const commentInput = document.getElementById('comment-input');
//   const submitButton = document.getElementById('submit-button');

//   // コメント入力欄の内容が変更されたときに呼び出される関数
//   function onCommentInputChange() {
//     if (commentInput.value.trim() === '') {
//       submitButton.disabled = true;
//     } else {
//       submitButton.disabled = false;
//     }
//   }

//   // コメント入力欄の初期状態に基づいて、送信ボタンの無効化/有効化を設定
//   onCommentInputChange();

//   // コメント入力欄の内容が変更されたときに、送信ボタンの無効化/有効化を更新
//   commentInput.addEventListener('input', onCommentInputChange);

//   console.log("Hello")
// });


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

