package com.android.focus.authentication;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.focus.R;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;

import org.json.JSONObject;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.network.APIConstants.CONTENT;

public class PrivacyPolicyFragment extends Fragment {

    private static final String TAG = PrivacyPolicyFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + ".privacyPolicyFragment";

    private TextView privacyPolicy;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment PrivacyPolicyFragment.
     */
    @NonNull
    public static PrivacyPolicyFragment newInstance() {
        PrivacyPolicyFragment fragment = new PrivacyPolicyFragment();
        fragment.setArguments(new Bundle());

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (NetworkManager.isNetworkUnavailable()) {
            return;
        }

        NetworkManager.privacyPolicy(getResponseHandler());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_privacy_policy, container, false);
        privacyPolicy = (TextView) view.findViewById(R.id.btn_privacy_policy);

        return view;
    }
    // endregion

    // region Helper methods
    private HttpResponseHandler getResponseHandler() {
        return new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                if (!response.has(CONTENT)) {
                    return;
                }

                privacyPolicy.setText(response.optString(CONTENT));
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String errorResponse, Throwable throwable) {
                // Do nothing.
            }
        };
    }
    // endregion
}
