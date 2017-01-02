package com.android.focus.authentication.activities;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import com.android.focus.R;
import com.android.focus.authentication.fragments.AuthenticationFragment;

public class AuthenticationActivity extends AppCompatActivity {

    private AuthenticationFragment fragment;

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        super.setContentView(R.layout.activity_authentication);

        fragment = AuthenticationFragment.newInstance();

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, fragment, AuthenticationFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion

    // region OnBackPressed interface
    @Override
    public void onBackPressed() {
        fragment.handleOnBackPressedEvent();
    }
    // endregion
}
