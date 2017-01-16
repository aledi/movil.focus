package com.android.focus.helpers.fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;

import com.android.focus.R;

public class WebViewFragment extends Fragment {

    private static final String TAG = WebViewFragment.class.getCanonicalName();
    public static final String FRAGMENT_TAG = TAG + "webViewFragment";
    public static final String ARGS_URL = TAG + ".url";

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment WebViewFragment.
     */
    @NonNull
    public static WebViewFragment newInstance(String url) {
        WebViewFragment fragment = new WebViewFragment();
        Bundle args = new Bundle();
        args.putString(ARGS_URL, url);
        fragment.setArguments(args);

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_web_view, container, false);

        WebView webView = (WebView) view.findViewById(R.id.web_view);
        webView.loadUrl(getArguments().getString(ARGS_URL));

        return view;
    }
    // endregion
}
