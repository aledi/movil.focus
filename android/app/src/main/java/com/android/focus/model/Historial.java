package com.android.focus.model;

import com.android.focus.FocusApp;
import com.android.focus.R;
import com.android.focus.utils.DateUtils;
import com.android.focus.utils.TextUtils;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import static com.android.focus.network.APIConstants.HORA_RESPUESTA;
import static com.android.focus.network.APIConstants.RESULTS;

public class Historial {

    private static List<Historial> surveyHistory = new ArrayList<>();

    private String nombrePanel;
    private Date fechaInicioPanel;
    private Date fechaFinPanel;
    private String nombreEncuesta;
    private Date fechaInicioEncuesta;
    private Date fechaFinEncuesta;
    private Date fechaRespuesta;

    // region Getters and setters
    public String getNombrePanel() {
        return nombrePanel;
    }

    public void setNombrePanel(String nombrePanel) {
        this.nombrePanel = nombrePanel;
    }

    public Date getFechaInicioPanel() {
        return fechaInicioPanel;
    }

    public void setFechaInicioPanel(Date fechaInicioPanel) {
        this.fechaInicioPanel = fechaInicioPanel;
    }

    public Date getFechaFinPanel() {
        return fechaFinPanel;
    }

    public void setFechaFinPanel(Date fechaFinPanel) {
        this.fechaFinPanel = fechaFinPanel;
    }

    public String getNombreEncuesta() {
        return nombreEncuesta;
    }

    public void setNombreEncuesta(String nombreEncuesta) {
        this.nombreEncuesta = nombreEncuesta;
    }

    public Date getFechaInicioEncuesta() {
        return fechaInicioEncuesta;
    }

    public void setFechaInicioEncuesta(Date fechaInicioEncuesta) {
        this.fechaInicioEncuesta = fechaInicioEncuesta;
    }

    public Date getFechaFinEncuesta() {
        return fechaFinEncuesta;
    }

    public void setFechaFinEncuesta(Date fechaFinEncuesta) {
        this.fechaFinEncuesta = fechaFinEncuesta;
    }

    public Date getFechaRespuesta() {
        return fechaRespuesta;
    }

    public void setFechaRespuesta(Date fechaRespuesta) {
        this.fechaRespuesta = fechaRespuesta;
    }
    // endregion

    // region Properties
    public String getRespuesta() {
        return (fechaRespuesta == null) ? FocusApp.getAppResources().getString(R.string.not_answered) : DateUtils.dateAndTimeFormat(fechaRespuesta);
    }
    // endregion

    // region Utility methods
    public static void initData(JSONObject response) {
        Gson gson = new GsonBuilder()
                .setDateFormat(DateUtils.DATE_FORMAT)
                .create();

        // Set survey history.
        JSONArray historyArray = response.optJSONArray(RESULTS);
        surveyHistory = gson.fromJson(historyArray.toString(), new TypeToken<List<Historial>>() {
        }.getType());

        for (int i = 0; i < historyArray.length(); i++) {
            JSONObject historyObject = historyArray.optJSONObject(i);
            Historial history = surveyHistory.get(i);
            Date fechaRespuesta = history.getFechaRespuesta();

            if (fechaRespuesta == null) {
                continue;
            }

            String horaRespuesta = historyObject.optString(HORA_RESPUESTA);

            if (!TextUtils.isValidString(horaRespuesta)) {
                continue;
            }

            String[] horaRespuestaComponents = horaRespuesta.split(":");

            if (horaRespuestaComponents.length < 3) {
                continue;
            }

            Calendar calendar = DateUtils.getCalendar(fechaRespuesta);
            calendar.set(Calendar.HOUR_OF_DAY, Integer.valueOf(horaRespuestaComponents[0]));
            calendar.set(Calendar.MINUTE, Integer.valueOf(horaRespuestaComponents[1]));
            calendar.set(Calendar.SECOND, Integer.valueOf(horaRespuestaComponents[2]));
            history.setFechaRespuesta(calendar.getTime());
        }
    }

    public static List<Historial> getSurveyHistory() {
        return surveyHistory;
    }
    // endregion
}
