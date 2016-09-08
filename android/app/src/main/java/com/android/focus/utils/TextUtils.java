package com.android.focus.utils;

public class TextUtils {

    public static boolean isValidString(String text) {
        return (text != null) && !android.text.TextUtils.isEmpty(text);
    }
}
