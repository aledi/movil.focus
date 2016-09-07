package com.android.focus.paneles.fragments;

import android.app.Activity;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.android.focus.FocusApp;
import com.android.focus.R;
import com.android.focus.model.Encuesta;
import com.android.focus.model.Pregunta;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;
import com.android.focus.utils.TextUtils;
import com.android.focus.utils.UIUtils;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.model.Pregunta.MAX_OPTIONS;
import static com.android.focus.model.Pregunta.MULTIPLE_OPTION;
import static com.android.focus.model.Pregunta.SINGLE_OPTION;
import static com.android.focus.model.Pregunta.TEXT_ANSWER;
import static com.android.focus.network.APIConstants.ID;
import static com.android.focus.network.APIConstants.RESPUESTAS;

public class EncuestaFragment extends Fragment {

    public static final String FRAGMENT_TAG = EncuestaFragment.class.getCanonicalName();
    private static final String ARGS_PANEL_ID = FRAGMENT_TAG + ".panelId";
    private static final String ARGS_ENCUESTA_ID = FRAGMENT_TAG + ".encuestaId";

    private Activity activity;
    private boolean enableBack = true;
    private int encuestaId;
    private int panelId;
    private LinearLayout preguntasList;
    private List<Pregunta> preguntas;
    private View loader;

