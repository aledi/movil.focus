package com.android.focus.paneles.fragments;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v7.widget.CardView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
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
import com.android.focus.paneles.activities.VideoViewActivity;
import com.android.focus.utils.TextUtils;
import com.android.focus.utils.UIUtils;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import cz.msebera.android.httpclient.Header;

import static com.android.focus.model.Pregunta.MAX_OPTIONS;
import static com.android.focus.model.Pregunta.MULTIPLE_OPTION;
import static com.android.focus.model.Pregunta.ORDERING;
import static com.android.focus.model.Pregunta.SINGLE_OPTION;
import static com.android.focus.model.Pregunta.TEXT_ANSWER;
import static com.android.focus.network.APIConstants.ID;
import static com.android.focus.network.APIConstants.RESPUESTAS;

public class PreguntasFragment extends Fragment {

    public static final String FRAGMENT_TAG = PreguntasFragment.class.getCanonicalName();
    private static final String ARGS_PANEL_ID = FRAGMENT_TAG + ".panelId";
    private static final String ARGS_ENCUESTA_ID = FRAGMENT_TAG + ".encuestaId";

    private Activity activity;
    private boolean enableBack = true;
    private int encuestaId;
    private int panelId;
    private List<Pregunta> preguntas;
    private String dialogTitle;
    private int dialogMessage;
    private String respuestas;
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
     * @return A new instance of fragment PreguntasFragment.
     */
    @NonNull
    public static PreguntasFragment newInstance(int panelId, int encuestaId) {
        PreguntasFragment fragment = new PreguntasFragment();
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

        View view = inflater.inflate(R.layout.fragment_preguntas, container, false);
        loader = view.findViewById(R.id.loader);

        preguntas = Encuesta.getPreguntas(panelId, encuestaId);
        LinearLayout preguntasList = (LinearLayout) view.findViewById(R.id.list_preguntas);

        for (Pregunta pregunta : preguntas) {
            preguntasList.addView(createViewForPregunta(pregunta));
        }

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        activity = getActivity();
        UIUtils.hideKeyboardOnFragmentStart(activity);
    }
    // endregion

    // region UI methods - Question
    private View createViewForPregunta(Pregunta pregunta) {
        View view = View.inflate(FocusApp.getContext(), R.layout.fragment_preguntas_item, null);
        setUpForTitle((TextView) view.findViewById(R.id.txt_title), pregunta.getTitulo());
        TextView text = (TextView) view.findViewById(R.id.txt_pregunta);
        text.setText(pregunta.getNumPregunta() + ".- " + pregunta.getPregunta());
        setUpForImage((ImageView) view.findViewById(R.id.image), pregunta.getImagen());
        setUpForVideo((CardView) view.findViewById(R.id.card_video), (Button) view.findViewById(R.id.video), pregunta);

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
            case ORDERING:
                setUpForOrderingAnswer(pregunta, view);
        }

