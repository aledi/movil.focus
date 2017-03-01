package com.android.focus.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Panel class.
 */

public class Panel {

    public static final int PENDING = 0;
    public static final int ACCEPTED = 1;
    public static final int REJECTED = 2;

    private static List<Panel> userPanels = new ArrayList<>();

    private int id;
    private int estado;
    private String nombre;
    private String descripcion;
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

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
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

    // region Properties
    public int getPendingSurveysCount() {
        int count = 0;
        List<Encuesta> encuestas = getEncuestas();

        for (Encuesta encuesta : encuestas) {
            if (!encuesta.isContestada()) {
                count = +1;
            }
        }

        return count;
    }
    // endregion

    // region Utility methods
    public static void setUserPaneles(List<Panel> panels) {
        userPanels = panels;
    }

    public static List<Panel> getUserPaneles() {
        List<Panel> notRejectedPanels = new ArrayList<>();

        for (Panel panel : userPanels) {
            if (panel.getEstado() == REJECTED) {
                continue;
            }

            notRejectedPanels.add(panel);
        }

        return notRejectedPanels;
    }

    public static String getActivePanels() {
        return Integer.toString(getUserPaneles().size());
    }

    public static List<Encuesta> getPendingSurveys() {
        List<Panel> userPanels = getUserPaneles();
        List<Encuesta> pendingSurveys = new ArrayList<>();

        for (Panel userPanel : userPanels) {
            List<Encuesta> encuestas = userPanel.getEncuestas();

            for (Encuesta encuesta : encuestas) {
                if (encuesta.isContestada()) {
                    continue;
                }

                pendingSurveys.add(encuesta);
            }
        }

        return pendingSurveys;
    }

    public static Panel getPanel(int panelId) {
        List<Panel> userPanels = getUserPaneles();

        for (Panel panel : userPanels) {
            if (panel.getId() == panelId) {
                return panel;
            }
        }

        return null;
    }
    // endregion
}
