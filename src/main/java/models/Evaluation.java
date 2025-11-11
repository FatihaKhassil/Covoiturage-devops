package models;

import java.util.Date;
import java.util.Objects;

public class Evaluation {
    private Long idEvaluation;
    private Long idOffre;
    private Long idEvaluateur;
    private Long idEvalue;
    private Integer note;
    private String commentaire;
    private Date dateEvaluation;

    // ✅ Constructeur par défaut
    public Evaluation() {
        this.dateEvaluation = new Date(); // Par défaut, date du jour
    }

    // ✅ Constructeur avec paramètres (sans idEvaluation)
    public Evaluation(Long idOffre, Long idEvaluateur, Long idEvalue,
                      Integer note, String commentaire) {
        this.idOffre = idOffre;
        this.idEvaluateur = idEvaluateur;
        this.idEvalue = idEvalue;
        this.note = note;
        this.commentaire = commentaire;
        this.dateEvaluation = new Date();
    }

    // ✅ Constructeur complet (utile pour le mapping JDBC)
    public Evaluation(Long idEvaluation, Long idOffre, Long idEvaluateur,
                      Long idEvalue, Integer note, String commentaire, Date dateEvaluation) {
        this.idEvaluation = idEvaluation;
        this.idOffre = idOffre;
        this.idEvaluateur = idEvaluateur;
        this.idEvalue = idEvalue;
        this.note = note;
        this.commentaire = commentaire;
        this.dateEvaluation = dateEvaluation;
    }

    // ✅ Méthode métier : valider la note
    public boolean validerNote() {
        return note != null && note >= 1 && note <= 5;
    }

    // ✅ Méthode pour modifier une évaluation
    public void modifier(Integer nouvelleNote, String nouveauCommentaire) {
        if (nouvelleNote != null) this.note = nouvelleNote;
        if (nouveauCommentaire != null && !nouveauCommentaire.trim().isEmpty()) {
            this.commentaire = nouveauCommentaire.trim();
        }
    }

    // ✅ Getters et Setters
    public Long getIdEvaluation() {
        return idEvaluation;
    }

    public void setIdEvaluation(Long idEvaluation) {
        this.idEvaluation = idEvaluation;
    }

    public Long getIdOffre() {
        return idOffre;
    }

    public void setIdOffre(Long idOffre) {
        this.idOffre = idOffre;
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

    // ✅ Redéfinition equals() et hashCode() pour comparer les objets proprement
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

    // ✅ Redéfinition toString() pour faciliter le débogage
    @Override
    public String toString() {
        return "Evaluation{" +
                "idEvaluation=" + idEvaluation +
                ", idOffre=" + idOffre +
                ", idEvaluateur=" + idEvaluateur +
                ", idEvalue=" + idEvalue +
                ", note=" + note +
                ", commentaire='" + commentaire + '\'' +
                ", dateEvaluation=" + dateEvaluation +
                '}';
    }
}
