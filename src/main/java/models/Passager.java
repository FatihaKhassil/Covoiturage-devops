package models;

import java.util.List;

public class Passager extends Utilisateur {
    private Long idPassager;
    private Double noteMoyenne;
    
    // Constructeur par défaut
    public Passager() {
        super();
        this.noteMoyenne = 0.0;
    }
    
    // Constructeur avec paramètres
    public Passager(String nom, String prenom, String email, String motDePasse, String telephone) {
        super(nom, prenom, email, motDePasse, telephone);
        this.noteMoyenne = 0.0;
    }
    
    
    public Long getId() {
        if (this.idPassager != null) {
            return this.idPassager;
        }
        return this.getIdUtilisateur();
    }
    
    // Méthodes métier
    public List<Offre> rechercherOffres(String criteres) {
        return null;
    }
    
    public Reservation reserverPlace(Offre offre, Integer nbPlaces) {
        return null;
    }
    
    public Boolean annulerReservation(Long reservationId) {
        return true;
    }
    
    public List<Reservation> consulterHistorique() {
        return null;
    }
    
    public List<Evaluation> getEvaluations() {
        return null;
    }
    
    public Double calculerNoteMoyenne() {
        return this.noteMoyenne;
    }
    
    // Getters et Setters
    public Long getIdPassager() {
        return idPassager;
    }
    
    public void setIdPassager(Long idPassager) {
        this.idPassager = idPassager;
        if (idPassager != null) {
            this.setIdUtilisateur(idPassager);
        }
    }
    
    public Double getNoteMoyenne() {
        return noteMoyenne;
    }
    
    public void setNoteMoyenne(Double noteMoyenne) {
        this.noteMoyenne = noteMoyenne;
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Passager)) return false;
        Passager that = (Passager) o;
        Long thisId = this.getId();
        Long thatId = that.getId();
        return thisId != null && thisId.equals(thatId);
    }
    
    @Override
    public int hashCode() {
        Long id = this.getId();
        return id != null ? id.hashCode() : 0;
    }
    
    @Override
    public String toString() {
        return "Passager{" +
                "idPassager=" + idPassager +
                ", idUtilisateur=" + getIdUtilisateur() +
                ", nom='" + getNom() + '\'' +
                ", prenom='" + getPrenom() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", noteMoyenne=" + noteMoyenne +
                '}';
    }
}