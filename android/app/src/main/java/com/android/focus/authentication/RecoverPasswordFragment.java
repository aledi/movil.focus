package com.android.focus.authentication;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.focus.R;
import com.android.focus.utils.UIUtils;

public class RecoverPasswordFragment extends Fragment {

    private static final String TAG = RecoverPasswordFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + ".recoverPasswordFragment";

    private Activity activity;
    private boolean enableBack = true;
    private View loader;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment RecoverPasswordFragment.
     */
    @NonNull
    public static RecoverPasswordFragment newInstance() {
        RecoverPasswordFragment fragment = new RecoverPasswordFragment();
        fragment.setArguments(new Bundle());

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_recover_password, container, false);
        loader = view.findViewById(R.id.loader);

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        activity = getActivity();
        UIUtils.hideKeyboardOnFragmentStart(activity);
    }
    // endregion

    // region Click actions
    public void handleOnBackPressedEvent() {
        if (enableBack) {
            activity.finish();
        }
    }
    // endregion
}
