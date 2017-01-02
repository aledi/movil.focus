package com.android.focus.paneles.fragments;

import android.app.Activity;
import android.content.Intent;
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
import com.android.focus.managers.UserPreferencesManager;
import com.android.focus.model.Panel;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;
import com.android.focus.paneles.activities.EncuestasActivity;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.model.Panel.ACCEPTED;
import static com.android.focus.model.Panel.REJECTED;
import static com.android.focus.network.APIConstants.ESTADO;
import static com.android.focus.network.APIConstants.PANEL;
import static com.android.focus.network.APIConstants.PANELISTA;
import static com.android.focus.network.APIConstants.STATUS;
import static com.android.focus.network.APIConstants.SUCCESS;
import static com.android.focus.paneles.activities.EncuestasActivity.EXTRA_PANEL_ID;

public class InvitationFragment extends Fragment implements OnClickListener {

    private static final String TAG = InvitationFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + "invitationFragment";
    private static final String ARGS_PANEL_ID = FRAGMENT_TAG + ".panelId";

    private Activity activity;
    private boolean enableBack = true;
    private int panelId;
    private Panel panel;
    private View loader;
    // Content.
    private TextView title;
    private TextView description;
    // Buttons.
    private Button acceptButton;
    private Button rejectButton;
    private TextView cancelButton;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment InvitationFragment.
     */
    @NonNull
    public static InvitationFragment newInstance(int panelId) {
        InvitationFragment fragment = new InvitationFragment();
        Bundle args = new Bundle();
        args.putInt(ARGS_PANEL_ID, panelId);
        fragment.setArguments(args);

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_respond_invitation, container, false);
        loader = view.findViewById(R.id.loader);

        title = (TextView) view.findViewById(R.id.txt_title);
        description = (TextView) view.findViewById(R.id.txt_description);

        acceptButton = (Button) view.findViewById(R.id.btn_accept);
        acceptButton.setOnClickListener(this);
        rejectButton = (Button) view.findViewById(R.id.btn_reject);
        rejectButton.setOnClickListener(this);
        cancelButton = (TextView) view.findViewById(R.id.btn_cancel);
        cancelButton.setOnClickListener(this);

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        activity = getActivity();
    }

    @Override
    public void onResume() {
        super.onResume();

        panelId = getArguments().getInt(ARGS_PANEL_ID);
        panel = Panel.getPanel(panelId);

        if (panel == null) {
            return;
        }

        title.setText(panel.getNombre());
        description.setText(panel.getDescripcion());
    }
    // endregion

    // region UI methods
    private void showError(String error) {
        enableBack = true;
        loader.setVisibility(View.GONE);
        Toast.makeText(activity, error, Toast.LENGTH_SHORT).show();
    }
    // endregion

    // region Helper methods
    private HttpResponseHandler getAcceptResponseHandler() {
        return new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                if (!response.optString(STATUS).equals(SUCCESS)) {
                    showError(getString(R.string.panel_invitation_error));
                    return;
                }

                panel.setEstado(ACCEPTED);

                if (!panel.getEncuestas().isEmpty()) {
                    Intent intent = new Intent(activity, EncuestasActivity.class);
                    intent.putExtra(EXTRA_PANEL_ID, panelId);
                    startActivity(intent);
                }

                activity.finish();
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String errorResponse, Throwable throwable) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                showError(errorResponse);
            }
        };
    }

    private HttpResponseHandler getRejectResponseHandler() {
        return new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                if (!response.optString(STATUS).equals(SUCCESS)) {
                    showError(getString(R.string.panel_invitation_error));
                    return;
                }

                panel.setEstado(REJECTED);
                activity.finish();
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String errorResponse, Throwable throwable) {
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                showError(errorResponse);
            }
        };
    }
    // endregion

    // region Listeners
    @Override
    public void onClick(View view) {
        if (view.equals(acceptButton)) {
            respondInvitation(ACCEPTED, getAcceptResponseHandler());
        } else if (view.equals(rejectButton)) {
            respondInvitation(REJECTED, getRejectResponseHandler());
        } else if (view.equals(cancelButton)) {
            activity.finish();
        }
    }
    // endregion

    // region Click actions
    private void respondInvitation(int status, HttpResponseHandler responseHandler) {
        if (NetworkManager.isNetworkUnavailable(activity)) {
            return;
        }

        enableBack = false;
        loader.setVisibility(View.VISIBLE);
        RequestParams params = new RequestParams();
        params.put(PANELISTA, UserPreferencesManager.getCurrentUserId());
        params.put(PANEL, panelId);
        params.put(ESTADO, status);
        NetworkManager.respondInvitation(params, responseHandler);
    }

    public void handleOnBackPressedEvent() {
        if (enableBack) {
            activity.finish();
        }
    }
    // endregion
}
