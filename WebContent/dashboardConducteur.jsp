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
    <title>Dashboard Conducteur - CIV</title>
    <style>
        /* RESET ET BASE */
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        
        body { 
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; 
            background: #f8fafc; 
            color: #334155;
            line-height: 1.6;
        }
        
        .container { 
            display: flex; 
            min-height: 100vh; 
        }
        
        /* SIDEBAR PROFESSIONNELLE */
        .sidebar { 
    width: 280px; 
    background: #607D8B; /* couleur demandée */
    color: #f1f5f9; 
    position: fixed; 
    height: 100vh; 
    overflow-y: auto;
    border-right: 1px solid #334155;
}

.sidebar-header {
    height: 150px;                      /* taille idéale */
    background: #607D8B;                /* même couleur que la sidebar */
    border-bottom: 1px solid #334155;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 0;
    overflow: hidden;                   /* empêche tout dépassement */
}



        
        .logo-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }
        
.logo-image {
    height: 80%;       /* taille équilibrée */
    width: auto;
    max-width: 90%;    /* évite qu’il soit trop large */
    object-fit: contain;
}


        
        .logo-text {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .logo { 
            font-size: 24px; 
            font-weight: 700; 
            color: #ffffff;
            letter-spacing: 1px;
        }
        
        .logo-subtitle { 
            font-size: 11px; 
            color: #94a3b8; 
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-top: 4px;
        }
        
        .user-info { 
            padding: 20px; 
            background: #1e293b; 
            border-bottom: 1px solid #334155; 
        }
        
        .user-info h3 { 
            font-size: 16px; 
            font-weight: 500; 
            margin-bottom: 4px; 
            color: #f1f5f9;
        }
        
        .user-info p { 
            font-size: 14px; 
            color: #94a3b8; 
            margin-bottom: 8px;
        }
        
        .user-rating span { 
            color: #f59e0b; 
            font-weight: 500;
        }
        
        .nav-menu { 
            padding: 16px 0; 
        }
        
        .nav-item { 
            margin: 4px 16px; 
        }
        
        .nav-item a { 
            display: flex; 
            align-items: center; 
            padding: 12px 16px; 
            color: #cbd5e1; 
            text-decoration: none; 
            border-radius: 6px; 
            transition: all 0.2s ease; 
            font-size: 14px;
            font-weight: 400;
        }
        
        .nav-item a:hover { 
            background: #334155; 
            color: #f1f5f9;
        }
        
        .nav-item a.active {
    background: #4b5563;  /* même couleur que déconnexion */
    color: white;
    font-weight: 500;
}

        
        .logout-section { 
            padding: 20px; 
            border-top: 1px solid #334155; 
            margin-top: auto;
        }
        
        .logout-btn { 
            display: block; 
            width: 100%; 
            padding: 12px; 
            background: #475569; 
            color: white; 
            text-align: center; 
            text-decoration: none; 
            border-radius: 6px; 
            transition: background 0.2s; 
            font-size: 14px;
            font-weight: 500;
        }
        
    .logout-btn:hover {
    background: #374151 !important;
}

        
        /* MAIN CONTENT */
        .main-content { 
            margin-left: 280px; 
            flex: 1; 
            padding: 32px; 
        }
        
        .top-bar { 
            background: white; 
            padding: 24px 32px; 
            border-radius: 8px; 
            margin-bottom: 32px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            border: 1px solid #e2e8f0;
        }
        
        .top-bar h1 { 
            font-size: 24px; 
            color: #1e293b; 
            font-weight: 600;
        }
        
        .breadcrumb { 
            color: #64748b; 
            font-size: 14px; 
            margin-top: 4px;
        }
        
        /* STATS CARDS PROFESSIONNELLES */
        .stats-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); 
            gap: 20px; 
            margin-bottom: 32px; 
        }
        
        .stat-card { 
            background: white; 
            padding: 24px; 
            border-radius: 8px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); 
            transition: transform 0.2s; 
            border: 1px solid #e2e8f0;
        }
        
        .stat-card:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); 
        }
        
        .stat-card-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 16px; 
        }
        
        .stat-card h3 { 
            font-size: 13px; 
            color: #64748b; 
            text-transform: uppercase; 
            letter-spacing: 0.5px; 
            font-weight: 500;
        }
        
        .stat-icon { 
            width: 48px; 
            height: 48px; 
            border-radius: 8px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 20px; 
        }
        
        .stat-card .value { 
            font-size: 28px; 
            font-weight: 700; 
            color: #1e293b; 
        }
        
        .stat-card .label { 
            font-size: 13px; 
            color: #64748b; 
            margin-top: 4px; 
        }
        
        .blue { background: #dbeafe; color: #1d4ed8; }
        .green { background: #dcfce7; color: #15803d; }
        .orange { background: #ffedd5; color: #c2410c; }
        .purple { background: #f3e8ff; color: #7e22ce; }
        
        /* CONTENT SECTIONS */
        .content-section { 
            background: white; 
            padding: 24px; 
            border-radius: 8px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); 
            border: 1px solid #e2e8f0;
        }
        
        .section-header { 
            margin-bottom: 20px; 
            padding-bottom: 16px; 
            border-bottom: 1px solid #e2e8f0; 
        }
        
        .section-header h2 { 
            font-size: 18px; 
            color: #1e293b; 
            font-weight: 600;
        }
        
        /* NOTIFICATIONS PROFESSIONNELLES */
        .notification-container { 
            position: relative; 
            display: inline-block; 
        }
        
        .notification-btn { 
            background: #f8fafc; 
            border: 1px solid #e2e8f0; 
            cursor: pointer; 
            padding: 8px 12px; 
            border-radius: 6px; 
            position: relative; 
            transition: background 0.2s;
        }
        
        .notification-btn:hover {
            background: #f1f5f9;
        }
        
        .badge { 
            position: absolute; 
            top: -4px; 
            right: -4px; 
            background: #dc2626; 
            color: white; 
            border-radius: 50%; 
            padding: 2px 6px; 
            font-size: 11px; 
            font-weight: 600; 
            display: none; 
            min-width: 18px;
            text-align: center;
        }
        
        .badge.active { 
            display: block; 
        }
        
        .notification-dropdown { 
            display: none; 
            position: absolute; 
            right: 0; 
            top: 48px; 
            width: 320px; 
            max-height: 400px; 
            overflow-y: auto; 
            background: white; 
            border: 1px solid #e2e8f0; 
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15); 
            z-index: 1000; 
            border-radius: 8px; 
        }
        
        .dropdown-item { 
            padding: 12px 16px; 
            border-bottom: 1px solid #f1f5f9; 
            font-size: 14px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            text-decoration: none; 
            color: inherit; 
            transition: background 0.2s;
        }
        
        .dropdown-item:last-child { 
            border-bottom: none; 
        }
        
        .dropdown-item.unseen { 
            background-color: #f0f9ff; 
            font-weight: 500; 
            border-left: 3px solid #3b82f6;
        }
        
        .dropdown-item:hover { 
            background-color: #f8fafc; 
        }
        
        .dropdown-footer { 
            padding: 12px 16px; 
            text-align: center; 
            border-top: 1px solid #e2e8f0; 
            background: #f8fafc;
        }
        
        .dropdown-footer a {
            color: #3b82f6;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
        }
        
        /* ACTIVITY LIST */
        .activity-list { 
            display: flex; 
            flex-direction: column; 
            gap: 12px; 
        }
        
        .activity-item { 
            display: flex; 
            align-items: center; 
            padding: 16px; 
            background: #f8fafc; 
            border-radius: 6px; 
            border-left: 4px solid #3b82f6; 
            transition: all 0.2s; 
        }
        
        .activity-item:hover { 
            background: #f1f5f9; 
            transform: translateX(2px); 
        }
        
        .activity-icon { 
            width: 44px; 
            height: 44px; 
            background: white; 
            border-radius: 8px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 18px; 
            margin-right: 16px; 
            border: 1px solid #e2e8f0;
        }
        
        .activity-details { 
            flex: 1; 
        }
        
        .activity-details h4 { 
            font-size: 15px; 
            color: #1e293b; 
            margin-bottom: 4px; 
            font-weight: 500;
        }
        
        .activity-details p { 
            font-size: 13px; 
            color: #64748b; 
        }
        
        .activity-status { 
            padding: 4px 12px; 
            border-radius: 12px; 
            font-size: 11px; 
            font-weight: 600; 
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-active { background: #dcfce7; color: #15803d; }
        .status-full { background: #fef9c3; color: #a16207; }
        .status-completed { background: #dbeafe; color: #1e40af; }
        .status-cancelled { background: #fee2e2; color: #b91c1c; }
    </style>
</head>
<body>
    <div class="container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="logo-container">
                    <img src="includes/assets/logo.png" alt="CIV Logo" class="logo-image">
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
                            <a href="Conducteur?page=publier" style="color: #3b82f6; text-decoration: none; font-weight: 600;">Publiez votre première offre</a>
                        </p>
                    <% } else { %>
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
                            <a href="Conducteur?page=offres" style="color: #3b82f6; text-decoration: none; font-weight: 600;">
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
        const appName = "CIV"; 
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

                    alert(🔔 Nouvelle alerte: ${notification.message}); 
                    
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