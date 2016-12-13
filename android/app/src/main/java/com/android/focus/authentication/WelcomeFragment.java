package com.android.focus.authentication;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.focus.R;
import com.android.focus.model.User;

public class WelcomeFragment extends Fragment implements OnClickListener {

    private static final String TAG = WelcomeFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + ".welcomeFragment";

    private Activity activity;
    private TextView dearUser;
    private TextView privacyPolicy;
    private TextView welcome;
    private TextView welcomeMessage;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment WelcomeFragment.
     */
    @NonNull
    public static WelcomeFragment newInstance() {
        WelcomeFragment fragment = new WelcomeFragment();
        fragment.setArguments(new Bundle());

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_welcome, container, false);

        welcome = (TextView) view.findViewById(R.id.txt_welcome);
        dearUser = (TextView) view.findViewById(R.id.txt_dear_user);
        welcomeMessage = (TextView) view.findViewById(R.id.txt_welcome_message_1);

        privacyPolicy = (TextView) view.findViewById(R.id.btn_privacy_policy);
        privacyPolicy.setOnClickListener(this);

        updateView();

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        activity = getActivity();
    }
    // endregion

    // region UI methods
    private void updateView() {
        User currentUser = User.getCurrentUser();
        int genre = currentUser.getGenero();
        Resources resources = getResources();

        welcome.setText(getString(R.string.welcome_to_focus, resources.getQuantityString(R.plurals.welcome, genre)));
        dearUser.setText(resources.getQuantityString(R.plurals.dear_user, genre, currentUser.getFirstName()));
        welcomeMessage.setText(getString(R.string.welcome_message_1, resources.getQuantityString(R.plurals.registered_user, genre)));
    }
    // endregion

    // region Listeners
    @Override
    public void onClick(View view) {
        if (view.equals(privacyPolicy)) {
            startActivity(new Intent(activity, PrivacyPolicyActivity.class));
        }
    }
    // endregion
}
