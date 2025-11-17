<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Passager, models.Reservation, java.util.List, java.text.SimpleDateFormat" %>
<%
    Passager passager = (Passager) session.getAttribute("utilisateur");
    
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    Integer reservationsEnAttente = (Integer) request.getAttribute("reservationsEnAttente");
    Integer reservationsConfirmees = (Integer) request.getAttribute("reservationsConfirmees");
    Integer reservationsTerminees = (Integer) request.getAttribute("reservationsTerminees");
    Integer reservationsAnnulees = (Integer) request.getAttribute("reservationsAnnulees");
    Integer offresDisponibles = (Integer) request.getAttribute("offresDisponibles");
    List<Reservation> dernieresReservations = (List<Reservation>) request.getAttribute("dernieresReservations");
    
    // Initialisation des valeurs par défaut
    if (totalReservations == null) totalReservations = 0;
    if (reservationsEnAttente == null) reservationsEnAttente = 0;
    if (reservationsConfirmees == null) reservationsConfirmees = 0;
    if (reservationsTerminees == null) reservationsTerminees = 0;
    if (reservationsAnnulees == null) reservationsAnnulees = 0;
    if (offresDisponibles == null) offresDisponibles = 0;
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<div class="top-bar">
    <div>
        <h1>Tableau de Bord</h1>
        <div class="breadcrumb">Accueil / Dashboard</div>
    </div>
</div>

<!-- Stats Cards - 5 cartes au lieu de 4 -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Réservations Totales</h3>
            <div class="stat-icon blue">📋</div>
        </div>
        <div class="value"><%= totalReservations %></div>
        <div class="label">Total de réservations</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>En Attente</h3>
            <div class="stat-icon orange">⏳</div>
        </div>
        <div class="value"><%= reservationsEnAttente %></div>
        <div class="label">En attente de confirmation</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Confirmées</h3>
            <div class="stat-icon green">✅</div>
        </div>
        <div class="value"><%= reservationsConfirmees %></div>
        <div class="label">Confirmées par le conducteur</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Terminées</h3>
            <div class="stat-icon purple">🎯</div>
        </div>
        <div class="value"><%= reservationsTerminees %></div>
        <div class="label">Trajets effectués</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Annulées</h3>
            <div class="stat-icon red">❌</div>
        </div>
        <div class="value"><%= reservationsAnnulees %></div>
        <div class="label">Réservations annulées</div>
    </div>
</div>

<!-- Le reste du code reste identique -->
<div class="content-section">
    <div class="section-header">
        <h2>Activité Récente</h2>
    </div>
    
    <% if (dernieresReservations == null || dernieresReservations.isEmpty()) { %>
        <p style="color: #7f8c8d; text-align: center; padding: 40px 0;">
            Bienvenue sur votre tableau de bord, <%= passager.getPrenom() %>! 
            Vous n'avez pas encore de réservations. 
            <a href="Passager?page=rechercher" style="color: #667eea; text-decoration: none; font-weight: 600;">Recherchez un trajet</a>
        </p>
    <% } else { %>
        <style>
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            
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
                border-left: 4px solid #667eea;
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
            
            .status-en-attente {
                background: #fff3cd;
                color: #856404;
            }
            
            .status-confirmee {
                background: #d4edda;
                color: #155724;
            }
            
            .status-terminee {
                background: #d1ecf1;
                color: #0c5460;
            }
            
            .status-annulee {
                background: #f8d7da;
                color: #721c24;
            }
        </style>
        
        <div class="activity-list">
            <% for (Reservation reservation : dernieresReservations) { 
                String statut = reservation.getStatut();
                String statusClass = "";
                String statusLabel = "";
                
                if ("EN_ATTENTE".equals(statut)) {
                    statusClass = "status-en-attente";
                    statusLabel = "En Attente";
                } else if ("CONFIRMEE".equals(statut)) {
                    statusClass = "status-confirmee";
                    statusLabel = "Confirmée";
                } else if ("TERMINEE".equals(statut)) {
                    statusClass = "status-terminee";
                    statusLabel = "Terminée";
                } else if ("ANNULEE".equals(statut)) {
                    statusClass = "status-annulee";
                    statusLabel = "Annulée";
                }
            %>
                <div class="activity-item">
                    <div class="activity-icon">🚗</div>
                    <div class="activity-details">
                        <h4><%= reservation.getOffre().getVilleDepart() %> → <%= reservation.getOffre().getVilleArrivee() %></h4>
                        <p>
                            📅 <%= dateFormat.format(reservation.getOffre().getDateDepart()) %> à <%= timeFormat.format(reservation.getOffre().getHeureDepart()) %>
                            | 💺 <%= reservation.getNombrePlaces() %> place(s)
                            | 💰 <%= String.format("%.0f", reservation.getPrixTotal()) %> DH
                        </p>
                    </div>
                    <span class="activity-status <%= statusClass %>"><%= statusLabel %></span>
                </div>
            <% } %>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="Passager?page=reservations" style="color: #667eea; text-decoration: none; font-weight: 600;">
                Voir toutes mes réservations →
            </a>
        </div>
    <% } %>
</div>