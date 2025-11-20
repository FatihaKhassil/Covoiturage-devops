<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, models.Conducteur" %>
<%
    // Statistiques générales
    Integer totalOffres = (Integer) request.getAttribute("totalOffres");
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    Integer totalUtilisateurs = (Integer) request.getAttribute("totalUtilisateurs");
    Integer totalConducteurs = (Integer) request.getAttribute("totalConducteurs");
    Integer totalPassagers = (Integer) request.getAttribute("totalPassagers");
    
    // Statistiques offres
    Integer offresValidees = (Integer) request.getAttribute("offresValidees");
    Integer offresEnAttente = (Integer) request.getAttribute("offresEnAttente");
    Integer offresTerminees = (Integer) request.getAttribute("offresTerminees");
    Integer offresAnnulees = (Integer) request.getAttribute("offresAnnulees");
    
    // Statistiques réservations
    Integer reservationsConfirmees = (Integer) request.getAttribute("reservationsConfirmees");
    Integer reservationsTerminees = (Integer) request.getAttribute("reservationsTerminees");
    Integer reservationsAnnulees = (Integer) request.getAttribute("reservationsAnnulees");
    Integer reservationsEnAttente = (Integer) request.getAttribute("reservationsEnAttente");
    
    // Revenus
    Double revenuTotal = (Double) request.getAttribute("revenuTotal");
    Double revenuConfirme = (Double) request.getAttribute("revenuConfirme");
    Double revenuTermine = (Double) request.getAttribute("revenuTermine");
    Double revenuMoyenParReservation = (Double) request.getAttribute("revenuMoyenParReservation");
    
    // Évaluations
    Integer totalEvaluations = (Integer) request.getAttribute("totalEvaluations");
    Double satisfactionMoyenne = (Double) request.getAttribute("satisfactionMoyenne");
    Integer evaluations5etoiles = (Integer) request.getAttribute("evaluations5etoiles");
    Integer evaluations4etoiles = (Integer) request.getAttribute("evaluations4etoiles");
    Integer evaluations3etoiles = (Integer) request.getAttribute("evaluations3etoiles");
    Integer evaluations2etoiles = (Integer) request.getAttribute("evaluations2etoiles");
    Integer evaluations1etoile = (Integer) request.getAttribute("evaluations1etoile");
    
    // Taux
    Double tauxReussite = (Double) request.getAttribute("tauxReussite");
    Double tauxAnnulation = (Double) request.getAttribute("tauxAnnulation");
    Double tauxConversion = (Double) request.getAttribute("tauxConversion");
    Double ratioPassagersConducteurs = (Double) request.getAttribute("ratioPassagersConducteurs");
    
    // Période 30 jours
    Integer offres30j = (Integer) request.getAttribute("offres30j");
    Integer reservations30j = (Integer) request.getAttribute("reservations30j");
    Integer utilisateurs30j = (Integer) request.getAttribute("utilisateurs30j");
    Double revenus30j = (Double) request.getAttribute("revenus30j");
    
    // Moyennes
    Double moyennePlacesDisponibles = (Double) request.getAttribute("moyennePlacesDisponibles");
    Double moyennePlacesReservees = (Double) request.getAttribute("moyennePlacesReservees");
    
    // Top
    List<Conducteur> topConducteurs = (List<Conducteur>) request.getAttribute("topConducteurs");
    Map<Long, Integer> trajetsParConducteur = (Map<Long, Integer>) request.getAttribute("trajetsParConducteur");
    List<Map.Entry<String, Integer>> topTrajets = (List<Map.Entry<String, Integer>>) request.getAttribute("topTrajets");
    
    // Valeurs par défaut
    if (totalOffres == null) totalOffres = 0;
    if (totalReservations == null) totalReservations = 0;
    if (revenuTotal == null) revenuTotal = 0.0;
    if (satisfactionMoyenne == null) satisfactionMoyenne = 0.0;
    if (tauxReussite == null) tauxReussite = 0.0;
    if (tauxAnnulation == null) tauxAnnulation = 0.0;
    if (tauxConversion == null) tauxConversion = 0.0;
