package com.android.focus;

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;

import com.onesignal.OneSignal;

/**
 * Base Activity
 */
public class FocusApp extends Application {

    private static FocusApp app;

    // region Application lifecycle
    @Override
    public void onCreate() {
        super.onCreate();

        app = this;

        // One Signal.
        OneSignal.startInit(this).init();
    }
    // endregion

    // region Helper methods
    public static Context getContext() {
        return app.getApplicationContext();
    }

    public static Resources getAppResources() {
        return getContext().getResources();
    }

    public static SharedPreferences getUserPreferences() {
        Context context = getContext();

        return context.getSharedPreferences(context.getPackageName(), Context.MODE_PRIVATE);
    }
    // endregion
}
