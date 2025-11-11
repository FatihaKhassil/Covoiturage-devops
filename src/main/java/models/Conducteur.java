package models;

import java.util.List;

public class Conducteur extends Utilisateur {
    private Long idConducteur;
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
    
    // Constructeur avec paramètres (sans id)
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
    
    // Constructeur complet avec id
    public Conducteur(Long idConducteur, String nom, String prenom, String email, String motDePasse, 
                      String telephone, String marqueVehicule, String modeleVehicule, 
                      String immatriculation, Integer nombrePlacesVehicule, Double noteMoyenne) {
        super(nom, prenom, email, motDePasse, telephone);
        this.idConducteur = idConducteur;
        this.marqueVehicule = marqueVehicule;
        this.modeleVehicule = modeleVehicule;
        this.immatriculation = immatriculation;
        this.nombrePlacesVehicule = nombrePlacesVehicule;
        this.noteMoyenne = noteMoyenne != null ? noteMoyenne : 0.0;
    }
    
    // ✅ Méthode getId() corrigée - retourne idUtilisateur si idConducteur est null
    public Long getId() {
        // Si idConducteur est défini, le retourner
        if (this.idConducteur != null) {
            return this.idConducteur;
        }
        // Sinon, retourner idUtilisateur (hérité de Utilisateur)
        return this.getIdUtilisateur();
    }
    
    // Méthodes métier
    public Offre publierOffre(Offre offre) {
        return offre;
    }
    
    public Boolean annulerOffre(Long offreId) {
        return true;
    }
    
    public List<Reservation> consulterReservations() {
        return null;
    }
    
    public void validerTrajet(Long offreId) {
    }
    
    public List<Evaluation> getEvaluations() {
        return null;
    }
    
    public Double calculerNoteMoyenne() {
        return this.noteMoyenne;
    }
    
    // Getters et Setters
    public Long getIdConducteur() {
        return idConducteur;
    }
    
    public void setIdConducteur(Long idConducteur) {
        this.idConducteur = idConducteur;
        // Synchroniser avec idUtilisateur
        if (idConducteur != null) {
            this.setIdUtilisateur(idConducteur);
        }
    }
    
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
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Conducteur)) return false;
        Conducteur that = (Conducteur) o;
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
        return "Conducteur{" +
                "idConducteur=" + idConducteur +
                ", idUtilisateur=" + getIdUtilisateur() +
                ", nom='" + getNom() + '\'' +
                ", prenom='" + getPrenom() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", marqueVehicule='" + marqueVehicule + '\'' +
                ", modeleVehicule='" + modeleVehicule + '\'' +
                ", immatriculation='" + immatriculation + '\'' +
                ", nombrePlacesVehicule=" + nombrePlacesVehicule +
                ", noteMoyenne=" + noteMoyenne +
                '}';
    }
}