    // region Listeners variables
    private DialogInterface.OnClickListener positiveButtonListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            activity.finish();
        }
    };
    // endregion

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment EncuestaFragment.
     */
    @NonNull
    public static EncuestaFragment newInstance(int panelId, int encuestaId) {
        EncuestaFragment fragment = new EncuestaFragment();
        Bundle args = new Bundle();
        args.putInt(ARGS_PANEL_ID, panelId);
        args.putInt(ARGS_ENCUESTA_ID, encuestaId);
        fragment.setArguments(args);

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        panelId = getArguments().getInt(ARGS_PANEL_ID);
        encuestaId = getArguments().getInt(ARGS_ENCUESTA_ID);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_encuesta, container, false);

        preguntasList = (LinearLayout) view.findViewById(R.id.list_preguntas);
        loader = view.findViewById(R.id.loader);

        return view;
    }

    @Override
    public void onResume() {
        super.onResume();

        preguntas = Encuesta.getPreguntas(panelId, encuestaId);
        preguntasList.removeAllViews();

        for (Pregunta pregunta : preguntas) {
            preguntasList.addView(createViewForPregunta(pregunta));
        }
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        activity = getActivity();
        UIUtils.hideKeyboardOnFragmentStart(activity);
    }
    // endregion

    // region UI methods
    private View createViewForPregunta(Pregunta pregunta) {
        View view = View.inflate(FocusApp.getContext(), R.layout.fragment_preguntas_item, null);
        TextView text = (TextView) view.findViewById(R.id.txt_pregunta);
        text.setText(pregunta.getNumPregunta() + ".- " + pregunta.getPregunta());
        ImageView image = (ImageView) view.findViewById(R.id.image);
        image.setVisibility(TextUtils.isValidString(pregunta.getImagen()) ? View.VISIBLE : View.GONE);

        switch (pregunta.getTipo()) {
            case TEXT_ANSWER:
                setUpForOpenAnswer(pregunta, view);
                break;
            case SINGLE_OPTION:
                setUpForSingleOptionAnswer(pregunta, view);
                break;
            case MULTIPLE_OPTION:
                setUpForMultipleOptionAnswer(pregunta, view);
                break;
        }

        return view;
    }

    private void setUpForOpenAnswer(final Pregunta pregunta, View view) {
        EditText respuesta = (EditText) view.findViewById(R.id.txt_respuesta);
        respuesta.setVisibility(View.VISIBLE);

        respuesta.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                // Do nothing.
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String respuesta = s.toString().trim();
                pregunta.setRespuesta(TextUtils.isValidString(respuesta) ? respuesta : null);
            }

            @Override
            public void afterTextChanged(Editable s) {
                // Do nothing.
            }
        });
    }

    private void setUpForSingleOptionAnswer(final Pregunta pregunta, View view) {
        RadioGroup radioGroup = (RadioGroup) view.findViewById(R.id.radio_group);
        radioGroup.setVisibility(View.VISIBLE);
        final List<String> opciones = pregunta.getOpciones();
        List<RadioButton> buttons = getRadioButtonsForSingleOption(view);


        for (int i = 0; i < MAX_OPTIONS; i++) {
            final RadioButton radioButton = buttons.get(i);

            if (i < opciones.size()) {
                final String opcion = opciones.get(i);
                radioButton.setText(opcion);
                radioButton.setOnCheckedChangeListener(new OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        radioButton.setChecked(isChecked);

                        if (isChecked) {
                            pregunta.setRespuesta(opcion);
                            radioButton.setButtonDrawable(R.drawable.ic_radio_on);
                        } else {
                            radioButton.setButtonDrawable(R.drawable.ic_radio_off);
                        }
                    }
                });
            } else {
                radioButton.setVisibility(View.GONE);
            }
        }

    }

    private List<RadioButton> getRadioButtonsForSingleOption(View view) {
        List<RadioButton> buttons = new ArrayList<>();
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_0));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_1));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_2));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_3));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_4));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_5));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_6));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_7));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_8));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_9));

        return buttons;
    }

    private void setUpForMultipleOptionAnswer(final Pregunta pregunta, View view) {
        LinearLayout multipleOptionLayout = (LinearLayout) view.findViewById(R.id.layout_multiple_option);
        multipleOptionLayout.setVisibility(View.VISIBLE);
        List<String> opciones = pregunta.getOpciones();
        List<CheckBox> buttons = getCheckBoxesForMultipleOption(view);


        for (int i = 0; i < MAX_OPTIONS; i++) {
            final CheckBox checkBox = buttons.get(i);

            if (i < opciones.size()) {
                final String opcion = opciones.get(i);
                checkBox.setText(opcion);
                checkBox.setOnCheckedChangeListener(new OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        if (isChecked) {
                            pregunta.setRespuestaSeleccionada(opcion);
                            checkBox.setButtonDrawable(R.drawable.ic_check_on);
                        } else {
                            pregunta.removeRespuestaSeleccionada(opcion);
                            checkBox.setButtonDrawable(R.drawable.ic_check_off);
                        }
                    }
                });
            } else {
                checkBox.setVisibility(View.GONE);
            }
        }

    }

    private List<CheckBox> getCheckBoxesForMultipleOption(View view) {
        List<CheckBox> buttons = new ArrayList<>();
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_0));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_1));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_2));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_3));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_4));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_5));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_6));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_7));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_8));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_9));

        return buttons;
    }
    // endregion

    // region Click actions
    public void handleOnBackPressedEvent() {
        if (!enableBack) {
            return;
        }

        activity.finish();
    }
    // endregion

    // region Encuesta actions
    public void saveRespuestas() {
        enableBack = false;
        UIUtils.hideKeyboardIfShowing(activity);

        // TODO: Check for invalid fields.

        if (NetworkManager.isNetworkUnavailable(activity)) {
            return;
        }

        loader.setVisibility(View.VISIBLE);

        NetworkManager.saveAnswers(getRequestParams(), new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                UIUtils.showAlertDialog(R.string.success_save_title, R.string.success_save_message, activity, positiveButtonListener);
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String errorResponse, Throwable throwable) {
                UIUtils.showAlertDialog(R.string.error_save_title, R.string.error_save_message, activity, positiveButtonListener);
            }
        });
    }
    // endregion

    // region Helper methods
    private RequestParams getRequestParams() {
        RequestParams params = new RequestParams();
        String respuestas = "";

        for (Pregunta pregunta : preguntas) {
            if (pregunta.getTipo() == MULTIPLE_OPTION) {
                String respuesta = "";
                List<String> respuestasSeleccionadas = pregunta.getRespuestasSeleccionadas();

                for (String respuestaSeleccionada : respuestasSeleccionadas) {
                    respuesta += respuestaSeleccionada + "&";
                }

                pregunta.setRespuesta(respuesta);
            }

            respuestas += pregunta.getRespuesta() + "|";
        }

        params.put(ID, encuestaId);
        params.put(RESPUESTAS, respuestas);

        return params;
    }
    // endregion
}
