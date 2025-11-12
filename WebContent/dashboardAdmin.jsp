<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Administrateur" %>
<%@ page import="models.Offre" %>
<%@ page import="models.Conducteur" %>
<%@ page import="models.Passager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    Administrateur admin = (Administrateur) session.getAttribute("utilisateur");
    String typeUtilisateur = (String) session.getAttribute("typeUtilisateur");
    
    if (admin == null || !"administrateur".equals(typeUtilisateur)) {
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
    <title>Dashboard Administrateur - Covoiturage</title>
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
            background: linear-gradient(180deg, #e74c3c 0%, #c0392b 100%);
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
        
        .admin-badge {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            margin-top: 8px;
            font-weight: 600;
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
            background: rgba(0,0,0,0.3);
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 8px;
            transition: background 0.3s;
        }
        
        .logout-btn:hover {
            background: rgba(0,0,0,0.5);
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
        
        .red { background: #ffebee; color: #e74c3c; }
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
                <h2>🛡️ Administration</h2>
                <p>Panneau de Contrôle</p>
            </div>
            
            <div class="user-info">
                <h3><%= admin.getPrenom() %> <%= admin.getNom() %></h3>
                <p><%= admin.getEmail() %></p>
                <span class="admin-badge">👑 ADMINISTRATEUR</span>
            </div>
            
            <nav class="nav-menu">
                <div class="nav-item">
                    <a href="Admin?page=dashboard" class="<%= "dashboard".equals(currentPage) ? "active" : "" %>">
                        📊 Tableau de Bord
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Admin?page=utilisateurs" class="<%= "utilisateurs".equals(currentPage) ? "active" : "" %>">
                        👥 Gestion Utilisateurs
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Admin?page=validation" class="<%= "validation".equals(currentPage) ? "active" : "" %>">
                        ✅ Validation Offres
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Admin?page=rapports" class="<%= "rapports".equals(currentPage) ? "active" : "" %>">
                        📈 Rapports et Stats
                    </a>
                </div>
                <div class="nav-item">
                    <a href="Admin?page=profil" class="<%= "profil".equals(currentPage) ? "active" : "" %>">
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
                <jsp:include page="admin_dashboard.jsp" />
            <%
                } else if ("utilisateurs".equals(currentPage)) {
            %>
                <jsp:include page="gestion_utilisateurs.jsp" />
            <%
                } else if ("validation".equals(currentPage)) {
            %>
                <jsp:include page="validation_offres.jsp" />
            <%
                } else if ("rapports".equals(currentPage)) {
            %>
                <jsp:include page="rapports.jsp" />
            <%
                } else if ("profil".equals(currentPage)) {
            %>
                <jsp:include page="AdmProfil.jsp" />
            <%
                }
            %>
        </main>
    </div>
</body>
</html>