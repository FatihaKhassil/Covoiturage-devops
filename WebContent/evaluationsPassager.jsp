<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Passager" %>
<%@ page import="models.Evaluation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%
    Passager passager = (Passager) session.getAttribute("utilisateur");
    
    // Récupération sécurisée des attributs
    List<Evaluation> evaluations = (List<Evaluation>) request.getAttribute("evaluations");
    Integer totalEvaluations = (Integer) request.getAttribute("totalEvaluations");
    Double noteMoyenne = (Double) request.getAttribute("noteMoyenne");
    int[] distributionNotes = (int[]) request.getAttribute("distributionNotes");
    
    if (evaluations == null) evaluations = new ArrayList<>();
    if (totalEvaluations == null) totalEvaluations = 0;
    if (noteMoyenne == null) noteMoyenne = 0.0;
    if (distributionNotes == null) distributionNotes = new int[6];
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
    SimpleDateFormat dateCourtFormat = new SimpleDateFormat("dd/MM/yyyy");
    
    // Calculer les pourcentages
    double[] pourcentages = new double[6];
    for (int i = 1; i <= 5; i++) {
        pourcentages[i] = totalEvaluations > 0 ? (distributionNotes[i] * 100.0) / totalEvaluations : 0.0;
    }
%>

<%!
    private String genererEtoiles(int note) {
        StringBuilder etoiles = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            etoiles.append(i <= note ? "★" : "☆");
        }
        return etoiles.toString();
    }
    
    private String formaterDate(java.util.Date date) {
        if (date == null) return "Date inconnue";
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
            return dateFormat.format(date);
        } catch (Exception e) {
            return "Date invalide";
        }
    }
    
    private String formaterDateCourt(java.util.Date date) {
        if (date == null) return "";
        try {
            SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
            return format.format(date);
        } catch (Exception e) {
            return "";
        }
    }
%>

<style>
.evaluations-container {
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    overflow: hidden;
}

.evaluations-summary {
    padding: 30px;
    border-bottom: 1px solid #e9ecef;
}

.summary-grid {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 30px;
    align-items: center;
}

.rating-overview {
    text-align: center;
}

.rating-score {
    font-size: 64px;
    font-weight: bold;
    color: #667eea;
    margin-bottom: 10px;
}

.rating-stars {
    font-size: 32px;
    color: #f39c12;
    margin-bottom: 10px;
}

.rating-count {
    color: #6c757d;
    font-size: 14px;
}

.rating-bar-item {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-bottom: 12px;
}

.rating-bar-label {
    display: flex;
    align-items: center;
    gap: 5px;
    min-width: 80px;
    font-size: 14px;
    color: #2c3e50;
}

.rating-bar-container {
    flex: 1;
    height: 10px;
    background: #e9ecef;
    border-radius: 5px;
    overflow: hidden;
}

.rating-bar-fill {
    height: 100%;
    background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
    border-radius: 5px;
    transition: width 0.3s;
}

.rating-bar-count {
    min-width: 40px;
    text-align: right;
    font-size: 14px;
    color: #6c757d;
}

.evaluations-list {
    padding: 30px;
}

.evaluation-card {
    background: #f8f9fa;
    border-radius: 10px;
    padding: 25px;
    margin-bottom: 20px;
    border-left: 4px solid #667eea;
    transition: all 0.3s;
}

.evaluation-card:hover {
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    transform: translateY(-2px);
}

.evaluation-header {
    display: flex;
    justify-content: space-between;
    align-items: start;
    margin-bottom: 15px;
}

.evaluator-info {
    display: flex;
    align-items: center;
    gap: 15px;
}

.evaluator-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 18px;
    font-weight: bold;
}

.evaluator-details h4 {
    font-size: 16px;
    color: #2c3e50;
    margin-bottom: 5px;
}

.evaluation-date {
    font-size: 13px;
    color: #6c757d;
}

.evaluation-rating {
    display: flex;
    align-items: center;
    gap: 10px;
}

