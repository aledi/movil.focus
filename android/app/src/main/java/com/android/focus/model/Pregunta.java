package com.android.focus.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Pregunta class.
 */

public class Pregunta {

    public static final int TEXT_ANSWER = 1;
    public static final int SINGLE_OPTION = 2;
    public static final int MULTIPLE_OPTION = 3;
    public static final int ORDERING = 4;
    public static final int MAX_OPTIONS = 10;

    private boolean contestada;
    private int id;
    private int tipo;
    private int numPregunta;
    private String pregunta;
    private String video;
    private String imagen;
    private List<String> opciones;
    private String respuesta;
    private List<String> respuestasSeleccionadas;

    // region Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTipo() {
        return tipo;
    }

    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    public int getNumPregunta() {
        return numPregunta;
    }

    public void setNumPregunta(int numPregunta) {
        this.numPregunta = numPregunta;
    }

    public String getPregunta() {
        return pregunta;
    }

    public void setPregunta(String pregunta) {
        this.pregunta = pregunta;
    }

    public String getVideo() {
        return video;
    }

    public void setVideo(String video) {
        this.video = video;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public List<String> getOpciones() {
        return opciones;
    }

    public void setOpciones(List<String> opciones) {
        this.opciones = opciones;
    }

    public String getRespuesta() {
        return respuesta;
    }

    public void setRespuesta(String respuesta) {
        this.respuesta = respuesta;
    }

    public List<String> getRespuestasSeleccionadas() {
        if (respuestasSeleccionadas == null) {
            respuestasSeleccionadas = new ArrayList<>();
        }

        return respuestasSeleccionadas;
    }

    public void setRespuestaSeleccionada(String respuestaSeleccionada) {
        List<String> respuestasSeleccionadas = getRespuestasSeleccionadas();
        respuestasSeleccionadas.add(respuestaSeleccionada);
    }

    public void removeRespuestaSeleccionada(String respuestaSeleccionada) {
        List<String> respuestasSeleccionadas = getRespuestasSeleccionadas();
        respuestasSeleccionadas.remove(respuestaSeleccionada);
    }
    // endregion
}
