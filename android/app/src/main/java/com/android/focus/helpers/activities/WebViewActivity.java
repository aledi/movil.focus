package com.android.focus.helpers.activities;

import android.os.Bundle;

import com.android.focus.R;
import com.android.focus.ToolbarActivity;
import com.android.focus.helpers.fragments.WebViewFragment;

public class WebViewActivity extends ToolbarActivity {

    private static final String TAG = WebViewActivity.class.getCanonicalName();
    public static final String EXTRA_TITLE = TAG + ".title";
    public static final String EXTRA_URL = TAG + ".url";

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        title = getIntent().getStringExtra(EXTRA_TITLE);
        super.onCreate(savedInstanceState);

        WebViewFragment fragment = WebViewFragment.newInstance(getIntent().getStringExtra(EXTRA_URL));

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, fragment, WebViewFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion
}