.stars {
    color: #f39c12;
    font-size: 18px;
}

.rating-number {
    font-size: 16px;
    font-weight: bold;
    color: #2c3e50;
}

.evaluation-trajet {
    background: white;
    padding: 12px 15px;
    border-radius: 8px;
    margin-bottom: 15px;
    font-size: 14px;
    color: #495057;
}

.trajet-route {
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 600;
    margin-bottom: 5px;
}

.trajet-date {
    color: #6c757d;
    font-size: 13px;
}

.evaluation-comment {
    color: #495057;
    line-height: 1.6;
    font-size: 15px;
    padding: 15px;
    background: white;
    border-radius: 8px;
    border-left: 3px solid #e9ecef;
}

.no-evaluations {
    text-align: center;
    padding: 60px 20px;
    color: #6c757d;
}

.no-evaluations i {
    font-size: 64px;
    margin-bottom: 20px;
    display: block;
    color: #dee2e6;
}
</style>

<div class="evaluations-container">
    <!-- Résumé des évaluations -->
    <div class="evaluations-summary">
        <div class="summary-grid">
            <div class="rating-overview">
                <div class="rating-score"><%= String.format("%.1f", noteMoyenne) %></div>
                <div class="rating-stars"><%= genererEtoiles(noteMoyenne.intValue()) %></div>
                <div class="rating-count">Basé sur <%= totalEvaluations %> évaluation(s)</div>
            </div>
            
            <div class="rating-bars">
                <% for (int i = 5; i >= 1; i--) { %>
                <div class="rating-bar-item">
                    <div class="rating-bar-label"><%= i %> ⭐</div>
                    <div class="rating-bar-container">
                        <div class="rating-bar-fill" style="width: <%= pourcentages[i] %>%;"></div>
                    </div>
                    <div class="rating-bar-count"><%= distributionNotes[i] %></div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Liste des évaluations -->
    <div class="evaluations-list">
        <h3 style="margin-bottom: 25px; color: #2c3e50;">Commentaires des Conducteurs</h3>
        
        <% if (evaluations.isEmpty()) { %>
        <div class="no-evaluations">
            <i>⭐</i>
            <h3>Aucune évaluation pour le moment</h3>
            <p>Les évaluations des conducteurs apparaîtront ici après vos premiers trajets.</p>
        </div>
        <% } else { %>
            <% for (Evaluation evaluation : evaluations) { %>
            <div class="evaluation-card">
                <div class="evaluation-header">
                    <div class="evaluator-info">
                        <div class="evaluator-avatar">
                            <%= evaluation.getEvaluateurPrenom() != null ? 
                                evaluation.getEvaluateurPrenom().substring(0, 1).toUpperCase() : "C" %>
                            <%= evaluation.getEvaluateurNom() != null ? 
                                evaluation.getEvaluateurNom().substring(0, 1).toUpperCase() : "D" %>
                        </div>
                        <div class="evaluator-details">
                            <h4><%= evaluation.getEvaluateurComplet() %></h4>
                            <div class="evaluation-date">Évalué le <%= formaterDate(evaluation.getDateEvaluation()) %></div>
                        </div>
                    </div>
                    <div class="evaluation-rating">
                        <span class="stars"><%= genererEtoiles(evaluation.getNote()) %></span>
                        <span class="rating-number"><%= evaluation.getNote() %>.0</span>
                    </div>
                </div>
                
                <div class="evaluation-trajet">
                    <div class="trajet-route">
                        <span>📍</span>
                        <span><%= evaluation.getTrajetComplet() %></span>
                    </div>
                    <div class="trajet-date">
                        Trajet du <%= formaterDateCourt(evaluation.getDateDepart()) %>
                    </div>
                </div>
                
                <% if (evaluation.getCommentaire() != null && !evaluation.getCommentaire().trim().isEmpty()) { %>
                <div class="evaluation-comment">
                    "<%= evaluation.getCommentaire() %>"
                </div>
                <% } %>
            </div>
            <% } %>
        <% } %>
    </div>
</div>