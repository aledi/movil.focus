package com.android.focus.authentication;

import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;

import com.android.focus.R;

public class RecoverPasswordActivity extends AppCompatActivity {

    private RecoverPasswordFragment fragment;

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        super.setContentView(R.layout.activity_toolbar);

        Toolbar toolbar = ((Toolbar) findViewById(R.id.toolbar));
        setSupportActionBar(toolbar);
        ActionBar actionBar = getSupportActionBar();

        if (actionBar != null) {
            actionBar.setTitle(getString(R.string.recover_password));
            actionBar.setDisplayHomeAsUpEnabled(true);
        }

        fragment = RecoverPasswordFragment.newInstance();

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, fragment, RecoverPasswordFragment.FRAGMENT_TAG)
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
