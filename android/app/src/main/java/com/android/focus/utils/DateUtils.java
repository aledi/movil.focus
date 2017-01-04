package com.android.focus.utils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class DateUtils {

    private static final String DATE_FORMAT_LONG = "MMMM dd, yyyy";
    private static final String DATE_AND_TIME_FORMAT_LONG = "MMMM dd, yyyy hh:mm";
    public static final String DATE_FORMAT = "yyyy-MM-dd";

    public static String dateFormat(Date date) {
        String text = new SimpleDateFormat(DATE_FORMAT_LONG, Locale.getDefault()).format(date);

        return text.substring(0, 1).toUpperCase() + text.substring(1);
    }

    public static String dateAndTimeFormat(Date date) {
        String text = new SimpleDateFormat(DATE_AND_TIME_FORMAT_LONG, Locale.getDefault()).format(date);

        return text.substring(0, 1).toUpperCase() + text.substring(1);
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

    public static int getMinYear() {
        return Calendar.getInstance().get(Calendar.YEAR) - 18;
    }

    public static Calendar getCalendar(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.clear();
        calendar.setTime(date);

        return calendar;
    }

    public static Date getNow() {
        return Calendar.getInstance().getTime();
    }
}
