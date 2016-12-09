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
    public static final int MATRIX = 5;
    public static final int SCALE = 6;
    public static final int MAX_OPTIONS = 20;

    private int id;
    private int tipo;
    private int numPregunta;
    private boolean combo;
    private String titulo;
    private String pregunta;
    private String video;
    private String imagen;
    private List<String> opciones;
    private List<String> subPreguntas;
    private String respuesta;
    private boolean videoVisto;
    private List<String> respuestasSeleccionadas = new ArrayList<>();
    private String[] respuestasOrdenadas = {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""};
    private int[] selectedSubPreguntas = new int[]{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};

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

    public boolean isCombo() {
        return combo;
    }

    public void setCombo(boolean combo) {
        this.combo = combo;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
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

    public List<String> getSubPreguntas() {
        return subPreguntas;
    }

    public void setSubPreguntas(List<String> subPreguntas) {
        this.subPreguntas = subPreguntas;
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

    public int getMinScale() {
        return opciones.size() > 0 ? Integer.valueOf(opciones.get(0)) : 0;
    }

    public int getMaxScale() {
        return opciones.size() > 1 ? Integer.valueOf(opciones.get(1)) : 0;
    }

    public void setSubPregunta(int index, int value) {
        selectedSubPreguntas[index] = value;
    }

    public int getSubPregunta(int index) {
        return selectedSubPreguntas[index];
    }

    public boolean isMatrixAnswered() {
        for (int i = 0; i < subPreguntas.size(); i++) {
            if (selectedSubPreguntas[i] == -1) {
                return false;
            }
        }

        return true;
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
