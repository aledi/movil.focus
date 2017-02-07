package com.android.focus.messaging;

import android.app.IntentService;
import android.content.Intent;

import com.android.focus.managers.UserPreferencesManager;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;
import com.google.firebase.iid.FirebaseInstanceId;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.network.APIConstants.ANDROID;
import static com.android.focus.network.APIConstants.DEVICE_TOKEN;
import static com.android.focus.network.APIConstants.DEVICE_TYPE;
import static com.android.focus.network.APIConstants.ID;

public class RegistrationIntentService extends IntentService {

    private static final String TAG = RegistrationIntentService.class.getCanonicalName();

    public RegistrationIntentService() {
        super(TAG);
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        // Get updated InstanceID token.
        String refreshedToken = FirebaseInstanceId.getInstance().getToken();

        // Send the instance ID token to your app server.
        sendRegistrationToServer(refreshedToken);
    }

    /**
     * Persist token to third-party servers.
     * Modify this method to associate the user's FCM InstanceID token with any server-side account
     * maintained by your application.
     *
     * @param token The new token.
     */
    private void sendRegistrationToServer(String token) {
        int currentUserId = UserPreferencesManager.getCurrentUserId();

        if (currentUserId == 0) {
            return;
        }

        RequestParams params = new RequestParams();
        params.put(ID, currentUserId);
        params.put(DEVICE_TOKEN, token);
        params.put(DEVICE_TYPE, ANDROID);

        NetworkManager.registerDevice(params, new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
            }
        });
    }
}
