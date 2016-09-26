package com.android.focus.utils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class DateUtils {

    private static final String DATE_FORMAT_LONG = "MMMM dd, yyyy";
    public static final String DATE_FORMAT = "yyyy-MM-dd";

    public static String dateFormat(Date date) {
        return new SimpleDateFormat(DATE_FORMAT_LONG, Locale.getDefault()).format(date);
    }

    public static List<String> getYears() {
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        int past100Years = currentYear - 100;
        List<String> years = new ArrayList<>();

        for (int year = currentYear - 18; year > past100Years; year--) {
            years.add(Integer.toString(year));
        }

        return years;
    }
}
