package com.android.focus.perfil;

import android.os.Bundle;
import android.view.MenuItem;

import com.android.focus.R;
import com.android.focus.helpers.activities.ToolbarActivity;

public class ChangePasswordActivity extends ToolbarActivity {

    private ChangePasswordFragment fragment;

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        title = getString(R.string.change_password);
        super.onCreate(savedInstanceState);

        fragment = ChangePasswordFragment.newInstance();

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, fragment, ChangePasswordFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion

    // region Menu methods
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                fragment.handleOnBackPressedEvent();
                return true;
        }

        return super.onOptionsItemSelected(item);
    }
    // endregion

    // region OnBackPressed interface
    @Override
    public void onBackPressed() {
        fragment.handleOnBackPressedEvent();
    }
    // endregion
}
