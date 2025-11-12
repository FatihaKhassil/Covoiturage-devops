<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Offre" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
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
    List<Offre> dernieresOffres = (List<Offre>) request.getAttribute("dernieresOffres");
    
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
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<div class="top-bar">
    <div>
        <h1>Tableau de Bord</h1>
        <div class="breadcrumb">Accueil / Dashboard</div>
    </div>
</div>

<!-- Stats Cards -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Utilisateurs</h3>
            <div class="stat-icon blue">👥</div>
        </div>
        <div class="value"><%= totalUtilisateurs %></div>
        <div class="label"><%= totalConducteurs %> Conducteurs | <%= totalPassagers %> Passagers</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Offres Publiées</h3>
            <div class="stat-icon green">🚗</div>
        </div>
        <div class="value"><%= totalOffres %></div>
        <div class="label"><%= offresActives %> Actives | <%= offresTerminees %> Terminées</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>En Attente</h3>
            <div class="stat-icon orange">⏳</div>
        </div>
        <div class="value"><%= offresEnAttenteCount %></div>
        <div class="label">Offres à valider</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Réservations</h3>
            <div class="stat-icon purple">📋</div>
        </div>
        <div class="value"><%= totalReservations %></div>
        <div class="label">Total réservations</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Revenus Générés</h3>
            <div class="stat-icon green">💰</div>
        </div>
        <div class="value"><%= String.format("%.0f", revenuTotal) %></div>
        <div class="label">DH (Total transactions)</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Offres Annulées</h3>
            <div class="stat-icon red">❌</div>
        </div>
        <div class="value"><%= offresAnnulees %></div>
        <div class="label">Annulations</div>
    </div>
</div>

<!-- Recent Activity -->
<div class="content-section">
    <div class="section-header">
        <h2>Activité Récente</h2>
    </div>
    
    <% if (dernieresOffres == null || dernieresOffres.isEmpty()) { %>
        <p style="color: #7f8c8d; text-align: center; padding: 40px 0;">
            Aucune activité récente
        </p>
    <% } else { %>
        <style>
            .activity-list {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }
            
            .activity-item {
                display: flex;
                align-items: center;
                padding: 15px;
                background: #f8f9fa;
                border-radius: 8px;
                border-left: 4px solid #e74c3c;
                transition: all 0.3s;
            }
            
            .activity-item:hover {
                background: #e9ecef;
                transform: translateX(5px);
            }
            
            .activity-icon {
                width: 50px;
                height: 50px;
                background: white;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                margin-right: 15px;
            }
            
            .activity-details {
                flex: 1;
            }
            
            .activity-details h4 {
                font-size: 16px;
                color: #2c3e50;
                margin-bottom: 5px;
            }
            
            .activity-details p {
                font-size: 14px;
                color: #7f8c8d;
            }
            
            .activity-status {
                padding: 5px 12px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: 600;
            }
            
            .status-active {
                background: #d4edda;
                color: #155724;
            }
            
            .status-completed {
                background: #d1ecf1;
                color: #0c5460;
            }
            
            .status-cancelled {
                background: #f8d7da;
                color: #721c24;
            }
            
            .status-pending {
                background: #fff3cd;
                color: #856404;
            }
        </style>
        
        <div class="activity-list">
            <% for (Offre offre : dernieresOffres) { 
                String statut = offre.getStatut();
                String statusClass = "";
                String statusLabel = "";
                
                if ("EN_ATTENTE".equals(statut)) {
                    statusClass = "status-pending";
                    statusLabel = "En Attente";
                } else if ("TERMINEE".equals(statut)) {
                    statusClass = "status-completed";
                    statusLabel = "Terminée";
                } else if ("ANNULEE".equals(statut)) {
                    statusClass = "status-cancelled";
                    statusLabel = "Annulée";
                } else {
                    statusClass = "status-active";
                    statusLabel = "Active";
                }
            %>
                <div class="activity-item">
                    <div class="activity-icon">🚗</div>
                    <div class="activity-details">
                        <h4><%= offre.getVilleDepart() %> → <%= offre.getVilleArrivee() %></h4>
                        <p>
                            📅 <%= dateFormat.format(offre.getDateDepart()) %> à <%= timeFormat.format(offre.getHeureDepart()) %>
                            | 💺 <%= offre.getPlacesDisponibles() %>/<%= offre.getPlacesTotales() %> places
                            | 💰 <%= String.format("%.0f", offre.getPrixParPlace()) %> DH
                        </p>
                    </div>
                    <span class="activity-status <%= statusClass %>"><%= statusLabel %></span>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<style>
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-top: 30px;
    }
    
    .quick-action-btn {
        padding: 20px;
        background: white;
        border-radius: 10px;
        text-align: center;
        text-decoration: none;
        color: #2c3e50;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        transition: all 0.3s;
    }
    
    .quick-action-btn:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    }
    
    .quick-action-btn .icon {
        font-size: 32px;
        margin-bottom: 10px;
    }
    
    .quick-action-btn .title {
        font-weight: 600;
        font-size: 14px;
    }
</style>

<div class="quick-actions">
    <a href="Admin?page=utilisateurs" class="quick-action-btn">
        <div class="icon">👥</div>
        <div class="title">Gérer Utilisateurs</div>
    </a>
    <a href="Admin?page=validation" class="quick-action-btn">
        <div class="icon">✅</div>
        <div class="title">Valider Offres</div>
    </a>
    <a href="Admin?page=rapports" class="quick-action-btn">
        <div class="icon">📈</div>
        <div class="title">Voir Rapports</div>
    </a>
</div>