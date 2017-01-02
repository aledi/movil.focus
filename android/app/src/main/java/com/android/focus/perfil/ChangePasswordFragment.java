package com.android.focus.perfil;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;
import android.widget.Toast;

import com.android.focus.R;
import com.android.focus.managers.UserPreferencesManager;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;
import com.android.focus.utils.BorderTextWatcher;
import com.android.focus.utils.TextUtils;
import com.android.focus.utils.UIUtils;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.network.APIConstants.NEW_PASSWORD;
import static com.android.focus.network.APIConstants.OLD_PASSWORD;
import static com.android.focus.network.APIConstants.PANELISTA;
import static com.android.focus.network.APIConstants.STATUS;
import static com.android.focus.network.APIConstants.SUCCESS;
import static com.android.focus.network.APIConstants.WRONG_PASSWORD;

public class ChangePasswordFragment extends Fragment implements OnClickListener, OnEditorActionListener {

    private static final String TAG = ChangePasswordFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + "changePasswordFragment";

    private Activity activity;
    private boolean enableBack = true;
    private Button changePasswordButton;
    private EditText confirmPassword;
    private EditText currentPassword;
    private EditText newPassword;
    private RequestParams params;
    private View loader;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment ChangePasswordFragment.
     */
    @NonNull
    public static ChangePasswordFragment newInstance() {
        ChangePasswordFragment fragment = new ChangePasswordFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_change_password, container, false);
        loader = view.findViewById(R.id.loader);

        currentPassword = (EditText) view.findViewById(R.id.txt_current_password);
        currentPassword.addTextChangedListener(new BorderTextWatcher(currentPassword));
        newPassword = (EditText) view.findViewById(R.id.txt_new_password);
        newPassword.addTextChangedListener(new BorderTextWatcher(newPassword));
        confirmPassword = (EditText) view.findViewById(R.id.txt_confirm_password);
        confirmPassword.addTextChangedListener(new BorderTextWatcher(confirmPassword));
        confirmPassword.setOnEditorActionListener(this);
        changePasswordButton = (Button) view.findViewById(R.id.btn_change_password);
        changePasswordButton.setOnClickListener(this);

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        activity = getActivity();
        UIUtils.hideKeyboardOnFragmentStart(activity);
    }
    // endregion

    // region UI methods
    private void showError(String error) {
        enableBack = true;
        loader.setVisibility(View.GONE);
        Toast.makeText(activity, error, Toast.LENGTH_SHORT).show();
    }

    private void setInvalidBorder(View view) {
        view.setBackgroundResource(R.drawable.border_invalid);
    }
    // endregion

    // region Helper methods
    private boolean checkForInvalidFields() {
        boolean invalidFields = false;

        String currentPasswordText = currentPassword.getText().toString().trim();
        String newPasswordText = newPassword.getText().toString().trim();
        String confirmPasswordText = confirmPassword.getText().toString().trim();

        if (!TextUtils.isValidPassword(currentPasswordText)) {
            invalidFields = true;
            setInvalidBorder(currentPassword);
        }

        if (!TextUtils.isValidPassword(newPasswordText)) {
            invalidFields = true;
            setInvalidBorder(newPassword);
        }

        if (!TextUtils.isValidPassword(confirmPasswordText)) {
            invalidFields = true;
            setInvalidBorder(confirmPassword);
        }

        if (!newPasswordText.equals(confirmPasswordText)) {
            invalidFields = true;
            setInvalidBorder(newPassword);
            setInvalidBorder(confirmPassword);
            showError(getString(R.string.confirm_new_password_error));
        }

        if (invalidFields) {
            return true;
        }

        params.put(PANELISTA, UserPreferencesManager.getCurrentUserId());
        params.put(OLD_PASSWORD, currentPasswordText);
        params.put(NEW_PASSWORD, newPasswordText);

        return false;
    }
    // endregion

    // region Listeners
    @Override
    public void onClick(View view) {
        if (view.equals(changePasswordButton)) {
            changePassword();
        }
    }

    @Override
    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
        if (actionId == EditorInfo.IME_ACTION_DONE || actionId == KeyEvent.KEYCODE_ENTER) {
            changePasswordButton.callOnClick();
        }

        return false;
    }
    // endregion

    // region Click actions
    public void changePassword() {
        UIUtils.hideKeyboardIfShowing(activity);
        params = new RequestParams();

        if (checkForInvalidFields()) {
            return;
        }

        if (NetworkManager.isNetworkUnavailable(activity)) {
            return;
        }

        enableBack = false;
        loader.setVisibility(View.VISIBLE);

        NetworkManager.changePassword(params, new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                int title;
                int text;

                if (response.optString(STATUS).equals(WRONG_PASSWORD)) {
                    title = R.string.error;
                    text = R.string.wrong_password;
                } else if (!response.optString(STATUS).equals(SUCCESS)) {
                    title = R.string.error;
                    text = R.string.change_password_error;
                } else {
                    title = R.string.change_password_success_title;
                    text = R.string.change_password_success_message;
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

                showError(errorResponse);
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
