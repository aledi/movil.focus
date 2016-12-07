package com.android.focus.utils;

import android.app.Activity;
import android.support.annotation.NonNull;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.android.focus.FocusApp;
import com.android.focus.R;

import java.util.List;

public class ArrayDefaultAdapter extends ArrayAdapter<String> {

    private final int blackColor = FocusApp.getAppResources().getColor(R.color.black);
    private final int hintColor = FocusApp.getAppResources().getColor(R.color.text_hint);

    public ArrayDefaultAdapter(List<String> opciones, Activity activity) {
        super(activity, R.layout.simple_spinner_item, opciones);
    }

    public ArrayDefaultAdapter(String[] opciones, Activity activity) {
        super(activity, R.layout.simple_spinner_item, opciones);
    }

    @Override
    public boolean isEnabled(int position) {
        return (position != 0);
    }

    @NonNull
    @Override
    public View getView(int position, View convertView, @NonNull ViewGroup parent) {
        return getView((TextView) super.getView(position, convertView, parent), position);
    }

    @Override
    public View getDropDownView(int position, View convertView, @NonNull ViewGroup parent) {
        return getView((TextView) super.getDropDownView(position, convertView, parent), position);
    }

    private View getView(TextView textView, int position) {
        if (position == 0) {
            textView.setTextColor(hintColor);
        } else {
            textView.setTextColor(blackColor);
        }

        return textView;
    }
}
