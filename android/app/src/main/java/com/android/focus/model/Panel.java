package com.android.focus.model;

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
        return encuestas;
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
        return userPanels;
    }

    public static String getActivePanels() {
        return "1";
    }

    public static String getPendingSurveys() {
        return "0";
    }
    // endregion
}
