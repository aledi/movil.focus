package com.android.focus.paneles.activities;

import android.os.Bundle;

import com.android.focus.R;
import com.android.focus.ToolbarActivity;
import com.android.focus.paneles.fragments.PreguntasFragment;
import com.android.focus.paneles.fragments.VideoViewFragment;

public class VideoViewActivity extends ToolbarActivity {

    private static final String TAG = VideoViewActivity.class.getCanonicalName();
    public static final String EXTRA_VIDEO_URL = TAG + ".url";

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        title = getString(R.string.video);
        super.onCreate(savedInstanceState);

        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.container, VideoViewFragment.newInstance(getIntent().getStringExtra(EXTRA_VIDEO_URL)), PreguntasFragment.FRAGMENT_TAG)
                    .commit();
        }
    }
    // endregion
}
