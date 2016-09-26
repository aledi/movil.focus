package com.android.focus.paneles.fragments;

import android.media.MediaPlayer;
import android.media.MediaPlayer.OnErrorListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.VideoView;
import android.widget.ViewSwitcher;

import com.android.focus.R;
import com.android.focus.network.NetworkManager;

public class VideoViewFragment extends Fragment {

    public static final String FRAGMENT_TAG = VideoViewFragment.class.getCanonicalName();
    private static final String ARGS_VIDEO_URL = FRAGMENT_TAG + ".url";

    private int code;
    private String url;
    private ViewSwitcher viewSwitcher;
    private VideoView video;

    // region Factory methods

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment VideoViewFragment.
     */
    @NonNull
    public static VideoViewFragment newInstance(String url) {
        VideoViewFragment fragment = new VideoViewFragment();
        Bundle args = new Bundle();
        args.putString(ARGS_VIDEO_URL, url);
        fragment.setArguments(args);

        return fragment;
    }
    // endregion

    // region Fragment lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        url = getArguments().getString(ARGS_VIDEO_URL);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.fragment_video_view, container, false);

        viewSwitcher = (ViewSwitcher) view.findViewById(R.id.view_switcher);
        video = (VideoView) view.findViewById(R.id.video);

        playVideo();

        return view;
    }
    // endregion

    // region Video Actions
    private void playVideo() {
        if (NetworkManager.isNetworkUnavailable()) {
            viewSwitcher.setDisplayedChild(1);
        } else {
            video.setVideoURI(Uri.parse(url));

            video.setOnPreparedListener(new OnPreparedListener() {
                @Override
                public void onPrepared(MediaPlayer mediaPlayer) {
                    video.start();
                }
            });

            video.setOnErrorListener(new OnErrorListener() {
                @Override
                public boolean onError(MediaPlayer mediaPlayer, int what, int extra) {
                    viewSwitcher.setDisplayedChild(1);
                    return false;
                }
            });
        }
    }
    // endregion
}
