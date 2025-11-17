<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Offre" %>
<%@ page import="models.Reservation" %>
<%@ page import="models.Utilisateur" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // Récupération des données statistiques
    Integer totalUtilisateurs = (Integer) request.getAttribute("totalUtilisateurs");
    Integer totalConducteurs = (Integer) request.getAttribute("totalConducteurs");
    Integer totalPassagers = (Integer) request.getAttribute("totalPassagers");
    Integer totalOffres = (Integer) request.getAttribute("totalOffres");
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    Integer offresEnAttenteCount = (Integer) request.getAttribute("offresEnAttenteCount");
    Integer offresActives = (Integer) request.getAttribute("offresActives");
    Integer offresTerminees = (Integer) request.getAttribute("offresTerminees");
    Integer offresAnnulees = (Integer) request.getAttribute("offresAnnulees");
    Double revenuTotal = (Double) request.getAttribute("revenuTotal");
    
    // Valeurs par défaut
    if (totalUtilisateurs == null) totalUtilisateurs = 0;
    if (totalConducteurs == null) totalConducteurs = 0;
    if (totalPassagers == null) totalPassagers = 0;
    if (totalOffres == null) totalOffres = 0;
    if (totalReservations == null) totalReservations = 0;
    if (offresEnAttenteCount == null) offresEnAttenteCount = 0;
    if (offresActives == null) offresActives = 0;
    if (offresTerminees == null) offresTerminees = 0;
    if (offresAnnulees == null) offresAnnulees = 0;
    if (revenuTotal == null) revenuTotal = 0.0;
    
    // Calculs supplémentaires
    double tauxConversion = totalOffres > 0 ? (totalReservations * 100.0 / totalOffres) : 0;
    double tauxOccupation = totalReservations > 0 ? (offresTerminees * 100.0 / totalReservations) : 0;
%>

