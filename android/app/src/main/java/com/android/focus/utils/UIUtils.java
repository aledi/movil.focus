package com.android.focus.utils;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;

import com.android.focus.FocusApp;
import com.android.focus.R;

/**
 * Utils to perform UI actions.
 */

public class UIUtils {

    /**
     * Hides the keyboard that might be shown by any of the edit texts.
     *
     * @param activity Activity to customize.
     */
    public static void hideKeyboardIfShowing(Activity activity) {
        View view = activity.getCurrentFocus();
        if (view != null) {
            InputMethodManager inputManager = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
            inputManager.hideSoftInputFromWindow(view.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    /**
     * Hides the keyboard when a fragment starts.
     *
     * @param activity Activity to customize.
     */
    public static void hideKeyboardOnFragmentStart(Activity activity) {
        activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN | WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
    }

    /**
     * Get string resource.
     *
     * @param resourceId String resource id.
     */
    public static String getString(int resourceId) {
        return FocusApp.getAppResources().getString(resourceId);
    }

    /**
     * Show alert dialog.
     */
    public static void showAlertDialog(int title, int message, Activity activity) {
        showAlertDialog(getString(title), message, activity);
    }

    public static void showAlertDialog(String title, int message, Activity activity) {
        showDialog(title, message, android.R.string.ok, false, activity, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
            }
        });
    }

    public static void showAlertDialog(int title, int message, Activity activity, DialogInterface.OnClickListener positiveButtonListener) {
        showDialog(title, message, android.R.string.ok, false, activity, positiveButtonListener);
    }

    /**
     * Show confirmation dialog
     */
    public static void showConfirmationDialog(int title, int message, int positiveButton, Activity activity, final DialogInterface.OnClickListener positiveButtonListener) {
        showDialog(title, message, positiveButton, true, activity, positiveButtonListener);
    }

    private static void showDialog(int title, int message, int positiveButton, boolean cancelable, Activity activity, final DialogInterface.OnClickListener positiveButtonListener) {
        showDialog(getString(title), message, positiveButton, cancelable, activity, positiveButtonListener);
    }

    private static void showDialog(String title, int message, int positiveButton, boolean cancelable, Activity activity, final DialogInterface.OnClickListener positiveButtonListener) {
        AlertDialog.Builder builder = new AlertDialog.Builder(activity)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton(positiveButton, positiveButtonListener);

        if (cancelable) {
            builder.setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            });
        }

        builder.show();
    }
}
