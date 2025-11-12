<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur" %>
<%@ page import="models.Offre" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    String typeUtilisateur = (String) session.getAttribute("typeUtilisateur");
    
    if (conducteur == null || !"conducteur".equals(typeUtilisateur)) {
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
    <title>Dashboard Conducteur - Covoiturage</title>
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
            background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
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
            color: #f39c12;
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
            background: rgba(52, 152, 219, 0.3);
            border-left: 4px solid #3498db;
        }
        
        .nav-item a i {
            margin-right: 12px;
            font-size: 18px;
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
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
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
        
        <!-- Main Content -->
        <main class="main-content">
            <%
           
            // Inclusion conditionnelle selon la page
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
            <!-- Contenu du Dashboard -->
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
            
            <!-- Recent Activity -->
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
                        
                        .status-active {
                            background: #d4edda;
                            color: #155724;
                        }
                        
                        .status-full {
                            background: #fff3cd;
                            color: #856404;
                        }
                        
                        .status-completed {
                            background: #d1ecf1;
                            color: #0c5460;
                        }
                        
                        .status-cancelled {
                            background: #f8d7da;
                            color: #721c24;
                        }
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
            } else if ("offres".equals(currentPage)) {
        %>
                <!-- Inclure la page de gestion des offres -->
                <jsp:include page="gererOffres.jsp" />
            <%
                } else if ("publier".equals(currentPage)) {
            %>
                <!-- Inclure le formulaire de publication -->
                <jsp:include page="publierTrajet.jsp" />
            <%
                } else if ("demandes".equals(currentPage)) {
            %>
                <!-- Inclure la page des demandes de réservation -->
                <jsp:include page="demandesReservation.jsp" />
            <%
                } else if ("evaluations".equals(currentPage)) {
            %>
                <!-- Inclure la page des évaluations -->
                <jsp:include page="evaluationsRecues.jsp" />
            <%
                } else if ("profil".equals(currentPage)) {
            %>
                <!-- Inclure la page du profil -->
                <jsp:include page="ConProfil.jsp" />
            <%
                }
            %>
        </main>
    </div>
</body>
</html>