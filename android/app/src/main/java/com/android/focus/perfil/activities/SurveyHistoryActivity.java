package com.android.focus.perfil.activities;

import android.os.Bundle;

import com.android.focus.R;
import com.android.focus.helpers.activities.ToolbarActivity;
import com.android.focus.perfil.fragments.SurveyHistoryFragment;

public class SurveyHistoryActivity extends ToolbarActivity {

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        title = getString(R.string.survey_history);
        super.onCreate(savedInstanceState);

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, SurveyHistoryFragment.newInstance(), SurveyHistoryFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion
}
