<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Passager, models.Reservation, models.Offre, models.Notification, java.util.List, java.text.SimpleDateFormat" %>
<%
    // ===== RÉCUPÉRATION DES DONNÉES =====
    // Récupération du passager depuis la session (car c'est un fichier inclus)
    Passager passagerDashboard = (Passager) session.getAttribute("utilisateur");
    
    // Récupération des statistiques préparées par le servlet
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    Integer reservationsEnAttente = (Integer) request.getAttribute("reservationsEnAttente");
    Integer reservationsConfirmees = (Integer) request.getAttribute("reservationsConfirmees");
    Integer reservationsTerminees = (Integer) request.getAttribute("reservationsTerminees");
    List<Reservation> dernieresReservations = (List<Reservation>) request.getAttribute("dernieresReservations");
    Integer nbNotifNonLues = (Integer) request.getAttribute("nbNotifNonLues");
    List<Notification> dernieresNotifs = (List<Notification>) request.getAttribute("dernieresNotifs");
    
    // Valeurs par défaut
    if (totalReservations == null) totalReservations = 0;
    if (reservationsEnAttente == null) reservationsEnAttente = 0;
    if (reservationsConfirmees == null) reservationsConfirmees = 0;
    if (reservationsTerminees == null) reservationsTerminees = 0;
    if (nbNotifNonLues == null) nbNotifNonLues = 0;
    if (dernieresNotifs == null) dernieresNotifs = new java.util.ArrayList<>();
    
    // Formatage des dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>
<div class="top-bar">
    <div>
        <h1>Tableau de Bord</h1>
        <div class="breadcrumb">Accueil / Dashboard</div>
    </div>
    
    <div class="notification-container">
        <button id="notification-toggle" class="notification-btn">
            <span style="font-size: 24px;">🔔</span>
            <span id="notification-badge" class="badge <%= nbNotifNonLues > 0 ? "active" : "" %>">
                <%= nbNotifNonLues %>
            </span>
        </button>
        
        <div id="notification-dropdown" class="notification-dropdown">
            <% if (dernieresNotifs.isEmpty()) { %>
                <p style="padding: 10px; text-align: center; color: #7f8c8d;">Aucune nouvelle notification.</p>
            <% } else { 
                for (Notification notif : dernieresNotifs) { %>
                    <a href="Passager?page=reservations" class="dropdown-item <%= notif.getEstLue() ? "" : "unseen" %>" data-id="<%= notif.getIdNotification() %>">
                        <span class="notif-message"><%= notif.getMessage() %></span>
                        <span class="notif-time"><%= timeFormat.format(notif.getDateEnvoi()) %></span>
                    </a>
                <% } 
            } %>
            <div class="dropdown-footer">
                <a href="Passager?action=marquerToutesLues&redirectPage=dashboard">Marquer tout comme lu</a>
            </div>
        </div>
    </div>
</div>
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Réservations Totales</h3>
            <div class="stat-icon blue">🎫</div>
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
        <div class="label">À confirmer</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Confirmées</h3>
            <div class="stat-icon green">✅</div>
        </div>
        <div class="value"><%= reservationsConfirmees %></div>
        <div class="label">Trajets confirmés</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Note Moyenne</h3>
            <div class="stat-icon purple">⭐</div>
        </div>
        <div class="value"><%= passagerDashboard != null ? String.format("%.1f", passagerDashboard.getNoteMoyenne()) : "0.0" %></div>
        <div class="label">Sur 5 étoiles</div>
    </div>
</div>

<div class="content-section">
    <div class="section-header">
        <h2>Activité Récente</h2>
    </div>
    
    <% if (dernieresReservations == null || dernieresReservations.isEmpty()) { %>
        <p style="color: #7f8c8d; text-align: center; padding: 40px 0;">
            Bienvenue sur votre tableau de bord<%= passagerDashboard != null ? ", " + passagerDashboard.getPrenom() : "" %>! 
            Vous n'avez pas encore de réservations. 
            <a href="Passager?page=rechercher" style="color: #667eea; text-decoration: none; font-weight: 600;">Rechercher un trajet</a>
        </p>
    <% } else { %>
        <style>
            /* (Votre CSS pour l'activité) */
            .activity-list { display: flex; flex-direction: column; gap: 15px; }
            .activity-item { display: flex; align-items: center; padding: 15px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #667eea; transition: all 0.3s; }
            .activity-item:hover { background: #e9ecef; transform: translateX(5px); }
            .activity-icon { width: 50px; height: 50px; background: white; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 24px; margin-right: 15px; }
            .activity-details { flex: 1; }
            .activity-details h4 { font-size: 16px; color: #2c3e50; margin-bottom: 5px; }
            .activity-details p { font-size: 14px; color: #7f8c8d; }
            .activity-status { padding: 5px 12px; border-radius: 15px; font-size: 12px; font-weight: 600; }
            .status-pending { background: #fff3cd; color: #856404; }
            .status-confirmed { background: #d4edda; color: #155724; }
            .status-completed { background: #d1ecf1; color: #0c5460; }
            .status-cancelled { background: #f8d7da; color: #721c24; }
        </style>
        
        <div class="activity-list">
            <% for (Reservation reservation : dernieresReservations) { 
                Offre offre = reservation.getOffre();
                String statut = reservation.getStatut();
                String statusClass = "";
                String statusLabel = "";
                
                if ("EN_ATTENTE".equals(statut)) {
                    statusClass = "status-pending";
                    statusLabel = "En attente";
                } else if ("CONFIRMEE".equals(statut)) {
                    statusClass = "status-confirmed";
                    statusLabel = "Confirmée";
                } else if ("TERMINEE".equals(statut)) {
                    statusClass = "status-completed";
                    statusLabel = "Terminée";
                } else if ("ANNULEE".equals(statut)) {
                    statusClass = "status-cancelled";
                    statusLabel = "Annulée";
                }
            %>
                <div class="activity-item">
                    <div class="activity-icon">🎫</div>
                    <div class="activity-details">
                        <h4><%= offre.getVilleDepart() %> → <%= offre.getVilleArrivee() %></h4>
                        <p>
                            📅 <%= dateFormat.format(offre.getDateDepart()) %> à <%= timeFormat.format(offre.getHeureDepart()) %>
                            | 💺 <%= reservation.getNombrePlaces() %> place(s)
                            | 💰 <%= String.format("%.0f", reservation.getPrixTotal()) %> DH
                            | 👤 <%= offre.getConducteur().getPrenom() %> <%= offre.getConducteur().getNom() %>
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