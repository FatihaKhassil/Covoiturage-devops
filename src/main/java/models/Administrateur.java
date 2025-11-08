package models;

import java.util.Map;

public class Administrateur extends Utilisateur {
    
    // Constructeur par défaut
    public Administrateur() {
        super();
    }
    
    // Constructeur avec paramètres
    public Administrateur(String nom, String prenom, String email, String motDePasse, String telephone) {
        super(nom, prenom, email, motDePasse, telephone);
    }
    
    // Méthodes métier
    public Boolean validerOffre(Long offreId) {
        // Logique de validation d'offre
        return true;
    }
    
    public Boolean rejeterOffre(Long offreId, String motif) {
        // Logique de rejet d'offre
        return true;
    }
    
    public Boolean bloquerUtilisateur(Long userId) {
        // Logique de blocage d'utilisateur
        return true;
    }
    
    public Boolean debloquerUtilisateur(Long userId) {
        // Logique de déblocage d'utilisateur
        return true;
    }
    
    public Rapport genererRapport(String type, String periode) {
        // Logique de génération de rapport
        return null;
    }
    
    public Map<String, Object> consulterStatistiques() {
        // Logique de consultation des statistiques
        return null;
    }
}

// Classe Rapport (simple POJO)
class Rapport {
    private String type;
    private String periode;
    private String contenu;
    
    public Rapport() {}
    
    public Rapport(String type, String periode, String contenu) {
        this.type = type;
        this.periode = periode;
        this.contenu = contenu;
    }
    
    // Getters et Setters
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public String getPeriode() {
        return periode;
    }
    
    public void setPeriode(String periode) {
        this.periode = periode;
    }
    
    public String getContenu() {
        return contenu;
    }
    
    public void setContenu(String contenu) {
        this.contenu = contenu;
    }
}