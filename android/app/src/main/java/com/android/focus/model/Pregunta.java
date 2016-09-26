package com.android.focus.model;

import com.android.focus.utils.TextUtils;

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
    private boolean videoVisto;
    private List<String> respuestasSeleccionadas = new ArrayList<>();
    private String[] respuestasOrdenadas = {"", "", "", "", "", "", "", "", "", ""};

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

    public boolean isVideoVisto() {
        return (!TextUtils.isValidString(video)) || videoVisto;
    }

    public void setVideoVisto(boolean videoVisto) {
        this.videoVisto = videoVisto;
    }

    public List<String> getRespuestasSeleccionadas() {
        return respuestasSeleccionadas;
    }

    public void setRespuestaSeleccionada(String respuesta) {
        respuestasSeleccionadas.add(respuesta);
    }

    public void removeRespuestaSeleccionada(String respuesta) {
        respuestasSeleccionadas.remove(respuesta);
    }

    public String[] getRespuestasOrdenadas() {
        return respuestasOrdenadas;
    }

    public void setRespuestaOrdenada(int index, String respuesta) {
        respuestasOrdenadas[index] = respuesta;
    }

    public void removeRespuestaOrdenada(String opcion) {
        respuestasOrdenadas[getOpcionIndex(opcion)] = "";
    }

    public int getNextIndex() {
        return getOpcionIndex("");
    }

    public void clearRespuestasOrdenadas() {
        for (int i = 0; i < MAX_OPTIONS; i++) {
            respuestasOrdenadas[i] = "";
        }
    }

    private int getOpcionIndex(String opcion) {
        for (int i = 0; i < MAX_OPTIONS; i++) {
            if (opcion.equals(respuestasOrdenadas[i])) {
                return i;
            }
        }

        return 0;
    }
    // endregion
}
