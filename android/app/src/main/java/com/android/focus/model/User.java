package com.android.focus.model;

import com.android.focus.FocusApp;
import com.android.focus.R;

/**
 * User class.
 */

public class User {

    public static final String ID = "id";
    public static final String USERNAME = "username";
    public static final String PASSWORD = "password";
    public static final String NOMBRE = "nombre";
    public static final String APELLIDOS = "apellidos";
    public static final String EMAIL = "email";
    public static final String GENERO = "genero";
    public static final String FECHA_NACIMIENTO = "fechaNacimiento";
    public static final String EDUCACION = "educacion";
    public static final String CALLE_NUMERO = "calleNumero";
    public static final String COLONIA = "colonia";
    public static final String MUNICIPIO = "municipio";
    public static final String ESTADO = "estado";
    public static final String CP = "cp";
    public static final String TOKEN = "token";
    public static final int MALE = 0;
    public static final int FEMALE = 1;

    private static User currentUser;

    private int id;
    private String username;
    private String email;
    private String nombre;
    private int genero;
    private String token;

    // region Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getGenero() {
        return genero;
    }

    public void setGenero(int genero) {
        this.genero = genero;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
    // endregion

    // region Properties
    public String getFirstName() {
        String defaultFirstName = FocusApp.getAppResources().getQuantityString(R.plurals.user, genero);
        String[] names = ((nombre == null) ? defaultFirstName : nombre).split(" ");

        return (names.length > 0) ? names[0] : defaultFirstName;
    }
    // endregion

    // region Utility methods
    public static void setCurrentUser(User user) {
        currentUser = user;
    }

    public static User getCurrentUser() {
        return currentUser;
    }
    // endregion
}
