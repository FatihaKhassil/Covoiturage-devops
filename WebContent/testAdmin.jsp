<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.Administrateur" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Administrateur DAO</title>
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
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .content {
            padding: 30px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
            color: white;
        }
        
        .btn-info {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
        }
        
        tbody tr {
            border-bottom: 1px solid #e0e0e0;
            transition: background-color 0.3s ease;
        }
        
        tbody tr:hover {
            background-color: #f5f5f5;
        }
        
        .form-container {
            max-width: 600px;
            margin: 0 auto;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="tel"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        
        input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .details-card {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .details-row {
            display: flex;
            padding: 15px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }
        
        .details-label {
            font-weight: 700;
            width: 200px;
            color: #555;
        }
        
        .details-value {
            flex: 1;
            color: #333;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .badge-success {
            background-color: #38ef7d;
            color: white;
        }
        
        .badge-danger {
            background-color: #eb3349;
            color: white;
        }
        
        .action-links {
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔧 Test Administrateur DAO</h1>
            <p>Interface de test pour la gestion des administrateurs</p>
        </div>
        
        <div class="content">
            <!-- Messages de succès/erreur -->
            <c:if test="${not empty succes}">
                <div class="alert alert-success">
                    ✓ ${succes}
                </div>
            </c:if>
            
            <c:if test="${not empty erreur}">
                <div class="alert alert-error">
                    ✗ ${erreur}
                </div>
            </c:if>
            
            <!-- Boutons de navigation -->
            <div class="btn-group">
                <a href="testAdmin?action=liste" class="btn btn-primary">📋 Liste des admins</a>
                <a href="testAdmin?action=formulaire" class="btn btn-success">➕ Créer admin</a>
            </div>
            
            <!-- Affichage selon l'action -->
            <c:choose>
                <%-- Formulaire de création --%>
                <c:when test="${action == 'formulaire'}">
                    <div class="form-container">
                        <h2>Créer un nouvel administrateur</h2>
                        <form action="testAdmin" method="post">
                            <input type="hidden" name="action" value="creer">
                            
                            <div class="form-group">
                                <label for="nom">Nom *</label>
                                <input type="text" id="nom" name="nom" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="prenom">Prénom *</label>
                                <input type="text" id="prenom" name="prenom" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email *</label>
                                <input type="email" id="email" name="email" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="motDePasse">Mot de passe *</label>
                                <input type="password" id="motDePasse" name="motDePasse" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="telephone">Téléphone</label>
                                <input type="tel" id="telephone" name="telephone">
                            </div>
                            
                            <button type="submit" class="btn btn-success">💾 Enregistrer</button>
                        </form>
                    </div>
                </c:when>
                
                <%-- Détails d'un administrateur --%>
                <c:when test="${action == 'details'}">
                    <div class="details-card">
                        <h2>Détails de l'administrateur</h2>
                        <div class="details-row">
                            <div class="details-label">ID:</div>
                            <div class="details-value">${admin.idUtilisateur}</div>
                        </div>
                        <div class="details-row">
                            <div class="details-label">Nom:</div>
                            <div class="details-value">${admin.nom}</div>
                        </div>
                        <div class="details-row">
                            <div class="details-label">Prénom:</div>
                            <div class="details-value">${admin.prenom}</div>
                        </div>
                        <div class="details-row">
                            <div class="details-label">Email:</div>
                            <div class="details-value">${admin.email}</div>
                        </div>
                        <div class="details-row">
                            <div class="details-label">Téléphone:</div>
                            <div class="details-value">${admin.telephone}</div>
                        </div>
                        <div class="details-row">
                            <div class="details-label">Date d'inscription:</div>
                            <div class="details-value">${admin.dateInscription}</div>
                        </div>
                        <div class="details-row">
                            <div class="details-label">Statut:</div>
                            <div class="details-value">
                                <c:choose>
                                    <c:when test="${admin.estActif}">
                                        <span class="badge badge-success">Actif</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Inactif</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:when>
                
                <%-- Liste des administrateurs --%>
                <c:otherwise>
                    <h2>Liste des administrateurs</h2>
                    <c:choose>
                        <c:when test="${not empty administrateurs}">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nom</th>
                                        <th>Prénom</th>
                                        <th>Email</th>
                                        <th>Téléphone</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="admin" items="${administrateurs}">
                                        <tr>
                                            <td>${admin.idUtilisateur}</td>
                                            <td>${admin.nom}</td>
                                            <td>${admin.prenom}</td>
                                            <td>${admin.email}</td>
                                            <td>${admin.telephone}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${admin.estActif}">
                                                        <span class="badge badge-success">Actif</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-danger">Inactif</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-links">
                                                    <a href="testAdmin?action=details&id=${admin.idUtilisateur}" 
                                                       class="btn btn-info">👁️ Voir</a>
                                                    <a href="testAdmin?action=supprimer&id=${admin.idUtilisateur}" 
                                                       class="btn btn-danger"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet administrateur?')">
                                                       🗑️ Supprimer
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-error">
                                Aucun administrateur trouvé dans la base de données.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>