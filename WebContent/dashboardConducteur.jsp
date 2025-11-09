<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="models.Conducteur" %>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    if (conducteur == null) {
        response.sendRedirect("connexion");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Conducteur</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 3em;
            margin-bottom: 10px;
        }
        
        .content {
            padding: 40px;
        }
        
        .welcome {
            text-align: center;
            font-size: 2em;
            color: #333;
            margin-bottom: 30px;
        }
        
        .info-card {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        
        .info-row {
            display: flex;
            padding: 15px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 700;
            width: 200px;
            color: #555;
        }
        
        .info-value {
            flex: 1;
            color: #333;
        }
        
        .btn-logout {
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(235, 51, 73, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚗</h1>
            <h2>Dashboard Conducteur</h2>
        </div>
        
        <div class="content">
            <div class="welcome">
                Hello, I'm <%= conducteur.getPrenom() %> <%= conducteur.getNom() %> (Conducteur)
            </div>
            
            <div class="info-card">
                <h3 style="margin-bottom: 20px; color: #555;">Informations Personnelles</h3>
                
                <div class="info-row">
                    <div class="info-label">ID:</div>
                    <div class="info-value"><%= conducteur.getIdUtilisateur() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Nom:</div>
                    <div class="info-value"><%= conducteur.getNom() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Prénom:</div>
                    <div class="info-value"><%= conducteur.getPrenom() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Email:</div>
                    <div class="info-value"><%= conducteur.getEmail() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Téléphone:</div>
                    <div class="info-value"><%= conducteur.getTelephone() != null ? conducteur.getTelephone() : "Non renseigné" %></div>
                </div>
            </div>
            
            <div class="info-card">
                <h3 style="margin-bottom: 20px; color: #555;">Informations Véhicule</h3>
                
                <div class="info-row">
                    <div class="info-label">Marque:</div>
                    <div class="info-value"><%= conducteur.getMarqueVehicule() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Modèle:</div>
                    <div class="info-value"><%= conducteur.getModeleVehicule() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Immatriculation:</div>
                    <div class="info-value"><%= conducteur.getImmatriculation() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Places disponibles:</div>
                    <div class="info-value"><%= conducteur.getNombrePlacesVehicule() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Note moyenne:</div>
                    <div class="info-value"><%= String.format("%.1f", conducteur.getNoteMoyenne()) %> / 5.0</div>
                </div>
            </div>
            
            <div style="text-align: center;">
                <a href="deconnexion" class="btn-logout">Se déconnecter</a>
            </div>
        </div>
    </div>
</body>
</html>