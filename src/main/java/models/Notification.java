package models;

import java.util.Date;

public class Notification {
    private Long idNotification;
    private Long idUtilisateur;
    private String message;
    private Date dateEnvoi;
    private Boolean estLue;
    
    
    public Notification() {
        this.dateEnvoi = new Date();
        this.estLue = false;
    }
    
    
    public Notification(Long idUtilisateur, String message) {
        this();
        this.idUtilisateur = idUtilisateur;
        this.message = message;
    }
    
    
    public void envoyer() {
        
        this.dateEnvoi = new Date();
    }
    
   
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