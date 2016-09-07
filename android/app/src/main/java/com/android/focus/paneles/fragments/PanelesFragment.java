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
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.focus.FocusApp;
import com.android.focus.R;
import com.android.focus.model.Panel;
import com.android.focus.paneles.activities.EncuestasActivity;
import com.android.focus.utils.DateUtils;
import com.android.focus.utils.UIUtils;

import java.util.List;

import static com.android.focus.paneles.activities.EncuestasActivity.EXTRA_PANEL_ID;

public class PanelesFragment extends Fragment {

    private LinearLayout panelsList;
    private TextView noActivePanels;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment PanelesFragment.
     */
    @NonNull
    public static PanelesFragment newInstance() {
        PanelesFragment fragment = new PanelesFragment();
        fragment.setArguments(new Bundle());

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_paneles, container, false);

        panelsList = (LinearLayout) view.findViewById(R.id.list_panels);
        noActivePanels = (TextView) view.findViewById(R.id.txt_no_active_panels);

        return view;
    }

    @Override
    public void onResume() {
        super.onResume();

        updateView(Panel.getUserPaneles());
    }
    // endregion

    // region UI methods
    private void updateView(List<Panel> panels) {
        panelsList.removeAllViews();

        if (panels.isEmpty()) {
            noActivePanels.setVisibility(View.VISIBLE);
            return;
        }

        for (Panel panel : panels) {
            panelsList.addView(createViewForPanel(panel));
        }
    }

    private View createViewForPanel(final Panel panel) {
        final Activity activity = getActivity();
        View view = View.inflate(FocusApp.getContext(), R.layout.card_detail, null);
        TextView title = (TextView) view.findViewById(R.id.txt_title);
        title.setText(panel.getNombre());
        ImageView image = (ImageView) view.findViewById(R.id.image);
        TextView startDate = (TextView) view.findViewById(R.id.txt_start_date);
        startDate.setText(DateUtils.dateFormat(panel.getFechaInicio()));
        TextView endDate = (TextView) view.findViewById(R.id.txt_end_date);
        endDate.setText(DateUtils.dateFormat(panel.getFechaFin()));

        if (panel.getEncuestas().isEmpty()) {
            view.setOnClickListener(showNoSurveysDialog(activity));
        } else {
            image.setImageResource(R.drawable.ic_arrow);
            view.setOnClickListener(getViewPanelListener(panel.getId(), activity));
        }

        return view;
    }
    // endregion

    // region Helper methods
    private OnClickListener getViewPanelListener(final int panelId, final Activity activity) {
        return new OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(activity, EncuestasActivity.class);
                intent.putExtra(EXTRA_PANEL_ID, panelId);
                startActivity(intent);
            }
        };
    }

    private OnClickListener showNoSurveysDialog(final Activity activity) {
        return new OnClickListener() {
            @Override
            public void onClick(View view) {
                UIUtils.showAlertDialog(R.string.no_surveys_title, R.string.no_surveys_message, activity);
            }
        };
    }
    // endregion
}
