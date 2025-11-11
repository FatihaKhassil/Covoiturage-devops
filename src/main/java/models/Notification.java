package models;

import java.util.Date;

public class Notification {
    private Long idNotification;
    private Long idUtilisateur;
    private String message;
    private Date dateEnvoi;
    private Boolean estLue;
    
    // Constructeur par défaut
    public Notification() {
        this.dateEnvoi = new Date();
        this.estLue = false;
    }
    
    // Constructeur avec paramètres
    public Notification(Long idUtilisateur, String message) {
        this();
        this.idUtilisateur = idUtilisateur;
        this.message = message;
    }
    
    // Méthodes métier
    public void envoyer() {
        // Logique d'envoi de notification
        this.dateEnvoi = new Date();
    }
    
    // Getters et Setters
    public Long getIdNotification() {
        return idNotification;
    }
    
    public void setIdNotification(Long idNotification) {
        this.idNotification = idNotification;
    }
    
    public Long getIdUtilisateur() {
        return idUtilisateur;
    }
    
    public void setIdUtilisateur(Long idUtilisateur) {
        this.idUtilisateur = idUtilisateur;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public Date getDateEnvoi() {
        return dateEnvoi;
    }
    
    public void setDateEnvoi(Date dateEnvoi) {
        this.dateEnvoi = dateEnvoi;
    }
    
    public Boolean getEstLue() {
        return estLue;
    }
    
    public void setEstLue(Boolean estLue) {
        this.estLue = estLue;
    }
}