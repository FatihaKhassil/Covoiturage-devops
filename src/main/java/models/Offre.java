package models;

import java.sql.Time;
import java.util.Date;

public class Offre {
    private Long idOffre;
    private Long idConducteur;
    private String villeDepart;
    private String villeArrivee;
    private Date dateDepart;
    private Time heureDepart;
    private Double prixParPlace;
    private Integer placesDisponibles;
    private Integer placesTotales;
    private String statut;
    private Date datePublication;
    private String commentaire;
    private Boolean estEffectuee;
    
    // Constructeur par défaut
    public Offre() {
        this.statut = "EN_ATTENTE";
        this.estEffectuee = false;
        this.datePublication = new Date();
    }
    
    // Constructeur avec paramètres
    public Offre(Long idConducteur, String villeDepart, String villeArrivee, 
                 Date dateDepart, Time heureDepart, Double prixParPlace, 
                 Integer placesTotales) {
        this();
        this.idConducteur = idConducteur;
        this.villeDepart = villeDepart;
        this.villeArrivee = villeArrivee;
        this.dateDepart = dateDepart;
        this.heureDepart = heureDepart;
        this.prixParPlace = prixParPlace;
        this.placesTotales = placesTotales;
        this.placesDisponibles = placesTotales;
    }
    
    // Méthodes métier
    public Boolean verifierDisponibilite(Integer nbPlaces) {
        return this.placesDisponibles >= nbPlaces;
    }
    
    public void mettreAJourPlaces(Integer nbPlaces) {
        this.placesDisponibles -= nbPlaces;
    }
    
    public Double calculerRevenuTotal() {
        return (this.placesTotales - this.placesDisponibles) * this.prixParPlace;
    }
    
    public void annuler() {
        this.statut = "ANNULEE";
    }
    
    public void terminer() {
        this.statut = "TERMINEE";
    }
    
    public void marquerCommeEffectuee() {
        this.estEffectuee = true;
    }
    
    // Getters et Setters
    public Long getIdOffre() {
        return idOffre;
    }
    
    public void setIdOffre(Long idOffre) {
        this.idOffre = idOffre;
    }
    
    public Long getIdConducteur() {
        return idConducteur;
    }
    
    public void setIdConducteur(Long idConducteur) {
        this.idConducteur = idConducteur;
    }
    
    public String getVilleDepart() {
        return villeDepart;
    }
    
    public void setVilleDepart(String villeDepart) {
        this.villeDepart = villeDepart;
    }
    
    public String getVilleArrivee() {
        return villeArrivee;
    }
    
    public void setVilleArrivee(String villeArrivee) {
        this.villeArrivee = villeArrivee;
    }
    
    public Date getDateDepart() {
        return dateDepart;
    }
    
    public void setDateDepart(Date dateDepart) {
        this.dateDepart = dateDepart;
    }
    
    public Time getHeureDepart() {
        return heureDepart;
    }
    
    public void setHeureDepart(Time heureDepart) {
        this.heureDepart = heureDepart;
    }
    
    public Double getPrixParPlace() {
        return prixParPlace;
    }
    
    public void setPrixParPlace(Double prixParPlace) {
        this.prixParPlace = prixParPlace;
    }
    
    public Integer getPlacesDisponibles() {
        return placesDisponibles;
    }
    
    public void setPlacesDisponibles(Integer placesDisponibles) {
        this.placesDisponibles = placesDisponibles;
    }
    
    public Integer getPlacesTotales() {
        return placesTotales;
    }
    
    public void setPlacesTotales(Integer placesTotales) {
        this.placesTotales = placesTotales;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    public Date getDatePublication() {
        return datePublication;
    }
    
    public void setDatePublication(Date datePublication) {
        this.datePublication = datePublication;
    }
    
    public String getCommentaire() {
        return commentaire;
    }
    
    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }
    
    public Boolean getEstEffectuee() {
        return estEffectuee;
    }
    
    public void setEstEffectuee(Boolean estEffectuee) {
        this.estEffectuee = estEffectuee;
    }
}