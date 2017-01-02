package com.android.focus.perfil;

import android.app.Activity;
import android.content.ActivityNotFoundException;
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
import android.widget.Toast;

import com.android.focus.R;
import com.android.focus.SplashScreenActivity;
import com.android.focus.authentication.PrivacyPolicyActivity;
import com.android.focus.helpers.WebViewActivity;
import com.android.focus.managers.UserPreferencesManager;
import com.android.focus.model.Panel;
import com.android.focus.model.User;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;
import com.android.focus.utils.UIUtils;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import java.util.Locale;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.network.APIConstants.PANELISTA;

public class PerfilFragment extends Fragment implements OnClickListener {

    private static final String PHONE_NUMBER = "tel:+528183387258";
    private static final String RECIPIENT = "mailto:focus@focuscg.com.mx";
    private static final String RATE_APP_URI = "market://details?id=com.focus.android";

    private Activity activity;
    private boolean enableBack = true;
    private View loader;
    // User.
    private TextView email;
    private TextView user;
    // Password
    private TextView changePasswordButton;
    // Panels.
    private TextView activePanelsCount;
    private TextView pendingSurveysCount;
    private TextView surveyHistoryButton;
    // Help.
    private TextView faqButton;
    private TextView sendEmailButton;
    private TextView callPhoneButton;
    // Other.
    private TextView shareButton;
    private TextView rateButton;
    private TextView privacyPolicy;
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
        loader = view.findViewById(R.id.loader);

        // Set up for 'User' section
        user = (TextView) view.findViewById(R.id.txt_user);
        email = (TextView) view.findViewById(R.id.txt_email);
        changePasswordButton = (TextView) view.findViewById(R.id.btn_change_password);
        changePasswordButton.setOnClickListener(this);

        // Set up for 'Paneles' section
        activePanelsCount = (TextView) view.findViewById(R.id.txt_active_panels_count);
        pendingSurveysCount = (TextView) view.findViewById(R.id.txt_pending_surveys_count);
        surveyHistoryButton = (TextView) view.findViewById(R.id.btn_survey_history);
        surveyHistoryButton.setOnClickListener(this);

        // Set up for 'Ayuda' section
        faqButton = (TextView) view.findViewById(R.id.txt_faq);
        faqButton.setOnClickListener(this);
        sendEmailButton = (TextView) view.findViewById(R.id.txt_send_email);
        sendEmailButton.setOnClickListener(this);
        callPhoneButton = (TextView) view.findViewById(R.id.txt_call_phone);
        callPhoneButton.setOnClickListener(this);

        // Set up for 'Otro' section
        shareButton = (TextView) view.findViewById(R.id.btn_share);
        shareButton.setOnClickListener(this);
        rateButton = (TextView) view.findViewById(R.id.btn_rate);
        rateButton.setOnClickListener(this);
        privacyPolicy = (TextView) view.findViewById(R.id.btn_privacy_policy);
        privacyPolicy.setOnClickListener(this);

        // Set up for sign out button.
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
        pendingSurveysCount.setText(String.format(Locale.getDefault(), "%d", Panel.getPendingSurveys().size()));
    }

    private void showError(String error) {
        enableBack = true;
        loader.setVisibility(View.GONE);
        Toast.makeText(activity, error, Toast.LENGTH_SHORT).show();
    }
    // endregion

    // region Listeners
    @Override
    public void onClick(View view) {
        if (view.equals(changePasswordButton)) {
            startActivity(new Intent(activity, ChangePasswordActivity.class));
        } else if (view.equals(surveyHistoryButton)) {
            downloadHistory();
        } else if (view.equals(faqButton)) {
            openFAQ();
        } else if (view.equals(sendEmailButton)) {
            sendEmail();
        } else if (view.equals(callPhoneButton)) {
            callPhone();
        } else if (view.equals(shareButton)) {
            shareApp();
        } else if (view.equals(rateButton)) {
            rateApp();
        } else if (view.equals(privacyPolicy)) {
            startActivity(new Intent(activity, PrivacyPolicyActivity.class));
        } else if (view.equals(signOutButton)) {
            UIUtils.showConfirmationDialog(R.string.sign_out, R.string.sign_out_message, R.string.sign_out, activity, signOutListener);
        }
    }
    // endregion

    // region Click Actions
    private void downloadHistory() {
        if (NetworkManager.isNetworkUnavailable(activity)) {
            return;
        }

        enableBack = false;
        loader.setVisibility(View.VISIBLE);
        RequestParams params = new RequestParams();
        params.put(PANELISTA, UserPreferencesManager.getCurrentUserId());

        NetworkManager.downloadHistory(params, new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                System.out.println(response);
                enableBack = true;
                loader.setVisibility(View.GONE);
                startActivity(new Intent(activity, SurveyHistoryActivity.class));
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String errorResponse, Throwable throwable) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                if (statusCode == 500) {
                    errorResponse = getString(R.string.server_error);
                }

                showError(errorResponse);
            }
        });
    }

    private void openFAQ() {
        Intent intent = new Intent(activity, WebViewActivity.class);
        intent.putExtra(WebViewActivity.EXTRA_TITLE, getString(R.string.faq));
        intent.putExtra(WebViewActivity.EXTRA_URL, "file:///android_asset/FAQ.html");
        startActivity(intent);
    }

    private void sendEmail() {
        Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setType("text/plain");
        intent.setData(Uri.parse(RECIPIENT));

        try {
            startActivity(intent);
        } catch (ActivityNotFoundException exception) {
            UIUtils.showAlertDialog(R.string.error, R.string.send_email_error, activity);
        }
    }

    private void callPhone() {
        Intent intent = new Intent(Intent.ACTION_DIAL);
        intent.setData(Uri.parse(PHONE_NUMBER));

        try {
            startActivity(intent);
        } catch (ActivityNotFoundException exception) {
            UIUtils.showAlertDialog(R.string.error, R.string.call_phone_error, activity);
        }
    }

    private void shareApp() {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("text/plain");
        intent.putExtra(Intent.EXTRA_SUBJECT, getString(R.string.app_name));
        intent.putExtra(Intent.EXTRA_TEXT, getString(R.string.share_message));

        try {
            startActivity(Intent.createChooser(intent, getString(R.string.share)));
        } catch (ActivityNotFoundException exception) {
            UIUtils.showAlertDialog(R.string.error, R.string.share_error, activity);
        }
    }

    private void rateApp() {
        Uri uri = Uri.parse(RATE_APP_URI);
        Intent intent = new Intent(Intent.ACTION_VIEW, uri);

        try {
            startActivity(intent);
        } catch (ActivityNotFoundException exception) {
            UIUtils.showAlertDialog(R.string.error, R.string.rate_error, activity);
        }
    }

    public void handleOnBackPressedEvent() {
        if (enableBack) {
            activity.finish();
        }
    }
    // endregion
}
