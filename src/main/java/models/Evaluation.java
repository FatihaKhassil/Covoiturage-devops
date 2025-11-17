package models;

import java.util.Date;
import java.util.Objects;

/**
 * Classe représentant une évaluation entre utilisateurs après un trajet terminé.
 * 
 * Structure de la table evaluation dans la base de données :
 * - id_evaluation (BIGINT, PK, AUTO_INCREMENT)
 * - id_reservation (BIGINT, FK -> reservation)
 * - id_evaluateur (BIGINT, FK -> utilisateur)
 * - id_evalue (BIGINT, FK -> utilisateur)
 * - note (INT, CHECK 1-5)
 * - commentaire (TEXT)
 * - date_evaluation (TIMESTAMP)
 */
public class Evaluation {
    
    // ============================================
    // ATTRIBUTS DE BASE (correspondent aux colonnes de la BD)
    // ============================================
    private Long idEvaluation;
    private Long idReservation;   // ID de la réservation évaluée
    private Long idEvaluateur;    // ID de celui qui évalue
    private Long idEvalue;        // ID de celui qui est évalué
    private Integer note;         // Note de 1 à 5
    private String commentaire;   // Commentaire optionnel
    private Date dateEvaluation;  // Date de l'évaluation
    
    // ============================================
    // OBJETS COMPLETS (pour faciliter l'utilisation)
    // ============================================
    private Utilisateur evaluateur;    // Objet complet de l'évaluateur
    private Utilisateur evalue;        // Objet complet de l'évalué
    private Reservation reservation;   // Objet complet de la réservation
    
    // ============================================
    // CONSTRUCTEURS
    // ============================================
    
    /**
     * Constructeur par défaut
     */
    public Evaluation() {
        this.dateEvaluation = new Date();
    }
    
    /**
     * Constructeur avec IDs uniquement (pour compatibilité)
     */
    public Evaluation(Long idReservation, Long idEvaluateur, Long idEvalue,
                      Integer note, String commentaire) {
        this.idReservation = idReservation;
        this.idEvaluateur = idEvaluateur;
        this.idEvalue = idEvalue;
        this.note = note;
        this.commentaire = commentaire;
        this.dateEvaluation = new Date();
    }
    
    /**
     * Constructeur complet (utile pour le mapping JDBC)
     */
    public Evaluation(Long idEvaluation, Long idReservation, Long idEvaluateur,
                      Long idEvalue, Integer note, String commentaire, Date dateEvaluation) {
        this.idEvaluation = idEvaluation;
        this.idReservation = idReservation;
        this.idEvaluateur = idEvaluateur;
        this.idEvalue = idEvalue;
        this.note = note;
        this.commentaire = commentaire;
        this.dateEvaluation = dateEvaluation;
    }
    
    /**
     * Constructeur avec objets complets (RECOMMANDÉ pour les servlets)
     */
    public Evaluation(Reservation reservation, Utilisateur evaluateur, 
                      Utilisateur evalue, Integer note, String commentaire) {
        this.reservation = reservation;
        this.evaluateur = evaluateur;
        this.evalue = evalue;
        
        // Extraire les IDs des objets
        if (reservation != null) {
            this.idReservation = reservation.getIdReservation();
        }
        if (evaluateur != null) {
            this.idEvaluateur = evaluateur.getIdUtilisateur();
        }
        if (evalue != null) {
            this.idEvalue = evalue.getIdUtilisateur();
        }
        
        this.note = note;
        this.commentaire = commentaire;
        this.dateEvaluation = new Date();
    }
    
    // ============================================
    // MÉTHODES MÉTIER
    // ============================================
    
    /**
     * Valider que la note est entre 1 et 5
     */
    public boolean validerNote() {
        return note != null && note >= 1 && note <= 5;
    }
    
    /**
     * Modifier une évaluation existante
     */
    public void modifier(Integer nouvelleNote, String nouveauCommentaire) {
        if (nouvelleNote != null && nouvelleNote >= 1 && nouvelleNote <= 5) {
            this.note = nouvelleNote;
        }
        if (nouveauCommentaire != null && !nouveauCommentaire.trim().isEmpty()) {
            this.commentaire = nouveauCommentaire.trim();
        }
    }
    
    /**
     * Vérifier si l'évaluation est complète et valide
     */
    public boolean estComplete() {
        return note != null && 
               idEvaluateur != null && 
               idEvalue != null && 
               idReservation != null &&
               validerNote();
    }
    
    /**
     * Obtenir le type d'évaluateur (Conducteur ou Passager)
     */
    public String getTypeEvaluateur() {
        if (evaluateur instanceof Conducteur) {
            return "Conducteur";
        } else if (evaluateur instanceof Passager) {
            return "Passager";
        }
        return "Inconnu";
    }
    
