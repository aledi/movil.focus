package com.android.focus.perfil;

import android.os.Bundle;

import com.android.focus.R;
import com.android.focus.ToolbarActivity;

public class ChangePasswordActivity extends ToolbarActivity {

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        title = getString(R.string.change_password);
        super.onCreate(savedInstanceState);

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, ChangePasswordFragment.newInstance(), ChangePasswordFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion
}
