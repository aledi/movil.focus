package com.android.focus.utils;

import android.util.Patterns;

public class TextUtils {

    public static boolean isValidString(String text) {
        return (text != null) && !android.text.TextUtils.isEmpty(text);
    }

    public static boolean isValidPassword(String text) {
        return (text != null) && !android.text.TextUtils.isEmpty(text) && text.length() >= 4;
    }

    public static boolean isValidEmail(String email) {
        return isValidString(email) && Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }
}
