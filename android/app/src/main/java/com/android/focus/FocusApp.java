package com.android.focus;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.onesignal.OneSignal;

/**
 * Base Activity
 */
public class FocusApp extends Application {

    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 900;

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

    public static boolean noGooglePlayServices(Activity activity) {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(activity);

        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(activity, resultCode, PLAY_SERVICES_RESOLUTION_REQUEST).show();
            }

            return true;
        }

        return false;
    }
    // endregion
}
