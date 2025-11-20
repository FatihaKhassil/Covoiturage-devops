<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Passager, models.Offre, models.Reservation, models.Notification, java.util.List, java.text.SimpleDateFormat" %>
<%
    Passager passager = (Passager) session.getAttribute("utilisateur");
    String typeUtilisateur = (String) session.getAttribute("typeUtilisateur");
    Long passagerId = passager.getId();
    Integer nbNotifNonLues = (Integer) request.getAttribute("nbNotifNonLues");
    List<Notification> dernieresNotifs = (List<Notification>) request.getAttribute("dernieresNotifs");

    if (nbNotifNonLues == null) nbNotifNonLues = 0;
    if (dernieresNotifs == null) dernieresNotifs = new java.util.ArrayList<>();
    
    if (passager == null || !"passager".equals(typeUtilisateur)) {
        response.sendRedirect("connexion.jsp");
        return;
    }
    
    String currentPage = (String) request.getAttribute("page");
    if (currentPage == null) currentPage = "dashboard";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Passager - CIV</title>
    <style>
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
    
    /* SIDEBAR PROFESSIONNELLE - MÊME STYLE QUE CONDUCTEUR */
    .sidebar {
        width: 280px;
        background: #607D8B; /* même couleur que conducteur */
        color: #f1f5f9;
        position: fixed;
        height: 100vh;
        overflow-y: auto;
        border-right: 1px solid #334155;
    }
    
    .sidebar-header {
        height: 150px;
        background: #607D8B;
        border-bottom: 1px solid #334155;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0;
        overflow: hidden;
    }
    
    .logo-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 12px;
    }
    
    .logo-image {
        height: 80%;
        width: auto;
        max-width: 90%;
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
    
    .user-rating {
        margin-top: 8px;
        font-size: 14px;
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
        background: #4b5563; /* même couleur que conducteur */
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
        background: #475569; /* même couleur que conducteur */
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
    
    /* ALERT MESSAGES PROFESSIONNELLES */
    .alert {
        padding: 16px 20px;
        border-radius: 6px;
        margin-bottom: 20px;
        font-weight: 500;
        font-size: 14px;
        border: 1px solid;
    }
    
    .alert-success {
        background: #f0fdf4;
        color: #15803d;
        border-color: #bbf7d0;
    }
    
    .alert-error {
        background: #fef2f2;
        color: #b91c1c;
        border-color: #fecaca;
    }
    
    /* NOTIFICATIONS PROFESSIONNELLES - MÊME STYLE QUE CONDUCTEUR */
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
    
    /* ACTIVITY LIST - MÊME STYLE QUE CONDUCTEUR */
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
    
    .status-pending { background: #fef9c3; color: #a16207; }
    .status-confirmed { background: #dcfce7; color: #15803d; }
    .status-completed { background: #dbeafe; color: #1e40af; }
    .status-cancelled { background: #fee2e2; color: #b91c1c; }
</style>
</head>
<body>
    <div class="container">
        <!-- Sidebar avec le même style que conducteur -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="logo-container">
                    <img src="includes/assets/logo.png" alt="CIV Logo" class="logo-image">
                </div>
            </div>
            
            <nav class="nav-menu">
                <div class="nav-item">
                    <a href="Passager?page=dashboard" class="<%= "dashboard".equals(currentPage) ? "active" : "" %>">
                        📊 Tableau de Bord
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Passager?page=rechercher" class="<%= "rechercher".equals(currentPage) ? "active" : "" %>">
                        🔍 Rechercher un Trajet
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Passager?page=reservations" class="<%= "reservations".equals(currentPage) ? "active" : "" %>">
                        📋 Mes Réservations
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Passager?page=historique" class="<%= "historique".equals(currentPage) ? "active" : "" %>">
                        📜 Historique
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Passager?page=evaluations" class="<%= "evaluations".equals(currentPage) ? "active" : "" %>">
                        ⭐ Évaluations Reçues
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Passager?page=profil" class="<%= "profil".equals(currentPage) ? "active" : "" %>">
                        👤 Mon Profil
                    </a>
                </div>
            </nav>
            
            <div class="logout-section">
                <a href="DeconnexionServlet" class="logout-btn">🚪 Déconnexion</a>
            </div>
        </aside>
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Top-bar UNIQUEMENT si ce n'est pas le dashboard -->
            <% if (!"dashboard".equals(currentPage)) { %>
                <div class="top-bar">
                    <div>
                        <% 
                            String pageTitle = currentPage.substring(0, 1).toUpperCase() + currentPage.substring(1)
                                .replace("rechercher", "Rechercher un Trajet")
                                .replace("reservations", "Mes Réservations")
                                .replace("historique", "Historique")
                                .replace("evaluations", "Évaluations Reçues")
                                .replace("profil", "Mon Profil");
                        %>
                        <h1><%= pageTitle %></h1>
                        <div class="breadcrumb">Accueil / <%= pageTitle %></div>
                    </div>
                </div>
            <% } %>

            <%
                // Messages d'alerte
                String success = (String) session.getAttribute("success");
                String error = (String) session.getAttribute("error");
                
                if (success != null) {
                    session.removeAttribute("success");
            %>
                <div class="alert alert-success">✅ <%= success %></div>
            <%
                }
                if (error != null) {
                    session.removeAttribute("error");
            %>
                <div class="alert alert-error">❌ <%= error %></div>
            <%
                }
                
                // Inclusion conditionnelle selon la page
                if ("dashboard".equals(currentPage)) {
            %>
                <jsp:include page="passagerDashboard.jsp" />
            <%
                } else if ("rechercher".equals(currentPage)) {
            %>
                <jsp:include page="rechercherTrajet.jsp" />
            <%
                } else if ("reservations".equals(currentPage)) {
            %>
                <jsp:include page="mesReservations.jsp" />
            <%
                } else if ("historique".equals(currentPage)) {
            %>
                <jsp:include page="historiquePassager.jsp" />
            <%
                } else if ("evaluations".equals(currentPage)) {
            %>
                <jsp:include page="evaluationsPassager.jsp" />
            <%
                } else if ("profil".equals(currentPage)) {
            %>
                <jsp:include page="PassProfil.jsp" />
            <%
                }
            %>
        </main>
    </div>

    <script>
        // Récupération de l'ID utilisateur
        const currentUserId = "<%= passager.getId() %>";
        const appName = "CIV"; 
        const isDashboard = ("<%= currentPage %>" === "dashboard");

        if (currentUserId && currentUserId !== "null" && isDashboard) {
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
                    const newItemLink = document.createElement('a');
                    
                    newItemLink.href = "Passager?page=reservations";
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
            const notificationToggle = document.getElementById('notification-toggle');
            if (notificationToggle) {
                notificationToggle.addEventListener('click', function() {
                    const dropdown = document.getElementById('notification-dropdown');
                    if (dropdown.style.display === 'block') {
                        dropdown.style.display = 'none';
                    } else {
                        dropdown.style.display = 'block';
                    }
                });
            }
        }
    </script>
</body>
</html>