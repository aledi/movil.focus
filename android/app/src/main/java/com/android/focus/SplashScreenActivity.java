package com.android.focus;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import com.android.focus.authentication.AuthenticationActivity;
import com.android.focus.managers.UserPreferencesManager;

public class SplashScreenActivity extends AppCompatActivity {

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        super.setContentView(R.layout.activity_splash);

        Class clazz = UserPreferencesManager.hasCurrentUser() ? LoadingActivity.class : AuthenticationActivity.class;
        Intent intent = new Intent(this, clazz);
        startActivity(intent);
        finish();
    }
    // endregion
}