        return view;
    }

    private void setUpForTitle(TextView textView, String title) {
        textView.setVisibility(TextUtils.isValidString(title) ? View.VISIBLE : View.GONE);
        textView.setText(title);
    }

    private void setUpForImage(ImageView image, String url) {
        if (!TextUtils.isValidString(url)) {
            image.setVisibility(View.GONE);
            return;
        }

        image.setVisibility(View.VISIBLE);
        new ImageLoaderClass(image).execute(url);
    }

    private void setUpForVideo(CardView card, Button video, final Pregunta pregunta) {
        card.setVisibility(TextUtils.isValidString(pregunta.getVideo()) ? View.VISIBLE : View.GONE);
        video.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!pregunta.isVideoVisto()) {
                    pregunta.setVideoVisto(true);
                }

                Intent intent = new Intent(getActivity(), VideoViewActivity.class);
                intent.putExtra(VideoViewActivity.EXTRA_VIDEO_URL, pregunta.getVideo());
                startActivity(intent);
            }
        });
    }
    // endregion

    // region UI methods - Open Answer
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
    // endregion

    // region UI methods - Single Option
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
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_10));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_11));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_12));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_13));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_14));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_15));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_16));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_17));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_18));
        buttons.add((RadioButton) view.findViewById(R.id.btn_single_option_19));

        return buttons;
    }
    // endregion

    // region UI methods - Multiple Option
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
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_10));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_11));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_12));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_13));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_14));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_15));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_16));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_17));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_18));
        buttons.add((CheckBox) view.findViewById(R.id.btn_multiple_option_19));

        return buttons;
    }
    // endregion

    // region UI methods - Ordering
    private void setUpForOrderingAnswer(final Pregunta pregunta, final View view) {
        LinearLayout orderingLayout = (LinearLayout) view.findViewById(R.id.layout_ordering);
        orderingLayout.setVisibility(View.VISIBLE);
        List<String> opciones = pregunta.getOpciones();
        final List<CheckBox> buttons = getCheckBoxesForOrdering(view);

        for (int i = 0; i < MAX_OPTIONS; i++) {
            final CheckBox checkBox = buttons.get(i);
            checkBox.setButtonDrawable(R.drawable.ic_check_off);
            checkBox.setChecked(false);

            if (i < opciones.size()) {
                final String opcion = opciones.get(i);
                checkBox.setText(opcion);
                checkBox.setOnCheckedChangeListener(new OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        if (isChecked) {
                            int index = pregunta.getNextIndex();
                            pregunta.setRespuestaOrdenada(index, opcion);
                            checkBox.setButtonDrawable(getNumberDrawable(index + 1));
                        } else {
                            checkBox.setOnCheckedChangeListener(null);
                        }
                    }
                });
            } else {
                checkBox.setVisibility(View.GONE);
            }
        }

        TextView resetButton = (TextView) view.findViewById(R.id.btn_reset);
        resetButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                pregunta.clearRespuestasOrdenadas();
                setUpForOrderingAnswer(pregunta, view);
            }
        });
    }

    private List<CheckBox> getCheckBoxesForOrdering(View view) {
        List<CheckBox> buttons = new ArrayList<>();
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_0));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_1));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_2));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_3));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_4));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_5));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_6));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_7));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_8));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_9));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_10));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_11));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_12));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_13));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_14));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_15));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_16));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_17));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_18));
        buttons.add((CheckBox) view.findViewById(R.id.btn_ordering_19));

        return buttons;
    }

    private int getNumberDrawable(int number) {
        switch (number) {
            case 1:
                return R.drawable.selected01;
            case 2:
                return R.drawable.selected02;
            case 3:
                return R.drawable.selected03;
            case 4:
                return R.drawable.selected04;
            case 5:
                return R.drawable.selected05;
            case 6:
                return R.drawable.selected06;
            case 7:
                return R.drawable.selected07;
            case 8:
                return R.drawable.selected08;
            case 9:
                return R.drawable.selected09;
            case 10:
                return R.drawable.selected10;
            case 11:
                return R.drawable.selected11;
            case 12:
                return R.drawable.selected12;
            case 13:
                return R.drawable.selected13;
            case 14:
                return R.drawable.selected14;
            case 15:
                return R.drawable.selected15;
            case 16:
                return R.drawable.selected16;
            case 17:
                return R.drawable.selected17;
            case 18:
                return R.drawable.selected18;
            case 19:
                return R.drawable.selected19;
            case 20:
            default:
                return R.drawable.selected20;
        }
    }
    // endregion

    // region Encuesta Actions
    public void saveRespuestas() {
        enableBack = false;
        UIUtils.hideKeyboardIfShowing(activity);

        if (checkForInvalidRespuesta()) {
            UIUtils.showAlertDialog(dialogTitle, dialogMessage, activity);
            return;
        }

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

    private boolean checkForInvalidRespuesta() {
        for (Pregunta pregunta : preguntas) {
            if (!pregunta.isVideoVisto()) {
                dialogTitle = getString(R.string.error_unseen_video_title, pregunta.getNumPregunta());
                dialogMessage = R.string.error_unseen_video_message;

                return true;
            }

            if (pregunta.getTipo() == MULTIPLE_OPTION) {
                String respuestaMultipleOption = "";
                List<String> respuestasSeleccionadas = pregunta.getRespuestasSeleccionadas();

                for (String respuestaSeleccionada : respuestasSeleccionadas) {
                    respuestaMultipleOption += respuestaSeleccionada + "&";
                }

                pregunta.setRespuesta(respuestaMultipleOption);
            } else if (pregunta.getTipo() == ORDERING) {
                String respuestaOrdenamiento = "";
                String[] respuestasOrdenadas = pregunta.getRespuestasOrdenadas();

                for (String respuestaOrdenada : respuestasOrdenadas) {
                    if (respuestaOrdenada.equals("")) {
                        dialogTitle = getString(R.string.error_save_survey_title, pregunta.getNumPregunta());
                        dialogMessage = R.string.error_save_survey_message;

                        return true;
                    } else {
                        respuestaOrdenamiento += respuestaOrdenada + "&";
                    }
                }

                pregunta.setRespuesta(respuestaOrdenamiento);
            }

            String respuesta = pregunta.getRespuesta();

            if (!TextUtils.isValidString(respuesta)) {
                dialogTitle = getString(R.string.error_save_survey_title, pregunta.getNumPregunta());
                dialogMessage = R.string.error_save_survey_message;

                return true;
            }

            respuestas += respuesta + "|";
        }

        return false;
    }

    private RequestParams getRequestParams() {
        RequestParams params = new RequestParams();
        params.put(ID, encuestaId);
        params.put(RESPUESTAS, respuestas);

        return params;
    }
    // endregion

    // region Static classes
    private class ImageLoaderClass extends AsyncTask<String, String, Bitmap> {

        Bitmap bitmap;
        ImageView imageView;

        ImageLoaderClass(ImageView imageView) {
            this.imageView = imageView;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

        }

        protected Bitmap doInBackground(String... args) {
            try {
                bitmap = BitmapFactory.decodeStream((InputStream) new URL(args[0]).getContent());
            } catch (Exception e) {
                e.printStackTrace();
            }
            return bitmap;
        }

        protected void onPostExecute(Bitmap image) {
            if (image != null) {
                imageView.setImageBitmap(image);
            }
        }
    }
    // endregion
}
