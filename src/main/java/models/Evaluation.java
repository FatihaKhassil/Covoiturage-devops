package models;

import java.util.Date;

public class Evaluation {
    private Long idEvaluation;
    private Long idOffre;
    private Long idEvaluateur;
    private Long idEvalue;
    private Integer note;
    private String commentaire;
    private Date dateEvaluation;
    private String typeEvaluateur;
    
    // Informations supplémentaires pour l'affichage
    private String evaluateurNom;
    private String evaluateurPrenom;
    private String villeDepart;
    private String villeArrivee;
    private Date dateDepart;

    // Constructeurs
    public Evaluation() {}
    
    public Evaluation(Long idEvaluation, Long idOffre, Long idEvaluateur, Long idEvalue, 
                     Integer note, String commentaire, Date dateEvaluation, String typeEvaluateur) {
        this.idEvaluation = idEvaluation;
        this.idOffre = idOffre;
        this.idEvaluateur = idEvaluateur;
        this.idEvalue = idEvalue;
        this.note = note;
        this.commentaire = commentaire;
        this.dateEvaluation = dateEvaluation;
        this.typeEvaluateur = typeEvaluateur;
    }

    // Getters et setters de base
    public Long getIdEvaluation() { return idEvaluation; }
    public void setIdEvaluation(Long idEvaluation) { this.idEvaluation = idEvaluation; }
    
    public Long getIdOffre() { return idOffre; }
    public void setIdOffre(Long idOffre) { this.idOffre = idOffre; }
    
    public Long getIdEvaluateur() { return idEvaluateur; }
    public void setIdEvaluateur(Long idEvaluateur) { this.idEvaluateur = idEvaluateur; }
    
    public Long getIdEvalue() { return idEvalue; }
    public void setIdEvalue(Long idEvalue) { this.idEvalue = idEvalue; }
    
    public Integer getNote() { return note; }
    public void setNote(Integer note) { this.note = note; }
    
    public String getCommentaire() { return commentaire; }
    public void setCommentaire(String commentaire) { this.commentaire = commentaire; }
    
    public Date getDateEvaluation() { return dateEvaluation; }
    public void setDateEvaluation(Date dateEvaluation) { this.dateEvaluation = dateEvaluation; }
    
    public String getTypeEvaluateur() { return typeEvaluateur; }
    public void setTypeEvaluateur(String typeEvaluateur) { this.typeEvaluateur = typeEvaluateur; }
    
    // ✅ AJOUTER TOUS LES NOUVEAUX GETTERS/SETTERS
    public String getEvaluateurNom() { return evaluateurNom; }
    public void setEvaluateurNom(String evaluateurNom) { this.evaluateurNom = evaluateurNom; }
    
    public String getEvaluateurPrenom() { return evaluateurPrenom; }
    public void setEvaluateurPrenom(String evaluateurPrenom) { this.evaluateurPrenom = evaluateurPrenom; }
    
    public String getVilleDepart() { return villeDepart; }
    public void setVilleDepart(String villeDepart) { this.villeDepart = villeDepart; }
    
    public String getVilleArrivee() { return villeArrivee; }
    public void setVilleArrivee(String villeArrivee) { this.villeArrivee = villeArrivee; }
    
    public Date getDateDepart() { return dateDepart; }
    public void setDateDepart(Date dateDepart) { this.dateDepart = dateDepart; }
    
    // Méthodes utilitaires
    public String getEvaluateurComplet() {
        if (evaluateurPrenom != null && evaluateurNom != null) {
            return evaluateurPrenom + " " + evaluateurNom;
        }
        return "Conducteur";
    }
    
    public String getTrajetComplet() {
        if (villeDepart != null && villeArrivee != null) {
            return villeDepart + " → " + villeArrivee;
        }
        return "Trajet non spécifié";
    }
}