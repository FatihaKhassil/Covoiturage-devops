package models;

import java.util.List;

public class Conducteur extends Utilisateur {
    private String marqueVehicule;
    private String modeleVehicule;
    private String immatriculation;
    private Integer nombrePlacesVehicule;
    private Double noteMoyenne;
    
    // Constructeur par défaut
    public Conducteur() {
        super();
        this.noteMoyenne = 0.0;
    }
    
    // Constructeur avec paramètres
    public Conducteur(String nom, String prenom, String email, String motDePasse, 
                      String telephone, String marqueVehicule, String modeleVehicule, 
                      String immatriculation, Integer nombrePlacesVehicule) {
        super(nom, prenom, email, motDePasse, telephone);
        this.marqueVehicule = marqueVehicule;
        this.modeleVehicule = modeleVehicule;
        this.immatriculation = immatriculation;
        this.nombrePlacesVehicule = nombrePlacesVehicule;
        this.noteMoyenne = 0.0;
    }
    
    // Méthodes métier
    public Offre publierOffre(Offre offre) {
        // Logique de publication d'offre
        return offre;
    }
    
    public Boolean annulerOffre(Long offreId) {
        // Logique d'annulation d'offre
        return true;
    }
    
    public List<Reservation> consulterReservations() {
        // Logique de consultation des réservations
        return null;
    }
    
    public void validerTrajet(Long offreId) {
        // Logique de validation du trajet
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
    public String getMarqueVehicule() {
        return marqueVehicule;
    }
    
    public void setMarqueVehicule(String marqueVehicule) {
        this.marqueVehicule = marqueVehicule;
    }
    
    public String getModeleVehicule() {
        return modeleVehicule;
    }
    
    public void setModeleVehicule(String modeleVehicule) {
        this.modeleVehicule = modeleVehicule;
    }
    
    public String getImmatriculation() {
        return immatriculation;
    }
    
    public void setImmatriculation(String immatriculation) {
        this.immatriculation = immatriculation;
    }
    
    public Integer getNombrePlacesVehicule() {
        return nombrePlacesVehicule;
    }
    
    public void setNombrePlacesVehicule(Integer nombrePlacesVehicule) {
        this.nombrePlacesVehicule = nombrePlacesVehicule;
    }
    
    public Double getNoteMoyenne() {
        return noteMoyenne;
    }
    
    public void setNoteMoyenne(Double noteMoyenne) {
        this.noteMoyenne = noteMoyenne;
    }
}