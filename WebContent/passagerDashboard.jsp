<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Passager, models.Reservation, java.util.List, java.text.SimpleDateFormat" %>
<%
    Passager passager = (Passager) session.getAttribute("utilisateur");
    
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    Integer reservationsActives = (Integer) request.getAttribute("reservationsActives");
    Integer reservationsTerminees = (Integer) request.getAttribute("reservationsTerminees");
    Integer offresDisponibles = (Integer) request.getAttribute("offresDisponibles");
    List<Reservation> dernieresReservations = (List<Reservation>) request.getAttribute("dernieresReservations");
    
    if (totalReservations == null) totalReservations = 0;
    if (reservationsActives == null) reservationsActives = 0;
    if (reservationsTerminees == null) reservationsTerminees = 0;
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

<!-- Stats Cards -->
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
            <h3>Réservations Actives</h3>
            <div class="stat-icon green">✅</div>
        </div>
        <div class="value"><%= reservationsActives %></div>
        <div class="label">En cours</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Trajets Effectués</h3>
            <div class="stat-icon purple">🎯</div>
        </div>
        <div class="value"><%= reservationsTerminees %></div>
        <div class="label">Terminés</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Offres Disponibles</h3>
            <div class="stat-icon orange">🚗</div>
        </div>
        <div class="value"><%= offresDisponibles %></div>
        <div class="label">À réserver</div>
    </div>
</div>

<!-- Recent Activity -->
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
                
                if ("CONFIRMEE".equals(statut)) {
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