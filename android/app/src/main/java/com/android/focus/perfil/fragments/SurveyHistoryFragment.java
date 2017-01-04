package com.android.focus.perfil.fragments;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.focus.R;
import com.android.focus.model.Historial;
import com.android.focus.utils.DateUtils;

import java.util.List;

public class SurveyHistoryFragment extends Fragment {

    private static final String TAG = SurveyHistoryFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + "surveyHistoryFragment";

    private Activity activity;
    private LinearLayout historyLayout;
    private List<Historial> surveyHistory;
    private TextView noHistory;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment SurveyHistoryFragment.
     */
    @NonNull
    public static SurveyHistoryFragment newInstance() {
        SurveyHistoryFragment fragment = new SurveyHistoryFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        surveyHistory = Historial.getSurveyHistory();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_historial, container, false);

        noHistory = (TextView) view.findViewById(R.id.txt_no_history);
        historyLayout = (LinearLayout) view.findViewById(R.id.layout_historial);

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

        if (surveyHistory.isEmpty()) {
            return;
        }

        noHistory.setVisibility(View.GONE);
        historyLayout.removeAllViews();

        for (Historial survey : surveyHistory) {
            historyLayout.addView(createViewForSurvey(survey));
        }
    }
    // endregion

    // region UI methods
    private View createViewForSurvey(Historial survey) {
        View view = View.inflate(activity, R.layout.fragment_historial_item, null);
        TextView title = (TextView) view.findViewById(R.id.txt_title);
        title.setText(survey.getNombreEncuesta());
        TextView answered = (TextView) view.findViewById(R.id.txt_answered);
        answered.setText(survey.getRespuesta());
        TextView startDate = (TextView) view.findViewById(R.id.txt_start_date);
        startDate.setText(DateUtils.dateFormat(survey.getFechaInicioEncuesta()));
        TextView endDate = (TextView) view.findViewById(R.id.txt_end_date);
        endDate.setText(DateUtils.dateFormat(survey.getFechaFinEncuesta()));
        TextView panel = (TextView) view.findViewById(R.id.txt_panel);
        panel.setText(survey.getNombrePanel());

        return view;
    }
    // endregion
}
