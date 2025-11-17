<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur" %>
<%@ page import="models.Evaluation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    
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
    
    // Calculer les pourcentages pour les barres de progression
    double[] pourcentages = new double[6];
    for (int i = 1; i <= 5; i++) {
        if (totalEvaluations > 0) {
            pourcentages[i] = (distributionNotes[i] * 100.0) / totalEvaluations;
        } else {
            pourcentages[i] = 0.0;
        }
    }
%>

<%!
    // Déclaration des fonctions en dehors du scriptlet principal
    private String genererEtoiles(int note) {
        StringBuilder etoiles = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= note) {
                etoiles.append("★");
            } else {
                etoiles.append("☆");
            }
        }
        return etoiles.toString();
    }
    
    private String getInitiales(String prenom, String nom) {
        if (prenom == null && nom == null) return "??";
        if (prenom != null && nom != null) {
            return (prenom.substring(0, 1) + nom.substring(0, 1)).toUpperCase();
        } else if (prenom != null) {
            return prenom.substring(0, Math.min(2, prenom.length())).toUpperCase();
        } else {
            return nom.substring(0, Math.min(2, nom.length())).toUpperCase();
        }
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
    
    private String getCommentaireSecurise(String commentaire) {
        if (commentaire == null || commentaire.trim().isEmpty()) {
            return "Aucun commentaire laissé";
        }
        return commentaire;
    }
    
    private String getNomComplet(String prenom, String nom) {
        if (prenom != null && nom != null) {
            return prenom + " " + nom;
        } else if (prenom != null) {
            return prenom;
        } else if (nom != null) {
            return nom;
        } else {
            return "Passager";
        }
    }
%>

<style>
    .evaluations-summary {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        margin-bottom: 30px;
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
    
    .rating-bars {
        flex: 1;
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
    
    .filter-section {
        background: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .filter-controls {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
    }
    
    .filter-item {
        flex: 1;
        min-width: 200px;
    }
    
    .filter-item label {
        display: block;
        font-size: 13px;
        color: #666;
        margin-bottom: 5px;
        font-weight: 600;
    }
    
    .filter-item select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
    }
    
    .evaluations-list {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .evaluation-card {
        background: #f8f9fa;
        border-radius: 10px;
        padding: 25px;
        margin-bottom: 20px;
        transition: all 0.3s;
        border-left: 4px solid #667eea;
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
    
    .evaluation-aspects {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 10px;
        margin-top: 15px;
    }
    
    .aspect-item {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 13px;
        color: #6c757d;
    }
    
    .aspect-icon {
        font-size: 16px;
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

<div class="top-bar">
    <div>
        <h1>Évaluations Reçues</h1>
        <div class="breadcrumb">Accueil / Évaluations</div>
    </div>
</div>

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

<!-- Filtres -->
<div class="filter-section">
    <div class="filter-controls">
        <div class="filter-item">
            <label>Note</label>
            <select id="filterRating">
                <option value="all">Toutes les notes</option>
                <option value="5">5 étoiles</option>
                <option value="4">4 étoiles et plus</option>
                <option value="3">3 étoiles et plus</option>
                <option value="2">2 étoiles et plus</option>
            </select>
        </div>
        <div class="filter-item">
            <label>Période</label>
            <select id="filterPeriod">
                <option value="all">Toute la période</option>
                <option value="month">Ce mois-ci</option>
                <option value="3months">3 derniers mois</option>
                <option value="year">Cette année</option>
            </select>
        </div>
        <div class="filter-item">
            <label>Trier par</label>
            <select id="filterSort">
                <option value="recent">Plus récentes</option>
                <option value="oldest">Plus anciennes</option>
                <option value="highest">Note la plus haute</option>
                <option value="lowest">Note la plus basse</option>
            </select>
        </div>
    </div>
</div>

<!-- Liste des évaluations -->
<div class="evaluations-list">
    <div class="section-header">
        <h2>Commentaires des Passagers (<%= totalEvaluations %>)</h2>
    </div>
    
    <% if (evaluations.isEmpty()) { %>
    <div class="no-evaluations">
        <i>⭐</i>
        <h3>Aucune évaluation pour le moment</h3>
        <p>Les évaluations des passagers apparaîtront ici après vos premiers trajets.</p>
    </div>
    <% } else { %>
        <% for (Evaluation evaluation : evaluations) { 
            if (evaluation != null) {
                String nomPassager = getNomComplet(evaluation.getEvaluateurPrenom(), evaluation.getEvaluateurNom());
                String initiales = getInitiales(evaluation.getEvaluateurPrenom(), evaluation.getEvaluateurNom());
        %>
        <div class="evaluation-card">
            <div class="evaluation-header">
                <div class="evaluator-info">
                    <div class="evaluator-avatar">
                        <%= initiales %>
                    </div>
                    <div class="evaluator-details">
                        <h4><%= nomPassager %></h4>
                        <div class="evaluation-date">🗓️ <%= formaterDate(evaluation.getDateEvaluation()) %></div>
                    </div>
                </div>
                <div class="evaluation-rating">
                    <span class="stars">
                        <% 
                            Integer note = evaluation.getNote();
                            if (note != null) {
                                out.print(genererEtoiles(note));
                            } else {
                                out.print("☆☆☆☆☆");
                            }
                        %>
                    </span>
                    <span class="rating-number">
                        <%= note != null ? note : 0 %>.0
                    </span>
                </div>
            </div>
            
            <div class="evaluation-trajet">
                <% if (evaluation.getVilleDepart() != null && evaluation.getVilleArrivee() != null) { %>
                    <div class="trajet-route">
                        <span>📍</span>
                        <span><%= evaluation.getVilleDepart() %> → <%= evaluation.getVilleArrivee() %></span>
                    </div>
                    <% if (evaluation.getDateDepart() != null) { %>
                        <div class="trajet-date">
                            Trajet du <%= dateCourtFormat.format(evaluation.getDateDepart()) %>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="trajet-route">
                        <span>📍</span>
                        <span>Trajet partagé</span>
                    </div>
                <% } %>
            </div>
            
            <div class="evaluation-comment">
                "<%= getCommentaireSecurise(evaluation.getCommentaire()) %>"
            </div>
            
            <div class="evaluation-aspects">
                <div class="aspect-item">
                    <span class="aspect-icon">⏰</span>
                    <span>Ponctualité</span>
                </div>
                <div class="aspect-item">
                    <span class="aspect-icon">🚗</span>
                    <span>Conduite sûre</span>
                </div>
                <div class="aspect-item">
                    <span class="aspect-icon">💬</span>
                    <span>Communication</span>
                </div>
                <div class="aspect-item">
                    <span class="aspect-icon">✨</span>
                    <span>Véhicule propre</span>
                </div>
            </div>
        </div>
        <% 
            } // fin du if evaluation != null
        } // fin de la boucle for
    } // fin du else 
    %>
</div>

<script>
    // Filtres
    document.getElementById('filterRating').addEventListener('change', function() {
        filtrerEvaluations();
    });
    
    document.getElementById('filterPeriod').addEventListener('change', function() {
        filtrerEvaluations();
    });
    
    document.getElementById('filterSort').addEventListener('change', function() {
        filtrerEvaluations();
    });
    
    function filtrerEvaluations() {
        const noteFiltre = document.getElementById('filterRating').value;
        const periodeFiltre = document.getElementById('filterPeriod').value;
        const triFiltre = document.getElementById('filterSort').value;
        
        // Recharger la page avec les paramètres de filtre
        const params = new URLSearchParams();
        params.append('page', 'evaluations');
        if (noteFiltre !== 'all') params.append('note', noteFiltre);
        if (periodeFiltre !== 'all') params.append('periode', periodeFiltre);
        if (triFiltre !== 'recent') params.append('tri', triFiltre);
        
        window.location.href = 'Conducteur?' + params.toString();
    }
    
    // Appliquer les filtres depuis l'URL
    window.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const note = urlParams.get('note');
        const periode = urlParams.get('periode');
        const tri = urlParams.get('tri');
        
        if (note) document.getElementById('filterRating').value = note;
        if (periode) document.getElementById('filterPeriod').value = periode;
        if (tri) document.getElementById('filterSort').value = tri;
    });
</script>