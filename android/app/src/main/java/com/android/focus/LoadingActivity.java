package com.android.focus;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.CardView;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.android.focus.main.MainActivity;
import com.android.focus.managers.UserPreferencesManager;
import com.android.focus.model.User;
import com.android.focus.network.APIConstants;
import com.android.focus.network.HttpResponseHandler;
import com.android.focus.network.NetworkManager;
import com.loopj.android.http.RequestParams;

import org.json.JSONObject;

import cz.msebera.android.httpclient.Header;

public class LoadingActivity extends ToolbarActivity {

    private CardView tryAgainCard;
    private ProgressBar progressBar;
    private TextView title;
    private TextView message;

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        layoutId = R.layout.activity_loading;
        super.onCreate(savedInstanceState);

        progressBar = (ProgressBar) findViewById(R.id.progress_bar);
        title = (TextView) findViewById(R.id.txt_title);
        message = (TextView) findViewById(R.id.txt_message);
        tryAgainCard = (CardView) findViewById(R.id.card_try_again);
        Button tryAgainButton = (Button) findViewById(R.id.btn_try_again);

        if (tryAgainButton != null) {
            tryAgainButton.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View view) {
                    fetchData();
                }
            });
        }

        fetchData();
    }
    // endregion

    // region UI methods
    private void updateView(int titleResourceId, int messageResourceId) {
        progressBar.setVisibility(View.GONE);
        message.setVisibility(View.VISIBLE);
        tryAgainCard.setVisibility(View.VISIBLE);
        title.setText(getString(titleResourceId));
        message.setText(getString(messageResourceId));
    }
    // endregion

    // private void Helper methods
    private void fetchData() {
        title.setText(getString(R.string.loading_data));
        progressBar.setVisibility(View.VISIBLE);
        message.setVisibility(View.GONE);
        tryAgainCard.setVisibility(View.GONE);

        if (NetworkManager.isNetworkUnavailable()) {
            updateView(R.string.no_internet, R.string.no_internet_message);
        }

        final Activity activity = this;
        RequestParams params = new RequestParams();
        params.put(APIConstants.PANELISTA, UserPreferencesManager.getCurrentUserId());
        NetworkManager.getData(params, new HttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                // Save user and init data.
                User.setCurrentUser(UserPreferencesManager.getCurrentUser());
                UserPreferencesManager.initData(response);

                // Close any loading activity before starting main activity.
                Intent intent = new Intent(activity, MainActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String errorResponse, Throwable throwable) {
                updateView(R.string.server_unavailable_title, R.string.server_unavailable_message);
            }
        });
    }
    // endregion
}
