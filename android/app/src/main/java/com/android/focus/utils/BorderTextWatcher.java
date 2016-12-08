package com.android.focus.utils;

import android.text.Editable;
import android.text.TextWatcher;
import android.widget.EditText;

import com.android.focus.R;

public class BorderTextWatcher implements TextWatcher {

    private EditText editText;

    public BorderTextWatcher(EditText editText) {
        this.editText = editText;
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        // Do nothing.
    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
        // Do nothing
    }

    @Override
    public void afterTextChanged(Editable s) {
        editText.setBackgroundResource(R.drawable.border);
    }
}
