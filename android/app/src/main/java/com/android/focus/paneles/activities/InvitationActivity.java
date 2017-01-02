package com.android.focus.paneles.activities;

import android.os.Bundle;
import android.view.MenuItem;

import com.android.focus.R;
import com.android.focus.helpers.activities.ToolbarActivity;
import com.android.focus.paneles.fragments.InvitationFragment;
import com.android.focus.perfil.ChangePasswordFragment;

public class InvitationActivity extends ToolbarActivity {

    private static final String TAG = InvitationActivity.class.getCanonicalName();
    public static final String EXTRA_PANEL_ID = TAG + ".panelId";

    private InvitationFragment fragment;

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        title = getString(R.string.panel_invitation);
        super.onCreate(savedInstanceState);

        fragment = InvitationFragment.newInstance(getIntent().getIntExtra(EXTRA_PANEL_ID, -1));

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
