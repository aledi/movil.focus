package com.android.focus.perfil.fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.focus.R;

public class SurveyHistoryFragment extends Fragment {

    private static final String TAG = SurveyHistoryFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + "surveyHistoryFragment";

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment SurveyHistoryFragment.
     */
    @NonNull
    public static SurveyHistoryFragment newInstance() {
        SurveyHistoryFragment fragment = new SurveyHistoryFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_historial, container, false);

        return view;
    }
    // endregion
}

