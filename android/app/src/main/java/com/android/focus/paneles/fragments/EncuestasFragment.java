package com.android.focus.paneles.fragments;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.focus.FocusApp;
import com.android.focus.R;
import com.android.focus.model.Encuesta;
import com.android.focus.model.User;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;
import com.android.focus.paneles.activities.PreguntasActivity;
import com.android.focus.utils.DateUtils;
import com.android.focus.utils.UIUtils;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import java.util.List;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.network.APIConstants.ENCUESTA;
import static com.android.focus.network.APIConstants.PANELISTA;
import static com.android.focus.network.APIConstants.STATUS;
import static com.android.focus.network.APIConstants.SUCCESS;
import static com.android.focus.paneles.activities.PreguntasActivity.EXTRA_ENCUESTA_ID;
import static com.android.focus.paneles.activities.PreguntasActivity.EXTRA_PANEL_ID;

public class EncuestasFragment extends Fragment {

    public static final String FRAGMENT_TAG = EncuestasFragment.class.getCanonicalName();
    private static final String ARGS_PANEL_ID = FRAGMENT_TAG + ".panelId";

    private Activity activity;
    private boolean enableBack = true;
    private int panelId;
    private LinearLayout encuestasList;
    private View loader;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment EncuestasFragment.
     */
    @NonNull
    public static EncuestasFragment newInstance(int panelId) {
        EncuestasFragment fragment = new EncuestasFragment();
        Bundle args = new Bundle();
        args.putInt(ARGS_PANEL_ID, panelId);
        fragment.setArguments(args);

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        panelId = getArguments().getInt(ARGS_PANEL_ID);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_encuestas, container, false);

        encuestasList = (LinearLayout) view.findViewById(R.id.list_encuestas);
        loader = view.findViewById(R.id.loader);

        return view;
    }

    @Override
    public void onResume() {
        super.onResume();

        List<Encuesta> encuestas = Encuesta.getUserEncuestas(panelId);
        encuestasList.removeAllViews();

        for (Encuesta encuesta : encuestas) {
            encuestasList.addView(createViewForEncuesta(encuesta));
        }
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        activity = getActivity();
    }
    // endregion

    // region UI methods
    private View createViewForEncuesta(final Encuesta encuesta) {
        View view = View.inflate(FocusApp.getContext(), R.layout.card_detail, null);
        TextView title = (TextView) view.findViewById(R.id.txt_title);
        title.setText(encuesta.getNombre());
        TextView preguntas = (TextView) view.findViewById(R.id.txt_preguntas);
        preguntas.setText(getResources().getQuantityString(R.plurals.preguntas_count, encuesta.getPreguntas().size(), encuesta.getPreguntas().size()));
        ImageView image = (ImageView) view.findViewById(R.id.image);
        image.setImageResource(encuesta.isContestada() ? R.drawable.ic_check_mark : R.drawable.ic_arrow);
        TextView startDate = (TextView) view.findViewById(R.id.txt_start_date);
        startDate.setText(DateUtils.dateFormat(encuesta.getFechaInicio()));
        TextView endDate = (TextView) view.findViewById(R.id.txt_end_date);
        endDate.setText(DateUtils.dateFormat(encuesta.getFechaFin()));

        view.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (encuesta.isContestada()) {
                    UIUtils.showAlertDialog(R.string.answered_title, R.string.answered_message, activity);
                } else {
                    UIUtils.showConfirmationDialog(R.string.no_answered_title, R.string.no_answered_message, R.string.no_answered_button, activity, new OnStartEncuestaListener(encuesta));
                }
            }
        });

        return view;
    }

    private void updateLoader(boolean enableBack, int visibility) {
        this.enableBack = enableBack;
        loader.setVisibility(visibility);
    }

    private void showAlertDialog(int title, int message) {
        updateLoader(true, View.GONE);
        UIUtils.showAlertDialog(title, message, activity);
    }
    // endregion

    // region Click Actions
    public void handleOnBackPressedEvent() {
        if (!enableBack) {
            return;
        }

        activity.finish();
    }
    // endregion

    // region Static classes
    private class OnStartEncuestaListener implements DialogInterface.OnClickListener {

        Encuesta encuesta;

        OnStartEncuestaListener(Encuesta encuesta) {
            this.encuesta = encuesta;
        }

        @Override
        public void onClick(DialogInterface dialog, int which) {
            if (NetworkManager.isNetworkUnavailable(activity)) {
                return;
            }

            updateLoader(false, View.VISIBLE);

            RequestParams params = new RequestParams();
            params.put(PANELISTA, User.getCurrentUser().getId());
            params.put(ENCUESTA, encuesta.getId());
            NetworkManager.startSurvey(params, new HttpResponseHandler() {
                @Override
                public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                    if (!response.optString(STATUS).equals(SUCCESS)) {
                        showAlertDialog(R.string.error_start_survey_title, R.string.error_start_survey_message);
                        return;
                    }

                    encuesta.setContestada(true);
                    updateLoader(true, View.GONE);

                    Intent intent = new Intent(getActivity(), PreguntasActivity.class);
                    intent.putExtra(EXTRA_PANEL_ID, panelId);
                    intent.putExtra(EXTRA_ENCUESTA_ID, encuesta.getId());
                    startActivity(intent);
                }

                @Override
                public void onFailure(int statusCode, Header[] headers, String errorResponse, Throwable throwable) {
                    showAlertDialog(R.string.server_unavailable_title, R.string.server_unavailable_message);
                }
            });
        }
    }
    // endregion
}
