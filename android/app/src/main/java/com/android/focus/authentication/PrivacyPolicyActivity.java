package com.android.focus.authentication;

import android.os.Bundle;

import com.android.focus.R;
import com.android.focus.helpers.activities.ToolbarActivity;

public class PrivacyPolicyActivity extends ToolbarActivity {

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        title = getString(R.string.privacy_policy);
        super.onCreate(savedInstanceState);

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, PrivacyPolicyFragment.newInstance(), PrivacyPolicyFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion
}
