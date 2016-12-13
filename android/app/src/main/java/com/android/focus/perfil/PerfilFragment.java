package com.android.focus.perfil;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.android.focus.R;
import com.android.focus.SplashScreenActivity;
import com.android.focus.authentication.PrivacyPolicyActivity;
import com.android.focus.managers.UserPreferencesManager;
import com.android.focus.model.Panel;
import com.android.focus.model.User;
import com.android.focus.utils.UIUtils;

public class PerfilFragment extends Fragment implements OnClickListener {

    private static final String PHONE_NUMBER = "tel:+528183387258";
    private static final String RECIPIENT = "mailto:focus@focuscg.com.mx";

    private Activity activity;
    // User.
    private TextView email;
    private TextView user;
    // Password
    private TextView changePasswordButton;
    // Panels.
    private TextView activePanelsCount;
    private TextView pendingSurveysCount;
    // Contact.
    private TextView callPhoneButton;
    private TextView privacyPolicy;
    private TextView sendEmailButton;
    // Sign out.
    private Button signOutButton;

    // region Listener variables
    private DialogInterface.OnClickListener signOutListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            UserPreferencesManager.clearCurrentUser();

            // Close any Schoolhub activity before starting Welcome activity.
            Intent intent = new Intent(getActivity(), SplashScreenActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        }
    };
    // endregion

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment AuthenticationFragment.
     */
    @NonNull
    public static PerfilFragment newInstance() {
        PerfilFragment fragment = new PerfilFragment();
        fragment.setArguments(new Bundle());

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_perfil, container, false);

        user = (TextView) view.findViewById(R.id.txt_user);
        email = (TextView) view.findViewById(R.id.txt_email);
        changePasswordButton = (TextView) view.findViewById(R.id.btn_change_password);
        changePasswordButton.setOnClickListener(this);

        activePanelsCount = (TextView) view.findViewById(R.id.txt_active_panels_count);
        pendingSurveysCount = (TextView) view.findViewById(R.id.txt_pending_surveys_count);

        sendEmailButton = (TextView) view.findViewById(R.id.txt_send_email);
        sendEmailButton.setOnClickListener(this);
        callPhoneButton = (TextView) view.findViewById(R.id.txt_call_phone);
        callPhoneButton.setOnClickListener(this);
        privacyPolicy = (TextView) view.findViewById(R.id.btn_privacy_policy);
        privacyPolicy.setOnClickListener(this);

        signOutButton = (Button) view.findViewById(R.id.btn_sign_out);
        signOutButton.setOnClickListener(this);

        return view;
    }

    @Override
    public void onResume() {
        super.onResume();

        updateView();
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
        user.setText(currentUser.getNombre());
        email.setText(currentUser.getEmail());
        activePanelsCount.setText(Panel.getActivePanels());
        pendingSurveysCount.setText(Panel.getPendingSurveys());
    }
    // endregion

    // region Listeners
    @Override
    public void onClick(View view) {
        if (view.equals(changePasswordButton)) {
            startActivity(new Intent(activity, ChangePasswordActivity.class));
        } else if (view.equals(sendEmailButton)) {
            sendEmail();
        } else if (view.equals(callPhoneButton)) {
            callPhone();
        } else if (view.equals(privacyPolicy)) {
            startActivity(new Intent(activity, PrivacyPolicyActivity.class));
        } else if (view.equals(signOutButton)) {
            UIUtils.showConfirmationDialog(R.string.sign_out, R.string.sign_out_message, R.string.sign_out, activity, signOutListener);
        }
    }
    // endregion

    // region Click Actions
    private void sendEmail() {
        Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setType("text/plain");
        intent.setData(Uri.parse(RECIPIENT));
        activity.startActivity(intent);
    }

    private void callPhone() {
        Intent intent = new Intent(Intent.ACTION_DIAL);
        intent.setData(Uri.parse(PHONE_NUMBER));
        startActivity(intent);
    }
    // endregion
}
