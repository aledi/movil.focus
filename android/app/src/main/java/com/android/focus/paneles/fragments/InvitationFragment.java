package com.android.focus.paneles.fragments;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.focus.R;
import com.android.focus.model.Panel;

public class InvitationFragment extends Fragment {

    private static final String TAG = InvitationFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + "invitationFragment";
    private static final String ARGS_PANEL_ID = FRAGMENT_TAG + ".panelId";

    private Activity activity;
    private boolean enableBack = true;
    private View loader;
    // Text
    private TextView title;
    private TextView description;

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

        Panel panel = Panel.getPanel(getArguments().getInt(ARGS_PANEL_ID));

        if (panel == null) {
            return;
        }

        title.setText(panel.getNombre());
        description.setText(panel.getDescripcion());
    }
    // endregion

    // region Click actions
    public void handleOnBackPressedEvent() {
        if (enableBack) {
            activity.finish();
        }
    }
    // endregion
}
