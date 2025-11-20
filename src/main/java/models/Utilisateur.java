package models;

import java.util.Date;

public class Utilisateur {
    private Long idUtilisateur;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse;
    private String telephone;
    private Date dateInscription;
    private Boolean estActif;
    private String photoProfil; 

    // Constructeur par défaut
    public Utilisateur() {
        this.estActif = true;
        this.dateInscription = new Date();
    }
    
    // Constructeur avec paramètres
    public Utilisateur(String nom, String prenom, String email, String motDePasse, String telephone) {
        this();
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.telephone = telephone;
    }
    
    // Méthodes métier
    public Boolean seConnecter(String email, String mdp) {
        return this.email.equals(email) && this.motDePasse.equals(mdp) && this.estActif;
    }
    
    public void mettreAJourProfil() {
       
    }
    
    // Getters et Setters
    public Long getIdUtilisateur() {
        return idUtilisateur;
    }
    
    public void setIdUtilisateur(Long idUtilisateur) {
        this.idUtilisateur = idUtilisateur;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public String getPrenom() {
        return prenom;
    }
    
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getMotDePasse() {
        return motDePasse;
    }
    
    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }
    
    public String getTelephone() {
        return telephone;
    }
    
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
    
    public Date getDateInscription() {
        return dateInscription;
    }
    
    public void setDateInscription(Date dateInscription) {
        this.dateInscription = dateInscription;
    }
    
    public Boolean getEstActif() {
        return estActif;
    }
    
    public void setEstActif(Boolean estActif) {
        this.estActif = estActif;
    }
    public String getPhotoProfil() {
        return photoProfil;
    }
    
    public void setPhotoProfil(String photoProfil) {
        this.photoProfil = photoProfil;
    }
    
    
    public String getPhotoProfilUrl() {
        if (photoProfil == null || photoProfil.isEmpty()) {
            return "images/avatars/default-avatar.png";
        }
        return photoProfil;
    }
    
    public String getInitiales() {
        if (prenom != null && !prenom.isEmpty() && nom != null && !nom.isEmpty()) {
            return (prenom.substring(0, 1) + nom.substring(0, 1)).toUpperCase();
        }
        return "U";
    }
}