    /**
     * Obtenir un résumé textuel de la note
     */
    public String getNoteTexte() {
        if (note == null) return "Non noté";
        switch (note) {
            case 5: return "Excellent";
            case 4: return "Très bien";
            case 3: return "Bien";
            case 2: return "Moyen";
            case 1: return "Mauvais";
            default: return "Invalide";
        }
    }
    
    /**
     * Vérifier si l'évaluation a un commentaire
     */
    public boolean aCommentaire() {
        return commentaire != null && !commentaire.trim().isEmpty();
    }
    
    /**
     * Obtenir les étoiles visuelles (pour affichage JSP)
     */
    public String getEtoiles() {
        if (note == null) return "☆☆☆☆☆";
        StringBuilder etoiles = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            etoiles.append(i <= note ? "⭐" : "☆");
        }
        return etoiles.toString();
    }
    
    /**
     * Obtenir un résumé court de l'évaluation
     */
    public String getResume() {
        StringBuilder sb = new StringBuilder();
        sb.append(getEtoiles()).append(" - ");
        sb.append(getNoteTexte());
        if (aCommentaire()) {
            sb.append(" - \"").append(commentaire.substring(0, Math.min(50, commentaire.length())));
            if (commentaire.length() > 50) {
                sb.append("...");
            }
            sb.append("\"");
        }
        return sb.toString();
    }
    
    // ============================================
    // GETTERS ET SETTERS
    // ============================================
    
    public Long getIdEvaluation() {
        return idEvaluation;
    }

    public void setIdEvaluation(Long idEvaluation) {
        this.idEvaluation = idEvaluation;
    }

    public Long getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(Long idReservation) {
        this.idReservation = idReservation;
    }

    public Long getIdEvaluateur() {
        return idEvaluateur;
    }

    public void setIdEvaluateur(Long idEvaluateur) {
        this.idEvaluateur = idEvaluateur;
    }

    public Long getIdEvalue() {
        return idEvalue;
    }

    public void setIdEvalue(Long idEvalue) {
        this.idEvalue = idEvalue;
    }

    public Integer getNote() {
        return note;
    }

    public void setNote(Integer note) {
        this.note = note;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public Date getDateEvaluation() {
        return dateEvaluation;
    }

    public void setDateEvaluation(Date dateEvaluation) {
        this.dateEvaluation = dateEvaluation;
    }

    // ============================================
    // GETTERS/SETTERS pour les objets complets
    // ============================================
    
    public Utilisateur getEvaluateur() {
        return evaluateur;
    }

    public void setEvaluateur(Utilisateur evaluateur) {
        this.evaluateur = evaluateur;
        // Synchroniser l'ID
        if (evaluateur != null) {
            this.idEvaluateur = evaluateur.getIdUtilisateur();
        }
    }

    public Utilisateur getEvalue() {
        return evalue;
    }

    public void setEvalue(Utilisateur evalue) {
        this.evalue = evalue;
        // Synchroniser l'ID
        if (evalue != null) {
            this.idEvalue = evalue.getIdUtilisateur();
        }
    }

    public Reservation getReservation() {
        return reservation;
    }

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
        // Synchroniser l'ID
        if (reservation != null) {
            this.idReservation = reservation.getIdReservation();
        }
    }

    // ============================================
    // MÉTHODES STANDARD (equals, hashCode, toString)
    // ============================================
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Evaluation)) return false;
        Evaluation that = (Evaluation) o;
        return Objects.equals(idEvaluation, that.idEvaluation);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idEvaluation);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Evaluation{");
        sb.append("idEvaluation=").append(idEvaluation);
        sb.append(", idReservation=").append(idReservation);
        sb.append(", note=").append(note).append("/5 (").append(getNoteTexte()).append(")");
        
        // Afficher l'évaluateur
        if (evaluateur != null) {
            sb.append(", evaluateur=").append(evaluateur.getPrenom())
              .append(" ").append(evaluateur.getNom())
              .append(" (").append(getTypeEvaluateur()).append(")");
        } else {
            sb.append(", idEvaluateur=").append(idEvaluateur);
        }
        
        // Afficher l'évalué
        if (evalue != null) {
            sb.append(", evalue=").append(evalue.getPrenom())
              .append(" ").append(evalue.getNom());
        } else {
            sb.append(", idEvalue=").append(idEvalue);
        }
        
        // Afficher le commentaire s'il existe
        if (aCommentaire()) {
            sb.append(", commentaire='").append(commentaire).append("'");
        }
        
        sb.append(", dateEvaluation=").append(dateEvaluation);
        sb.append("}");
        return sb.toString();
    }
}