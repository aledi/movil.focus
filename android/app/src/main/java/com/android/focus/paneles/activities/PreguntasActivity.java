package com.android.focus.paneles.activities;

import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import com.android.focus.R;
import com.android.focus.helpers.activities.ToolbarActivity;
import com.android.focus.paneles.fragments.PreguntasFragment;

public class PreguntasActivity extends ToolbarActivity {

    private static final String TAG = PreguntasActivity.class.getCanonicalName();
    public static final String EXTRA_PANEL_ID = TAG + ".panelId";
    public static final String EXTRA_ENCUESTA_ID = TAG + ".encuestaId";

    private PreguntasFragment fragment;

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        displayHomeAsUpEnabled = false;
        title = getString(R.string.survey);
        super.onCreate(savedInstanceState);

        fragment = PreguntasFragment.newInstance(getIntent().getIntExtra(EXTRA_PANEL_ID, -1), getIntent().getIntExtra(EXTRA_ENCUESTA_ID, -1));

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, fragment, PreguntasFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion

    // region Menu methods
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_preguntas, menu);

        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.save_respuestas:
                fragment.saveRespuestas();
                return true;
        }

        return super.onOptionsItemSelected(item);
    }
    // endregion

    // region OnBackPressed interface
    @Override
    public void onBackPressed() {
        // Do nothing.
    }
    // endregion
}
