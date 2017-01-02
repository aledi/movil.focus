package com.android.focus.model;

import java.util.Date;

public class Historial {

    private String nombrePanel;
    private Date fechaInicioPanel;
    private Date fechaFinPanel;
    private String nombreEncuesta;
    private Date fechaInicioEncuesta;
    private Date fechaFinEncuesta;

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
    // endregion
}
