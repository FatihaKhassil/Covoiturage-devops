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
    <title>Dashboard Passager - Covoiturage</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
        }
        
        .container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .sidebar-header {
            padding: 25px 20px;
            background: rgba(0,0,0,0.2);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .sidebar-header h2 {
            font-size: 22px;
            margin-bottom: 5px;
        }
        
        .sidebar-header p {
            font-size: 13px;
            opacity: 0.8;
        }
        
        .user-info {
            padding: 20px;
            background: rgba(0,0,0,0.15);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .user-info h3 {
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .user-info p {
            font-size: 13px;
            opacity: 0.7;
        }
        
        .user-rating {
            margin-top: 8px;
            font-size: 14px;
        }
        
        .user-rating span {
            color: #ffd700;
        }
        
        .nav-menu {
            padding: 15px 0;
        }
        
        .nav-item {
            margin: 5px 15px;
        }
        
        .nav-item a {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .nav-item a:hover {
            background: rgba(255,255,255,0.1);
            transform: translateX(5px);
        }
        
        .nav-item a.active {
            background: rgba(255,255,255,0.2);
            border-left: 4px solid #fff;
        }
        
        .logout-section {
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        .logout-btn {
            display: block;
            width: 100%;
            padding: 12px;
            background: #e74c3c;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 8px;
            transition: background 0.3s;
        }
        
        .logout-btn:hover {
            background: #c0392b;
        }
        
        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 30px;
        }
        
        .top-bar {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .top-bar h1 {
            font-size: 28px;
            color: #2c3e50;
        }
        
        .breadcrumb {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .stat-card h3 {
            font-size: 14px;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        
        .stat-card .value {
            font-size: 32px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .stat-card .label {
            font-size: 13px;
            color: #95a5a6;
            margin-top: 5px;
        }
        
        .blue { background: #e3f2fd; color: #2196f3; }
        .green { background: #e8f5e9; color: #4caf50; }
        .orange { background: #fff3e0; color: #ff9800; }
        .purple { background: #f3e5f5; color: #9c27b0; }
        
        /* Content Section */
        .content-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .section-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #ecf0f1;
        }
        
        .section-header h2 {
            font-size: 22px;
            color: #2c3e50;
        }
        
        /* Alert Messages */
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* NOUVEAU CSS POUR LES NOTIFICATIONS */
        .notification-container {
            position: relative;
            display: inline-block;
        }

        .notification-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px;
            position: relative;
        }

        .badge {
            position: absolute;
            top: 0;
            right: 0;
            background: #e74c3c;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 10px;
            font-weight: bold;
            display: none;
        }

        .badge.active {
            display: block;
        }

        .notification-dropdown {
            display: none;
            position: absolute;
            right: 0;
            top: 50px;
            width: 300px;
            max-height: 400px;
            overflow-y: auto;
            background: white;
            border: 1px solid #ccc;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            border-radius: 8px;
        }

        .dropdown-item {
            padding: 10px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-item.unseen {
            background-color: #f7f7f7;
            font-weight: 600;
        }

        .dropdown-item:hover {
            background-color: #f0f0f0;
        }

        .dropdown-footer {
            padding: 10px;
            text-align: center;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>🚗 Covoiturage</h2>
                <p>Espace Passager</p>
            </div>
            
            <div class="user-info">
                <h3><%= passager.getPrenom() %> <%= passager.getNom() %></h3>
                <p><%= passager.getEmail() %></p>
                <div class="user-rating">
                    ⭐ <span><%= String.format("%.1f", passager.getNoteMoyenne()) %>/5</span>
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
        // Toggle notification dropdown
        document.getElementById('notification-toggle').addEventListener('click', function() {
            const dropdown = document.getElementById('notification-dropdown');
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            const container = document.querySelector('.notification-container');
            if (!container.contains(event.target)) {
                document.getElementById('notification-dropdown').style.display = 'none';
            }
        });

        // WebSocket pour notifications en temps réel
        const currentUserId = "<%= passager.getId() %>";
        const appName = "Covoiturage"; // REMPLACER PAR LE NOM DE VOTRE CONTEXTE

        if (currentUserId && currentUserId !== "null") {
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
                    console.log("Notification temps réel reçue:", notification);

                    // Mettre à jour le badge
                    const badge = document.getElementById('notification-badge');
                    let count = parseInt(badge.textContent);
                    badge.textContent = count + 1;
                    badge.classList.add('active');

                    // Afficher une alerte
                    alert(`🔔 Nouvelle notification: ${notification.message}`);
                    
                    // Formater l'heure actuelle
                    const now = new Date();
                    const formattedTime = now.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });

                    // Mettre à jour le dropdown
                    const dropdown = document.getElementById('notification-dropdown');
                    const newItem = document.createElement('div');
                    
                    newItem.className = 'dropdown-item unseen';
                    newItem.innerHTML = `<span class="notif-message">${notification.message}</span>
                                         <span class="notif-time">${formattedTime}</span>`;
                    
                    // Supprimer le message "Aucune notification" si présent
                    const noNotifMessage = dropdown.querySelector('p');
                    if (noNotifMessage && noNotifMessage.textContent.includes('Aucune nouvelle notification')) {
                         dropdown.innerHTML = '';
                    }
                    
                    dropdown.prepend(newItem);
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
    </script>
</body>
</html>