document.addEventListener('turbo:load', () => {
  const templateSelect = document.getElementById('template-select');

  if (!templateSelect) return;

  templateSelect.addEventListener('change', (event) => {
    const selectedOption = event.target.selectedOptions[0];

    if (!selectedOption.value) return;

    const transactionType = selectedOption.dataset.transactionType;
    const amount = selectedOption.dataset.amount;
    const subCategoryId = selectedOption.dataset.subCategoryId;
    const memo = selectedOption.dataset.memo;

    // 種別
    const transactionTypeSelect = document.querySelector(
      '#transaction_transaction_type'
    );

    if (transactionTypeSelect) {
      transactionTypeSelect.value = transactionType;
    }

    // 金額
    const amountInput = document.querySelector(
      '#transaction_amount'
    );

    if (amountInput) {
      amountInput.value = amount;
    }

    // カテゴリー
    const subCategorySelect = document.querySelector(
      '#transaction_sub_category_id'
    );

    if (subCategorySelect) {
      subCategorySelect.value = subCategoryId;
    }

    // メモ
    const memoInput = document.querySelector(
      '#transaction_memo'
    );

    if (memoInput) {
      memoInput.value = memo;
    }

        // 日付（当日）
    const transactedAtInput = document.querySelector(
      '#transaction_transacted_at'
    );

    if (transactedAtInput) {
      const today = new Date();

      const yyyy = today.getFullYear();
      const mm = String(today.getMonth() + 1).padStart(2, '0');
      const dd = String(today.getDate()).padStart(2, '0');

      transactedAtInput.value = `${yyyy}-${mm}-${dd}`;
    }
  });
});