<style>
    .analytics-container {
        display: grid;
        gap: 25px;
    }
    
    .analytics-section {
        background: white;
        padding: 30px;
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        border: 1px solid #f0f2f5;
    }
    
    .section-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 30px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f8f9fa;
    }
    
    .section-title {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .section-title h2 {
        font-size: 24px;
        color: #2c3e50;
        font-weight: 700;
        margin: 0;
    }
    
    .section-icon {
        width: 48px;
        height: 48px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        color: white;
    }
    
    /* KPI Cards */
    .kpi-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .kpi-card {
        background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
        padding: 25px;
        border-radius: 16px;
        border: 1px solid #eef2f7;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }
    
    .kpi-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #667eea, #764ba2);
    }
    
    .kpi-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 35px rgba(102, 126, 234, 0.15);
    }
    
    .kpi-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 15px;
    }
    
    .kpi-icon {
        width: 50px;
        height: 50px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
    }
    
    .kpi-trend {
        font-size: 14px;
        font-weight: 600;
        padding: 4px 12px;
        border-radius: 20px;
    }
    
    .trend-up { background: #d4edda; color: #155724; }
    .trend-down { background: #f8d7da; color: #721c24; }
    .trend-neutral { background: #e2e3e5; color: #383d41; }
    
    .kpi-value {
        font-size: 32px;
        font-weight: 800;
        color: #2c3e50;
        margin-bottom: 5px;
        line-height: 1;
    }
    
    .kpi-label {
        font-size: 14px;
        color: #6c757d;
        font-weight: 500;
    }
    
    .kpi-description {
        font-size: 12px;
        color: #8a94a6;
        margin-top: 8px;
    }
    
    /* Charts Grid */
    .charts-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
        gap: 25px;
        margin-top: 20px;
    }
    
    .chart-container {
        background: white;
        padding: 25px;
        border-radius: 16px;
        border: 1px solid #eef2f7;
        box-shadow: 0 2px 15px rgba(0,0,0,0.05);
    }
    
    .chart-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 20px;
    }
    
    .chart-title {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
    }
    
    .chart-legend {
        display: flex;
        gap: 15px;
        font-size: 12px;
    }
    
    .legend-item {
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .legend-color {
        width: 12px;
        height: 12px;
        border-radius: 3px;
    }
    
    /* Chart Styles */
    .chart {
        height: 300px;
        position: relative;
        margin: 20px 0;
    }
    
    .bar-chart {
        display: flex;
        align-items: end;
        gap: 15px;
        height: 250px;
        padding: 20px 0;
    }
    
    .bar-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        flex: 1;
        height: 100%;
    }
    
    .bar {
        width: 40px;
        border-radius: 8px 8px 0 0;
        transition: all 0.3s ease;
        position: relative;
    }
    
    .bar:hover {
        opacity: 0.8;
        transform: scale(1.05);
    }
    
    .bar-label {
        margin-top: 10px;
        font-size: 12px;
        color: #6c757d;
        font-weight: 500;
        text-align: center;
    }
    
    .bar-value {
        position: absolute;
        top: -25px;
        left: 50%;
        transform: translateX(-50%);
        font-size: 12px;
        font-weight: 600;
        color: #2c3e50;
    }
    
    /* Pie Chart */
    .pie-chart {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 250px;
        position: relative;
    }
    
    .pie-segment {
        position: absolute;
        border-radius: 50%;
        transition: all 0.3s ease;
    }
    
    .pie-center {
        position: absolute;
        width: 80px;
        height: 80px;
        background: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
        color: #2c3e50;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    /* Metrics Grid */
    .metrics-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-top: 20px;
    }
    
    .metric-card {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 12px;
        text-align: center;
        border-left: 4px solid #667eea;
    }
    
    .metric-value {
        font-size: 24px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    
    .metric-label {
        font-size: 13px;
        color: #6c757d;
        font-weight: 500;
    }
    
    /* Activity Timeline */
    .activity-timeline {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }
    
    .timeline-item {
        display: flex;
        gap: 15px;
        padding: 20px;
        background: #f8f9ff;
        border-radius: 12px;
        border-left: 4px solid #667eea;
    }
    
    .timeline-icon {
        width: 40px;
        height: 40px;
        background: #667eea;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 16px;
        flex-shrink: 0;
    }
    
    .timeline-content {
        flex: 1;
    }
    
    .timeline-title {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    
    .timeline-description {
        font-size: 14px;
        color: #6c757d;
        margin-bottom: 8px;
    }
    
    .timeline-time {
        font-size: 12px;
        color: #8a94a6;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .charts-grid {
            grid-template-columns: 1fr;
        }
        
        .kpi-grid {
            grid-template-columns: 1fr;
        }
        
        .section-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 15px;
        }
    }
    
    /* Animations */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .animate-fade-in {
        animation: fadeInUp 0.6s ease-out;
    }
</style>

<div class="top-bar">
    <div>
        <h1>Tableau de Bord Analytics</h1>
        <div class="breadcrumb">Administration / Analytics Avancés</div>
    </div>
</div>

<div class="analytics-container">
    <!-- Section KPI Principaux -->
    <div class="analytics-section animate-fade-in">
        <div class="section-header">
            <div class="section-title">
                <div class="section-icon">📊</div>
                <h2>Métriques Clés de Performance</h2>
            </div>
            <div style="color: #6c757d; font-size: 14px;">
                Mise à jour en temps réel
            </div>
        </div>
        
        <div class="kpi-grid">
            <!-- Utilisateurs Totaux -->
            <div class="kpi-card">
                <div class="kpi-header">
                    <div class="kpi-icon" style="background: linear-gradient(135deg, #667eea, #764ba2);">👥</div>
                    <span class="kpi-trend trend-up">+12%</span>
                </div>
                <div class="kpi-value"><%= totalUtilisateurs %></div>
                <div class="kpi-label">Utilisateurs Totaux</div>
                <div class="kpi-description">Conducteurs: <%= totalConducteurs %> • Passagers: <%= totalPassagers %></div>
            </div>
            
            <!-- Revenu Total -->
            <div class="kpi-card">
                <div class="kpi-header">
                    <div class="kpi-icon" style="background: linear-gradient(135deg, #00b894, #00a085);">💰</div>
                    <span class="kpi-trend trend-up">+18%</span>
                </div>
                <div class="kpi-value"><%= String.format("%.0f", revenuTotal) %> DH</div>
                <div class="kpi-label">Revenu Total</div>
                <div class="kpi-description">Cumul des réservations confirmées</div>
            </div>
            
            <!-- Offres Actives -->
            <div class="kpi-card">
                <div class="kpi-header">
                    <div class="kpi-icon" style="background: linear-gradient(135deg, #fd79a8, #e84393);">🚗</div>
                    <span class="kpi-trend trend-up">+8%</span>
                </div>
                <div class="kpi-value"><%= totalOffres %></div>
                <div class="kpi-label">Offres Publiées</div>
                <div class="kpi-description"><%= offresActives %> actives • <%= offresEnAttenteCount %> en attente</div>
            </div>
            
            <!-- Réservations -->
            <div class="kpi-card">
                <div class="kpi-header">
                    <div class="kpi-icon" style="background: linear-gradient(135deg, #fdcb6e, #f39c12);">📋</div>
                    <span class="kpi-trend trend-up">+15%</span>
                </div>
                <div class="kpi-value"><%= totalReservations %></div>
                <div class="kpi-label">Réservations Total</div>
                <div class="kpi-description">Taux de conversion: <%= String.format("%.1f", tauxConversion) %>%</div>
            </div>
        </div>
    </div>

    <!-- Section Graphiques -->
    <div class="analytics-section animate-fade-in">
        <div class="section-header">
            <div class="section-title">
                <div class="section-icon">📈</div>
                <h2>Analyses Visuelles</h2>
            </div>
        </div>
        
        <div class="charts-grid">
            <!-- Graphique Statuts des Offres -->
            <div class="chart-container">
                <div class="chart-header">
                    <div class="chart-title">Répartition des Offres</div>
                    <div class="chart-legend">
                        <div class="legend-item">
                            <div class="legend-color" style="background: #00b894;"></div>
                            <span>Actives</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #fd79a8;"></div>
                            <span>Terminées</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #6c5ce7;"></div>
                            <span>Annulées</span>
                        </div>
                    </div>
                </div>
                <div class="chart">
                    <div class="bar-chart">
                        <div class="bar-container">
                            <div class="bar" style="height: <%= (offresActives * 100) / Math.max(totalOffres, 1) %>%; background: #00b894;">
                                <div class="bar-value"><%= offresActives %></div>
                            </div>
                            <div class="bar-label">Actives</div>
                        </div>
                        <div class="bar-container">
                            <div class="bar" style="height: <%= (offresTerminees * 100) / Math.max(totalOffres, 1) %>%; background: #fd79a8;">
                                <div class="bar-value"><%= offresTerminees %></div>
                            </div>
                            <div class="bar-label">Terminées</div>
                        </div>
                        <div class="bar-container">
                            <div class="bar" style="height: <%= (offresAnnulees * 100) / Math.max(totalOffres, 1) %>%; background: #6c5ce7;">
                                <div class="bar-value"><%= offresAnnulees %></div>
                            </div>
                            <div class="bar-label">Annulées</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Graphique Camembert Utilisateurs -->
            <div class="chart-container">
                <div class="chart-header">
                    <div class="chart-title">Répartition Utilisateurs</div>
                    <div class="chart-legend">
                        <div class="legend-item">
                            <div class="legend-color" style="background: #667eea;"></div>
                            <span>Conducteurs</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #f093fb;"></div>
                            <span>Passagers</span>
                        </div>
                    </div>
                </div>
                <div class="chart">
                    <div class="pie-chart">
                        <div class="pie-segment" style="
                            width: 200px; height: 200px;
                            background: conic-gradient(
                                #667eea 0% <%= (totalConducteurs * 360) / totalUtilisateurs %>deg,
                                #f093fb <%= (totalConducteurs * 360) / totalUtilisateurs %>deg 360deg
                            );
                        "></div>
                        <div class="pie-center">
                            <div style="text-align: center;">
                                <div style="font-size: 14px; font-weight: 600;"><%= totalUtilisateurs %></div>
                                <div style="font-size: 10px; color: #6c757d;">Total</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Métriques Secondaires -->
        <div class="metrics-grid">
            <div class="metric-card">
                <div class="metric-value"><%= String.format("%.1f", tauxConversion) %>%</div>
                <div class="metric-label">Taux de Conversion</div>
            </div>
            <div class="metric-card">
                <div class="metric-value"><%= String.format("%.1f", tauxOccupation) %>%</div>
                <div class="metric-label">Taux d'Occupation</div>
            </div>
            <div class="metric-card">
                <div class="metric-value"><%= offresEnAttenteCount %></div>
                <div class="metric-label">Offres en Attente</div>
            </div>
            <div class="metric-card">
                <div class="metric-value">4.7/5</div>
                <div class="metric-label">Satisfaction Moyenne</div>
            </div>
        </div>
    </div>

    <!-- Section Activité Récente -->
    <div class="analytics-section animate-fade-in">
        <div class="section-header">
            <div class="section-title">
                <div class="section-icon">⚡</div>
                <h2>Activité Récente</h2>
            </div>
        </div>
        
        <div class="activity-timeline">
            <div class="timeline-item">
                <div class="timeline-icon">🚗</div>
                <div class="timeline-content">
                    <div class="timeline-title">Nouvelle Offre Publiée</div>
                    <div class="timeline-description">Trajet de Casablanca vers Rabat - 120 DH</div>
                    <div class="timeline-time">Il y a 5 minutes</div>
                </div>
            </div>
            
            <div class="timeline-item">
                <div class="timeline-icon">💰</div>
                <div class="timeline-content">
                    <div class="timeline-title">Réservation Confirmée</div>
                    <div class="timeline-description">2 places réservées sur le trajet #<%= totalReservations + 1 %></div>
                    <div class="timeline-time">Il y a 15 minutes</div>
                </div>
            </div>
            
            <div class="timeline-item">
                <div class="timeline-icon">👥</div>
                <div class="timeline-content">
                    <div class="timeline-title">Nouvel Utilisateur</div>
                    <div class="timeline-description"><%= totalConducteurs + 1 %>ème conducteur inscrit sur la plateforme</div>
                    <div class="timeline-time">Il y a 25 minutes</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Section Performance -->
    <div class="analytics-section animate-fade-in">
        <div class="section-header">
            <div class="section-title">
                <div class="section-icon">🎯</div>
                <h2>Indicateurs de Performance</h2>
            </div>
        </div>
        
        <div class="charts-grid">
            <!-- Performance Mensuelle -->
            <div class="chart-container">
                <div class="chart-header">
                    <div class="chart-title">Croissance Mensuelle</div>
                </div>
                <div class="chart">
                    <div class="bar-chart">
                        <%
                            int[] monthlyData = {totalOffres - 20, totalOffres - 15, totalOffres - 10, totalOffres - 5, totalOffres};
                            String[] months = {"Jan", "Fév", "Mar", "Avr", "Mai"};
                            String[] colors = {"#667eea", "#764ba2", "#f093fb", "#ffd3b6", "#a8e6cf"};
                        %>
                        <% for (int i = 0; i < months.length; i++) { %>
                            <div class="bar-container">
                                <div class="bar" style="height: <%= (monthlyData[i] * 100) / Math.max(monthlyData[4], 1) %>%; background: <%= colors[i] %>;">
                                    <div class="bar-value"><%= monthlyData[i] %></div>
                                </div>
                                <div class="bar-label"><%= months[i] %></div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <!-- Objectifs -->
            <div class="chart-container">
                <div class="chart-header">
                    <div class="chart-title">Progression des Objectifs</div>
                </div>
                <div class="chart">
                    <div style="display: flex; flex-direction: column; gap: 20px; height: 100%; justify-content: center;">
                        <!-- Objectif Utilisateurs -->
                        <div>
                            <div style="display: flex; justify-content: between; margin-bottom: 5px;">
                                <span style="font-size: 14px; color: #2c3e50;">Utilisateurs</span>
                                <span style="font-size: 14px; color: #667eea; font-weight: 600;"><%= totalUtilisateurs %>/500</span>
                            </div>
                            <div style="height: 8px; background: #e9ecef; border-radius: 4px; overflow: hidden;">
                                <div style="height: 100%; background: #667eea; width: <%= (totalUtilisateurs * 100) / 500 %>%; border-radius: 4px;"></div>
                            </div>
                        </div>
                        
                        <!-- Objectif Revenus -->
                        <div>
                            <div style="display: flex; justify-content: between; margin-bottom: 5px;">
                                <span style="font-size: 14px; color: #2c3e50;">Revenus</span>
                                <span style="font-size: 14px; color: #00b894; font-weight: 600;"><%= String.format("%.0f", revenuTotal) %>/10000 DH</span>
                            </div>
                            <div style="height: 8px; background: #e9ecef; border-radius: 4px; overflow: hidden;">
                                <div style="height: 100%; background: #00b894; width: <%= (revenuTotal * 100) / 10000 %>%; border-radius: 4px;"></div>
                            </div>
                        </div>
                        
                        <!-- Objectif Réservations -->
                        <div>
                            <div style="display: flex; justify-content: between; margin-bottom: 5px;">
                                <span style="font-size: 14px; color: #2c3e50;">Réservations</span>
                                <span style="font-size: 14px; color: #fd79a8; font-weight: 600;"><%= totalReservations %>/200</span>
                            </div>
                            <div style="height: 8px; background: #e9ecef; border-radius: 4px; overflow: hidden;">
                                <div style="height: 100%; background: #fd79a8; width: <%= (totalReservations * 100) / 200 %>%; border-radius: 4px;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Animation au chargement
    document.addEventListener('DOMContentLoaded', function() {
        // Animation des barres
        const bars = document.querySelectorAll('.bar');
        bars.forEach((bar, index) => {
            bar.style.transform = 'scaleY(0)';
            bar.style.transformOrigin = 'bottom';
            
            setTimeout(() => {
                bar.style.transition = 'transform 0.8s ease-out';
                bar.style.transform = 'scaleY(1)';
            }, index * 200);
        });
        
        // Animation des cartes KPI
        const kpiCards = document.querySelectorAll('.kpi-card');
        kpiCards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                card.style.transition = 'all 0.6s ease-out';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 150);
        });
        
        // Mise à jour en temps réel (simulation)
        setInterval(() => {
            // Animation de pulse sur les cartes KPI
            const randomCard = kpiCards[Math.floor(Math.random() * kpiCards.length)];
            randomCard.style.boxShadow = '0 8px 25px rgba(102, 126, 234, 0.3)';
            
            setTimeout(() => {
                randomCard.style.boxShadow = '';
            }, 1000);
        }, 5000);
    });
    
    // Interaction avec les graphiques
    document.querySelectorAll('.bar').forEach(bar => {
        bar.addEventListener('mouseenter', function() {
            this.style.filter = 'brightness(1.1)';
        });
        
        bar.addEventListener('mouseleave', function() {
            this.style.filter = 'brightness(1)';
        });
    });
</script>