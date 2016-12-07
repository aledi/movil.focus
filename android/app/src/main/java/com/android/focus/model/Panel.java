package com.android.focus.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Panel class.
 */

public class Panel {

    private static List<Panel> userPanels;

    private int id;
    private String nombre;
    private Date fechaInicio;
    private Date fechaFin;
    private List<Encuesta> encuestas;

    // region Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public List<Encuesta> getEncuestas() {
        return (encuestas == null) ? new ArrayList<Encuesta>() : encuestas;
    }

    public void setEncuestas(List<Encuesta> encuestas) {
        this.encuestas = encuestas;
    }
    // endregion

    // region Utility methods
    public static void setUserPaneles(List<Panel> panels) {
        userPanels = panels;
    }

    public static List<Panel> getUserPaneles() {
        return (userPanels == null) ? new ArrayList<Panel>() : userPanels;
    }

    public static String getActivePanels() {
        return Integer.toString(getUserPaneles().size());
    }

    public static String getPendingSurveys() {
        int pendingSurveys = 0;
        List<Panel> userPanels = getUserPaneles();

        for (Panel userPanel : userPanels) {
            List<Encuesta> encuestas = userPanel.getEncuestas();

            for (Encuesta encuesta : encuestas) {
                pendingSurveys += encuesta.isContestada() ? 0 : 1;
            }
        }

        return Integer.toString(pendingSurveys);
    }
    // endregion
}
