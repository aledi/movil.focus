package com.android.focus.authentication;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import com.android.focus.R;
import com.android.focus.helpers.activities.ToolbarActivity;
import com.android.focus.main.MainActivity;
import com.android.focus.model.User;

public class WelcomeActivity extends ToolbarActivity {

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        displayHomeAsUpEnabled = false;
        title = getResources().getQuantityString(R.plurals.welcome, User.getCurrentUser().getGenero());
        super.onCreate(savedInstanceState);

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, WelcomeFragment.newInstance(), WelcomeFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion

    // region Menu methods
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_welcome, menu);

        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.continuar:
                openMainActivity();
                return true;
        }

        return super.onOptionsItemSelected(item);
    }
    // endregion

    // region Helper methods
    private void openMainActivity() {
        startActivity(new Intent(this, MainActivity.class));
        finish();
    }
    // endregion
}
