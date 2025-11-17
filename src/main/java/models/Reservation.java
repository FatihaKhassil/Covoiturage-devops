package models;

import java.util.Date;

public class Reservation {
    private Long idReservation;
    private Offre offre;
    private Passager passager;
    private Integer nombrePlaces;
    private Double prixTotal;
    private Date dateReservation;
    private String statut;
    private String messagePassager;
    private Boolean estEvalue;
    private Evaluation evaluation;
    
    // Constructeur par défaut
    public Reservation() {
        this.statut = "CONFIRMEE";
        this.dateReservation = new Date();
    }
    
    // Constructeur avec paramètres
    public Reservation(Offre offre, Passager passager, Integer nombrePlaces, Double prixTotal) {
        this();
        this.offre = offre;
        this.passager = passager;
        this.nombrePlaces = nombrePlaces;
        this.prixTotal = prixTotal;
    }
    
    // Méthodes métier
    public Double calculerPrixTotal() {
        return this.prixTotal;
    }
    
    public void confirmer() {
        this.statut = "CONFIRMEE";
    }
    
    public Boolean annuler() {
        this.statut = "ANNULEE";
        return true;
    }
    
    public void terminer() {
        this.statut = "TERMINEE";
    }
    
    public boolean peutEtreAnnulee() {
        return "CONFIRMEE".equals(this.statut);
    }
    
    // Getters et Setters
    public Long getIdReservation() {
        return idReservation;
    }
    
    public void setIdReservation(Long idReservation) {
        this.idReservation = idReservation;
    }
    
    public Offre getOffre() {
        return offre;
    }
    
    public void setOffre(Offre offre) {
        this.offre = offre;
    }
    
    public Passager getPassager() {
        return passager;
    }
    
    public void setPassager(Passager passager) {
        this.passager = passager;
    }
    
    public Integer getNombrePlaces() {
        return nombrePlaces;
    }
    
    public void setNombrePlaces(Integer nombrePlaces) {
        this.nombrePlaces = nombrePlaces;
    }
    
    public Double getPrixTotal() {
        return prixTotal;
    }
    
    public void setPrixTotal(Double prixTotal) {
        this.prixTotal = prixTotal;
    }
    
    public Date getDateReservation() {
        return dateReservation;
    }
    
    public void setDateReservation(Date dateReservation) {
        this.dateReservation = dateReservation;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    public String getMessagePassager() {
        return messagePassager;
    }
    
    public void setMessagePassager(String messagePassager) {
        this.messagePassager = messagePassager;
    }
    public Boolean getEstEvalue() {
        return estEvalue;
    }
    
    public void setEstEvalue(Boolean estEvalue) {
        this.estEvalue = estEvalue;
    }
    
    public Evaluation getEvaluation() {
        return evaluation;
    }
    
    public void setEvaluation(Evaluation evaluation) {
        this.evaluation = evaluation;
    }

	public void setEstEvalue(boolean dejaEvalue) {
		// TODO Auto-generated method stub
		
	}}