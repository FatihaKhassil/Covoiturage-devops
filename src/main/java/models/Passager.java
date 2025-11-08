
package models;

import java.util.List;

public class Passager extends Utilisateur {
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
    
    // Méthodes métier
    public List<Offre> rechercherOffres(String criteres) {
        // Logique de recherche d'offres
        return null;
    }
    
    public Reservation reserverPlace(Offre offre, Integer nbPlaces) {
        // Logique de réservation de place
        return null;
    }
    
    public Boolean annulerReservation(Long reservationId) {
        // Logique d'annulation de réservation
        return true;
    }
    
    public List<Reservation> consulterHistorique() {
        // Logique de consultation de l'historique
        return null;
    }
    
    public List<Evaluation> getEvaluations() {
        // Logique de récupération des évaluations
        return null;
    }
    
    public Double calculerNoteMoyenne() {
        // Logique de calcul de la note moyenne
        return this.noteMoyenne;
    }
    
    // Getters et Setters
    public Double getNoteMoyenne() {
        return noteMoyenne;
    }
    
    public void setNoteMoyenne(Double noteMoyenne) {
        this.noteMoyenne = noteMoyenne;
    }
}
