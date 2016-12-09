package com.android.focus.authentication;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.android.focus.R;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;
import com.android.focus.utils.BorderTextWatcher;
import com.android.focus.utils.TextUtils;
import com.android.focus.utils.UIUtils;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.network.APIConstants.EMAIL;
import static com.android.focus.network.APIConstants.STATUS;
import static com.android.focus.network.APIConstants.SUCCESS;
import static com.android.focus.network.APIConstants.USERNAME;
import static com.android.focus.network.APIConstants.WRONG_USER;

public class RecoverPasswordFragment extends Fragment implements OnClickListener {

    private static final String TAG = RecoverPasswordFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + ".recoverPasswordFragment";

    private Activity activity;
    private boolean enableBack = true;
    private Button recoverPasswordButton;
    private EditText username;
    private EditText email;
    private RequestParams params;
    private String emailText;
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

        username = (EditText) view.findViewById(R.id.txt_username);
        username.addTextChangedListener(new BorderTextWatcher(username));
        email = (EditText) view.findViewById(R.id.txt_email);
        email.addTextChangedListener(new BorderTextWatcher(email));
        recoverPasswordButton = (Button) view.findViewById(R.id.btn_recover_password);
        recoverPasswordButton.setOnClickListener(this);

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        activity = getActivity();
        UIUtils.hideKeyboardOnFragmentStart(activity);
    }
    // endregion

    // region Helper methods
    private boolean checkForInvalidFields() {
        String usernameText = username.getText().toString().trim();
        emailText = email.getText().toString().trim();

        if (!TextUtils.isValidString(usernameText) && !TextUtils.isValidEmail(emailText)) {
            UIUtils.showAlertDialog(R.string.recover_password_empty_fields_title, R.string.recover_password_empty_fields_message, activity);
            return true;
        }

        params.put(USERNAME, usernameText);
        params.put(EMAIL, emailText);

        return false;
    }
    // endregion

    // region Listeners
    @Override
    public void onClick(View view) {
        if (view.equals(recoverPasswordButton)) {
            recoverPassword();
        }
    }
    // endregion

    // region Click actions
    public void recoverPassword() {
        enableBack = false;
        UIUtils.hideKeyboardIfShowing(activity);
        params = new RequestParams();

        if (checkForInvalidFields()) {
            return;
        }

        if (NetworkManager.isNetworkUnavailable(activity)) {
            return;
        }

        loader.setVisibility(View.VISIBLE);

        NetworkManager.recoverPassword(params, new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                String title;
                String text;

                if (response.optString(STATUS).equals(WRONG_USER)) {
                    title = getString(R.string.error);
                    text = getString(R.string.wrong_user);
                } else if (!response.optString(STATUS).equals(SUCCESS)) {
                    title = getString(R.string.error);
                    text = getString(R.string.recover_password_error);
                } else {
                    title = getString(R.string.recover_password_success_title);
                    text = getString(R.string.recover_password_success_message, emailText);
                }

                UIUtils.showAlertDialog(title, text, activity);
                enableBack = true;
                loader.setVisibility(View.GONE);
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String errorResponse, Throwable throwable) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                UIUtils.showAlertDialog(R.string.error, R.string.recover_password_error, activity);
                enableBack = true;
                loader.setVisibility(View.GONE);
            }
        });
    }

    public void handleOnBackPressedEvent() {
        if (enableBack) {
            activity.finish();
        }
    }
    // endregion
}
