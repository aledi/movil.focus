package com.android.focus.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class DateUtils {

    private static final String DATE_FORMAT_LONG = "MMMM dd, yyyy";
    public static final String DATE_FORMAT = "yyyy-MM-dd";

    public static String dateFormat(Date date) {
        return new SimpleDateFormat(DATE_FORMAT_LONG, Locale.getDefault()).format(date);
    }
}