%>

<style>
    .rapport-container {
        display: grid;
        gap: 25px;
    }
    
    .rapport-section {
        background: white;
        padding: 30px;
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        border: 1px solid #f0f2f5;
    }
    
    .rapport-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f8f9fa;
    }
    
    .rapport-title {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .rapport-title h2 {
        font-size: 22px;
        color: #2c3e50;
        font-weight: 700;
        margin: 0;
    }
    
    .rapport-icon {
        width: 45px;
        height: 45px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        color: white;
    }
    
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 20px;
    }
    
    .stat-box {
        background: linear-gradient(135deg, #f8f9ff 0%, #ffffff 100%);
        padding: 20px;
        border-radius: 12px;
        border-left: 4px solid #667eea;
        transition: transform 0.3s;
    }
    
    .stat-box:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.15);
    }
    
    .stat-label {
        font-size: 13px;
        color: #6c757d;
        font-weight: 500;
        margin-bottom: 8px;
    }
    
    .stat-value {
        font-size: 28px;
        font-weight: 800;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    
    .stat-details {
        font-size: 12px;
        color: #8a94a6;
    }
    
    .progress-bar-container {
        background: #e9ecef;
        height: 10px;
        border-radius: 5px;
        overflow: hidden;
        margin: 10px 0;
    }
    
    .progress-bar {
        height: 100%;
        background: linear-gradient(90deg, #667eea, #764ba2);
        border-radius: 5px;
        transition: width 0.5s ease;
    }
    
    .top-list {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }
    
    .top-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 10px;
        transition: all 0.3s;
    }
    
    .top-item:hover {
        background: #e9ecef;
        transform: translateX(5px);
    }
    
    .top-item-rank {
        width: 35px;
        height: 35px;
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        margin-right: 15px;
    }
    
    .top-item-info {
        flex: 1;
    }
    
    .top-item-name {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 3px;
    }
    
    .top-item-detail {
        font-size: 12px;
        color: #6c757d;
    }
    
    .top-item-badge {
        background: #667eea;
        color: white;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
    }
    
    .evaluation-bars {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    
    .evaluation-bar-item {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .evaluation-label {
        width: 80px;
        font-size: 13px;
        color: #6c757d;
    }
    
    .evaluation-bar-bg {
        flex: 1;
        background: #e9ecef;
        height: 8px;
        border-radius: 4px;
        overflow: hidden;
    }
    
    .evaluation-bar-fill {
        height: 100%;
        background: #f39c12;
        border-radius: 4px;
        transition: width 0.5s ease;
    }
    
    .evaluation-count {
        width: 40px;
        text-align: right;
        font-size: 13px;
        font-weight: 600;
        color: #2c3e50;
    }
    
    .action-buttons {
        display: flex;
        gap: 10px;
    }
    
    .btn-export {
        padding: 10px 20px;
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-export:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
    }
</style>

<div class="top-bar">
    <div>
        <h1>Rapports Statistiques</h1>
        <div class="breadcrumb">Administration / Rapports</div>
    </div>
    <div class="action-buttons">
        <button class="btn-export" onclick="window.print()">📄 Exporter PDF</button>
    </div>
</div>

<div class="rapport-container">
    <!-- Vue d'ensemble -->
    <div class="rapport-section">
        <div class="rapport-header">
            <div class="rapport-title">
                <div class="rapport-icon">📊</div>
                <h2>Vue d'Ensemble</h2>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-box">
                <div class="stat-label">Total Offres</div>
                <div class="stat-value"><%= totalOffres %></div>
                <div class="stat-details">
                    Terminées: <%= offresTerminees %> • En attente: <%= offresEnAttente %>
                </div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Total Réservations</div>
                <div class="stat-value"><%= totalReservations %></div>
                <div class="stat-details">
                    Confirmées: <%= reservationsConfirmees %> • Terminées: <%= reservationsTerminees %>
                </div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Revenu Total</div>
                <div class="stat-value"><%= String.format("%.0f", revenuTotal) %> DH</div>
                <div class="stat-details">
                    Moyenne: <%= String.format("%.0f", revenuMoyenParReservation) %> DH/réservation
                </div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Satisfaction Moyenne</div>
                <div class="stat-value"><%= String.format("%.1f", satisfactionMoyenne) %>/5</div>
                <div class="stat-details">
                    <%= totalEvaluations %> évaluations reçues
                </div>
            </div>
        </div>
    </div>
    
    <!-- Taux de Performance -->
    <div class="rapport-section">
        <div class="rapport-header">
            <div class="rapport-title">
                <div class="rapport-icon">🎯</div>
                <h2>Indicateurs de Performance</h2>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-box">
                <div class="stat-label">Taux de Réussite</div>
                <div class="stat-value"><%= String.format("%.1f", tauxReussite) %>%</div>
                <div class="progress-bar-container">
                    <div class="progress-bar" style="width: <%= tauxReussite %>%; background: #28a745;"></div>
                </div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Taux de Conversion</div>
                <div class="stat-value"><%= String.format("%.1f", tauxConversion) %>%</div>
                <div class="progress-bar-container">
                    <div class="progress-bar" style="width: <%= tauxConversion > 100 ? 100 : tauxConversion %>%; background: #007bff;"></div>
                </div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Taux d'Annulation</div>
                <div class="stat-value"><%= String.format("%.1f", tauxAnnulation) %>%</div>
                <div class="progress-bar-container">
                    <div class="progress-bar" style="width: <%= tauxAnnulation %>%; background: #dc3545;"></div>
                </div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Ratio Passagers/Conducteurs</div>
                <div class="stat-value"><%= String.format("%.1f", ratioPassagersConducteurs) %>:1</div>
                <div class="stat-details">
                    <%= totalPassagers %> passagers / <%= totalConducteurs %> conducteurs
                </div>
            </div>
        </div>
    </div>
    
    <!-- Activité 30 Derniers Jours -->
    <div class="rapport-section">
        <div class="rapport-header">
            <div class="rapport-title">
                <div class="rapport-icon">📅</div>
                <h2>Activité - 30 Derniers Jours</h2>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-box">
                <div class="stat-label">Nouvelles Offres</div>
                <div class="stat-value"><%= offres30j %></div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Nouvelles Réservations</div>
                <div class="stat-value"><%= reservations30j %></div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Nouveaux Utilisateurs</div>
                <div class="stat-value"><%= utilisateurs30j %></div>
            </div>
            
            <div class="stat-box">
                <div class="stat-label">Revenus Générés</div>
                <div class="stat-value"><%= String.format("%.0f", revenus30j) %> DH</div>
            </div>
        </div>
    </div>
    
    <!-- Répartition des Évaluations -->
    <div class="rapport-section">
        <div class="rapport-header">
            <div class="rapport-title">
                <div class="rapport-icon">⭐</div>
                <h2>Répartition des Évaluations</h2>
            </div>
        </div>
        
        <div class="evaluation-bars">
            <div class="evaluation-bar-item">
                <div class="evaluation-label">⭐⭐⭐⭐⭐</div>
                <div class="evaluation-bar-bg">
                    <div class="evaluation-bar-fill" 
                         style="width: <%= totalEvaluations > 0 ? (evaluations5etoiles * 100 / totalEvaluations) : 0 %>%; background: #28a745;"></div>
                </div>
                <div class="evaluation-count"><%= evaluations5etoiles %></div>
            </div>
            
            <div class="evaluation-bar-item">
                <div class="evaluation-label">⭐⭐⭐⭐</div>
                <div class="evaluation-bar-bg">
                    <div class="evaluation-bar-fill" 
                         style="width: <%= totalEvaluations > 0 ? (evaluations4etoiles * 100 / totalEvaluations) : 0 %>%; background: #8BC34A;"></div>
                </div>
                <div class="evaluation-count"><%= evaluations4etoiles %></div>
            </div>
            
            <div class="evaluation-bar-item">
                <div class="evaluation-label">⭐⭐⭐</div>
                <div class="evaluation-bar-bg">
                    <div class="evaluation-bar-fill" 
                         style="width: <%= totalEvaluations > 0 ? (evaluations3etoiles * 100 / totalEvaluations) : 0 %>%; background: #FFC107;"></div>
                </div>
                <div class="evaluation-count"><%= evaluations3etoiles %></div>
            </div>
            
            <div class="evaluation-bar-item">
                <div class="evaluation-label">⭐⭐</div>
                <div class="evaluation-bar-bg">
                    <div class="evaluation-bar-fill" 
                         style="width: <%= totalEvaluations > 0 ? (evaluations2etoiles * 100 / totalEvaluations) : 0 %>%; background: #FF9800;"></div>
                </div>
                <div class="evaluation-count"><%= evaluations2etoiles %></div>
            </div>
            
            <div class="evaluation-bar-item">
                <div class="evaluation-label">⭐</div>
                <div class="evaluation-bar-bg">
                    <div class="evaluation-bar-fill" 
                         style="width: <%= totalEvaluations > 0 ? (evaluations1etoile * 100 / totalEvaluations) : 0 %>%; background: #F44336;"></div>
                </div>
                <div class="evaluation-count"><%= evaluations1etoile %></div>
            </div>
        </div>
    </div>
    
    <!-- Top Conducteurs & Trajets -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 25px;">
        <!-- Top Conducteurs -->
        <div class="rapport-section">
            <div class="rapport-header">
                <div class="rapport-title">
                    <div class="rapport-icon">🏆</div>
                    <h2>Top 5 Conducteurs</h2>
                </div>
            </div>
            
            <div class="top-list">
                <% if (topConducteurs != null && !topConducteurs.isEmpty()) { 
                    int rank = 1;
                    for (Conducteur conducteur : topConducteurs) {
                        Integer nbTrajets = trajetsParConducteur.get(conducteur.getIdUtilisateur());
                %>
                    <div class="top-item">
                        <div class="top-item-rank"><%= rank++ %></div>
                        <div class="top-item-info">
                            <div class="top-item-name"><%= conducteur.getPrenom() %> <%= conducteur.getNom() %></div>
                            <div class="top-item-detail"><%= conducteur.getEmail() %></div>
                        </div>
                        <div class="top-item-badge"><%= nbTrajets %> trajets</div>
                    </div>
                <% } 
                } else { %>
                    <div style="text-align: center; padding: 20px; color: #6c757d;">
                        Aucune donnée disponible
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- Top Trajets -->
        <div class="rapport-section">
            <div class="rapport-header">
                <div class="rapport-title">
                    <div class="rapport-icon">🗺️</div>
                    <h2>Top 5 Trajets</h2>
                </div>
            </div>
            
            <div class="top-list">
                <% if (topTrajets != null && !topTrajets.isEmpty()) { 
                    int rank = 1;
                    for (Map.Entry<String, Integer> entry : topTrajets) {
                %>
                    <div class="top-item">
                        <div class="top-item-rank"><%= rank++ %></div>
                        <div class="top-item-info">
                            <div class="top-item-name"><%= entry.getKey() %></div>
                            <div class="top-item-detail">Trajet populaire</div>
                        </div>
                        <div class="top-item-badge"><%= entry.getValue() %> résa.</div>
                    </div>
                <% } 
                } else { %>
                    <div style="text-align: center; padding: 20px; color: #6c757d;">
                        Aucune donnée disponible
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
    // Animation au chargement
    document.addEventListener('DOMContentLoaded', function() {
        const progressBars = document.querySelectorAll('.progress-bar, .evaluation-bar-fill');
        progressBars.forEach((bar, index) => {
            const width = bar.style.width;
            bar.style.width = '0';
            
            setTimeout(() => {
                bar.style.transition = 'width 1s ease-out';
                bar.style.width = width;
            }, index * 100);
        });
    });
</script>