<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur" %>
<%@ page import="models.Offre" %>
<%@ page import="models.Notification" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    // --- PARTIE JSP DÉCLARATION DES VARIABLES ---
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    String typeUtilisateur = (String) session.getAttribute("typeUtilisateur");
    
    if (conducteur == null || !"conducteur".equals(typeUtilisateur)) {
        response.sendRedirect("connexion.jsp");
        return;
    }
    
    // Récupération de la page actuelle (Définie dans ConducteurServlet.doGet)
    String currentPage = (String) request.getAttribute("page");
    if (currentPage == null) currentPage = "dashboard";
    
    // Récupération des données de notification
    Long conducteurId = conducteur.getIdConducteur();
    Integer nbNotifNonLues = (Integer) request.getAttribute("nbNotifNonLues");
    List<Notification> dernieresNotifs = (List<Notification>) request.getAttribute("dernieresNotifs");

    if (nbNotifNonLues == null) nbNotifNonLues = 0;
    if (dernieresNotifs == null) dernieresNotifs = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Conducteur - Covoiturage</title>
    <style>
        /* (Votre CSS COMPLET ICI) */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f6fa; }
        .container { display: flex; min-height: 100vh; }
        /* Sidebar */
        .sidebar { width: 260px; background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%); color: white; position: fixed; height: 100vh; overflow-y: auto; box-shadow: 2px 0 10px rgba(0,0,0,0.1); }
        .sidebar-header { padding: 25px 20px; background: rgba(0,0,0,0.2); border-bottom: 1px solid rgba(255,255,255,0.1); }
        .user-info { padding: 20px; background: rgba(0,0,0,0.15); border-bottom: 1px solid rgba(255,255,255,0.1); }
        .user-rating span { color: #f39c12; }
        .nav-menu { padding: 15px 0; }
        .nav-item { margin: 5px 15px; }
        .nav-item a { display: flex; align-items: center; padding: 12px 15px; color: white; text-decoration: none; border-radius: 8px; transition: all 0.3s; }
        .nav-item a:hover { background: rgba(255,255,255,0.1); transform: translateX(5px); }
        .nav-item a.active { background: rgba(52, 152, 219, 0.3); border-left: 4px solid #3498db; }
        .logout-section { padding: 20px; border-top: 1px solid rgba(255,255,255,0.1); }
        .logout-btn { display: block; width: 100%; padding: 12px; background: #e74c3c; color: white; text-align: center; text-decoration: none; border-radius: 8px; transition: background 0.3s; }
        .logout-btn:hover { background: #c0392b; }
        
        /* Main Content & Top Bar */
        .main-content { margin-left: 260px; flex: 1; padding: 30px; }
        .top-bar { background: white; padding: 20px 30px; border-radius: 10px; margin-bottom: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
        .top-bar h1 { font-size: 28px; color: #2c3e50; }
        .breadcrumb { color: #7f8c8d; font-size: 14px; }
        
        /* Notifications CSS */
        .notification-container { position: relative; display: inline-block; }
        .notification-btn { background: none; border: none; cursor: pointer; padding: 5px; position: relative; }
        .badge { position: absolute; top: 0; right: 0; background: #e74c3c; color: white; border-radius: 50%; padding: 2px 6px; font-size: 10px; font-weight: bold; display: none; }
        .badge.active { display: block; }
        .notification-dropdown { display: none; position: absolute; right: 0; top: 50px; width: 300px; max-height: 400px; overflow-y: auto; background: white; border: 1px solid #ccc; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); z-index: 1000; border-radius: 8px; }
        .dropdown-item { padding: 10px; border-bottom: 1px solid #eee; font-size: 14px; display: flex; justify-content: space-between; align-items: center; text-decoration: none; color: inherit; }
        .dropdown-item:last-child { border-bottom: none; }
        .dropdown-item.unseen { background-color: #f7f7f7; font-weight: 600; }
        .dropdown-item:hover { background-color: #f0f0f0; }
        .dropdown-footer { padding: 10px; text-align: center; border-top: 1px solid #eee; }
        
        /* Stats Cards CSS */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); transition: transform 0.3s; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
        .stat-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .stat-card h3 { font-size: 14px; color: #7f8c8d; text-transform: uppercase; letter-spacing: 1px; }
        .stat-icon { width: 50px; height: 50px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
        .stat-card .value { font-size: 32px; font-weight: bold; color: #2c3e50; }
        .stat-card .label { font-size: 13px; color: #95a5a6; margin-top: 5px; }
        .blue { background: #e3f2fd; color: #2196f3; }
        .green { background: #e8f5e9; color: #4caf50; }
        .orange { background: #fff3e0; color: #ff9800; }
        .purple { background: #f3e5f5; color: #9c27b0; }
        .content-section { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .section-header { margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #ecf0f1; }
        .section-header h2 { font-size: 22px; color: #2c3e50; }
    </style>
</head>
<body>
    <div class="container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>🚗 Covoiturage</h2>
                <p>Espace Conducteur</p>
            </div>
            
            <div class="user-info">
                <h3><%= conducteur.getPrenom() %> <%= conducteur.getNom() %></h3>
                <p><%= conducteur.getEmail() %></p>
                <div class="user-rating">
                    ⭐ <span><%= String.format("%.1f", conducteur.getNoteMoyenne()) %>/5</span>
                </div>
            </div>
            
            <nav class="nav-menu">
                <div class="nav-item">
                    <a href="Conducteur?page=dashboard" class="<%= "dashboard".equals(currentPage) ? "active" : "" %>">
                        📊 Tableau de Bord
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Conducteur?page=offres" class="<%= "offres".equals(currentPage) ? "active" : "" %>">
                        🚙 Gérer Mes Offres
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Conducteur?page=publier" class="<%= "publier".equals(currentPage) ? "active" : "" %>">
                        ➕ Publier un Trajet
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Conducteur?page=demandes" class="<%= "demandes".equals(currentPage) ? "active" : "" %>">
                        📋 Demandes de Réservation
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Conducteur?page=evaluations" class="<%= "evaluations".equals(currentPage) ? "active" : "" %>">
                        ⭐ Évaluations Reçues
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Conducteur?page=profil" class="<%= "profil".equals(currentPage) ? "active" : "" %>">
                        👤 Mon Profil
                    </a>
                </div>
            </nav>
            
            <div class="logout-section">
                <a href="DeconnexionServlet" class="logout-btn">🚪 Déconnexion</a>
            </div>
        </aside>
        
        <main class="main-content">
            <div class="top-bar">
                <div>
                    <% 
                        String pageTitle = currentPage.substring(0, 1).toUpperCase() + currentPage.substring(1).replace("offres", "Gérer Mes Offres").replace("demandes", "Demandes de Réservation").replace("evaluations", "Évaluations Reçues").replace("profil", "Mon Profil");
                        if (pageTitle.equals("Dashboard")) pageTitle = "Tableau de Bord";
                    %>
                    <h1><%= pageTitle %></h1>
                    <div class="breadcrumb">Accueil / <%= pageTitle %></div>
                </div>
                
                <% if ("dashboard".equals(currentPage)) { %>
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
                                    <a href="Conducteur?page=demandes" class="dropdown-item <%= notif.getEstLue() ? "" : "unseen" %>" data-id="<%= notif.getIdNotification() %>">
                                        <span class="notif-message"><%= notif.getMessage() %></span>
                                        <span class="notif-time"><%= new SimpleDateFormat("HH:mm").format(notif.getDateEnvoi()) %></span>
                                    </a>
                                <% } 
                            } %>
                            <div class="dropdown-footer">
                                <a href="Conducteur?action=marquerToutesLues&redirectPage=dashboard">Marquer tout comme lu</a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>

            <%
                // Inclusion conditionnelle du CONTENU de la page (Stats cards/Activity/Includes)
                if ("dashboard".equals(currentPage)) {
                    // Récupérer les statistiques
                    Integer totalOffres = (Integer) request.getAttribute("totalOffres");
                    Integer offresActives = (Integer) request.getAttribute("offresActives");
                    Integer offresCompletes = (Integer) request.getAttribute("offresCompletes");
                    Integer offresTerminees = (Integer) request.getAttribute("offresTerminees");
                    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
                    Integer demandesEnAttente = (Integer) request.getAttribute("demandesEnAttente");
                    List<Offre> dernieresOffres = (List<Offre>) request.getAttribute("dernieresOffres");
                    
                    if (totalOffres == null) totalOffres = 0;
                    if (offresActives == null) offresActives = 0;
                    if (offresCompletes == null) offresCompletes = 0;
                    if (offresTerminees == null) offresTerminees = 0;
                    if (totalReservations == null) totalReservations = 0;
                    if (demandesEnAttente == null) demandesEnAttente = 0;
                    
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            %>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <h3>Trajets Publiés</h3>
                            <div class="stat-icon blue">🚗</div>
                        </div>
                        <div class="value"><%= totalOffres %></div>
                        <div class="label">Total d'offres</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <h3>Offres Actives</h3>
                            <div class="stat-icon green">✅</div>
                        </div>
                        <div class="value"><%= offresActives %></div>
                        <div class="label">En cours</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <h3>Demandes en Attente</h3>
                            <div class="stat-icon orange">⏳</div>
                        </div>
                        <div class="value"><%= demandesEnAttente %></div>
                        <div class="label">À traiter</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <h3>Note Moyenne</h3>
                            <div class="stat-icon purple">⭐</div>
                        </div>
                        <div class="value"><%= String.format("%.1f", conducteur.getNoteMoyenne()) %></div>
                        <div class="label">Sur 5 étoiles</div>
                    </div>
                </div>
                
                <div class="content-section">
                    <div class="section-header">
                        <h2>Activité Récente</h2>
                    </div>
                    
                    <% if (dernieresOffres == null || dernieresOffres.isEmpty()) { %>
                        <p style="color: #7f8c8d; text-align: center; padding: 40px 0;">
                            Bienvenue sur votre tableau de bord, <%= conducteur.getPrenom() %>! 
                            Vous n'avez pas encore publié d'offres. 
                            <a href="Conducteur?page=publier" style="color: #667eea; text-decoration: none; font-weight: 600;">Publiez votre première offre</a>
                        </p>
                    <% } else { %>
                        <style>
                            .activity-list { display: flex; flex-direction: column; gap: 15px; }
                            .activity-item { display: flex; align-items: center; padding: 15px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #667eea; transition: all 0.3s; }
                            .activity-item:hover { background: #e9ecef; transform: translateX(5px); }
                            .activity-icon { width: 50px; height: 50px; background: white; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 24px; margin-right: 15px; }
                            .activity-details { flex: 1; }
                            .activity-details h4 { font-size: 16px; color: #2c3e50; margin-bottom: 5px; }
                            .activity-details p { font-size: 14px; color: #7f8c8d; }
                            .activity-status { padding: 5px 12px; border-radius: 15px; font-size: 12px; font-weight: 600; }
                            .status-active { background: #d4edda; color: #155724; }
                            .status-full { background: #fff3cd; color: #856404; }
                            .status-completed { background: #d1ecf1; color: #0c5460; }
                            .status-cancelled { background: #f8d7da; color: #721c24; }
                        </style>
                        
                        <div class="activity-list">
                            <% for (Offre offre : dernieresOffres) { 
                                String statut = offre.getStatut();
                                String statusClass = "";
                                String statusLabel = "";
                                
                                if ("EN_ATTENTE".equals(statut)) {
                                    if (offre.getPlacesDisponibles() > 0) {
                                        statusClass = "status-active";
                                        statusLabel = "Active";
                                    } else {
                                        statusClass = "status-full";
                                        statusLabel = "Complète";
                                    }
                                } else if ("TERMINEE".equals(statut)) {
                                    statusClass = "status-completed";
                                    statusLabel = "Terminée";
                                } else if ("ANNULEE".equals(statut)) {
                                    statusClass = "status-cancelled";
                                    statusLabel = "Annulée";
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
                        
                        <div style="text-align: center; margin-top: 20px;">
                            <a href="Conducteur?page=offres" style="color: #667eea; text-decoration: none; font-weight: 600;">
                                Voir toutes mes offres →
                            </a>
                        </div>
                    <% } %>
                </div>
            <%
                // Inclusion des autres pages si ce n'est pas le dashboard
                } else if ("offres".equals(currentPage)) {
            %>
                    <jsp:include page="gererOffres.jsp" />
            <%
                } else if ("publier".equals(currentPage)) {
            %>
                    <jsp:include page="publierTrajet.jsp" />
            <%
                } else if ("demandes".equals(currentPage)) {
            %>
                    <jsp:include page="demandesReservation.jsp" />
            <%
                } else if ("evaluations".equals(currentPage)) {
            %>
                    <jsp:include page="evaluationsRecues.jsp" />
            <%
                } else if ("profil".equals(currentPage)) {
            %>
                    <jsp:include page="ConProfil.jsp" />
            <%
                }
            %>
        </main>
    </div>

    <script>
        // Récupération de l'ID utilisateur
        const currentUserId = "<%= conducteur.getIdConducteur() %>";
        const appName = "Covoiturage"; 
        const isDashboard = ("<%= currentPage %>" === "dashboard"); // Condition côté client

        if (currentUserId && currentUserId !== "null" && isDashboard) { // WebSocket uniquement si Dashboard
            const protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
            const host = window.location.host;
            const wsUrl = protocol + host + "/" + appName + "/notifications/" + currentUserId;
            
            let websocket;

            function connectWebSocket() {
                websocket = new WebSocket(wsUrl);

                websocket.onopen = function(event) {
                    console.log("WebSocket connecté pour l'utilisateur: " + currentUserId);
                };

                websocket.onmessage = function(event) {
                    const notification = JSON.parse(event.data);
                    
                    // 1. Mettre à jour le badge
                    const badge = document.getElementById('notification-badge');
                    let count = parseInt(badge.textContent);
                    badge.textContent = count + 1;
                    badge.classList.add('active');

                    alert(`🔔 Nouvelle alerte: ${notification.message}`); 
                    
                    // 2. Mettre à jour le menu déroulant
                    const now = new Date();
                    const formattedTime = now.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });

                    const dropdown = document.getElementById('notification-dropdown');
                    const newItemLink = document.createElement('a'); // Utilisation de <a> pour la redirection
                    
                    // La notification renvoie aux demandes de réservation
                    newItemLink.href = "Conducteur?page=demandes";
                    newItemLink.className = 'dropdown-item unseen';
                    newItemLink.innerHTML = `<span class="notif-message">${notification.message}</span>
                                             <span class="notif-time">${formattedTime}</span>`;
                    
                    const noNotifMessage = dropdown.querySelector('p');
                    if (noNotifMessage && noNotifMessage.textContent.includes('Aucune nouvelle notification')) {
                         dropdown.innerHTML = '';
                    }
                    
                    dropdown.prepend(newItemLink);
                };

                websocket.onclose = function(event) {
                    console.log("WebSocket déconnecté. Tentative de reconnexion...");
                    setTimeout(connectWebSocket, 5000); 
                };

                websocket.onerror = function(error) {
                    console.error("Erreur WebSocket:", error);
                };
            }

            connectWebSocket();
        }
        
        // Logique pour afficher/cacher le menu déroulant (attachée au bouton s'il existe)
        if (isDashboard) {
            document.getElementById('notification-toggle').addEventListener('click', function() {
                const dropdown = document.getElementById('notification-dropdown');
                if (dropdown.style.display === 'block') {
                    dropdown.style.display = 'none';
                } else {
                    dropdown.style.display = 'block';
                }
            });
        }
    </script>
</body>
</html>