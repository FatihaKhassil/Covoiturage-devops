<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Réussie - Covoiturage</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 600px;
            width: 100%;
            text-align: center;
            animation: zoomIn 0.5s ease;
        }
        
        @keyframes zoomIn {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        .success-icon {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            padding: 40px;
            color: white;
        }
        
        .success-icon .icon {
            font-size: 5em;
            animation: bounce 1s ease infinite;
        }
        
        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }
        
        .content {
            padding: 40px;
        }
        
        h1 {
            font-size: 2em;
            color: #333;
            margin-bottom: 15px;
        }
        
        .message {
            font-size: 1.2em;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .user-info {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .info-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 700;
            width: 150px;
            color: #555;
        }
        
        .info-value {
            flex: 1;
            color: #333;
        }
        
        .badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 700;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .badge-conducteur {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .badge-passager {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .btn {
            flex: 1;
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            text-align: center;
            min-width: 180px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }
        
        .btn-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
        
        .btn-secondary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .next-steps {
            background: #fff3cd;
            border: 2px solid #ffc107;
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
            text-align: left;
        }
        
        .next-steps h3 {
            color: #856404;
            margin-bottom: 15px;
            font-size: 1.2em;
        }
        
        .next-steps ul {
            list-style: none;
            padding: 0;
        }
        
        .next-steps li {
            padding: 8px 0;
            color: #856404;
            position: relative;
            padding-left: 30px;
        }
        
        .next-steps li:before {
            content: "✓";
            position: absolute;
            left: 0;
            color: #28a745;
            font-weight: bold;
            font-size: 1.2em;
        }
        
        @media (max-width: 768px) {
            .btn-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">
            <div class="icon">✓</div>
            <h1 style="color: white; margin-top: 20px;">Inscription Réussie!</h1>
        </div>
        
        <div class="content">
            <p class="message">
                ${succes}
            </p>
            
            <div class="user-info">
                <div class="info-row">
                    <div class="info-label">Type de compte:</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${typeInscrit == 'conducteur'}">
                                <span class="badge badge-conducteur">🚗 Conducteur</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-passager">👤 Passager</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label">Votre ID:</div>
                    <div class="info-value">#${userId}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Statut:</div>
                    <div class="info-value" style="color: #28a745; font-weight: 700;">
                        ✓ Compte actif
                    </div>
                </div>
            </div>
            
            <div class="next-steps">
                <h3>📋 Prochaines étapes</h3>
                <ul>
                    <c:choose>
                        <c:when test="${typeInscrit == 'conducteur'}">
                            <li>Connectez-vous à votre compte</li>
                            <li>Proposez votre premier trajet</li>
                            <li>Attendez les réservations des passagers</li>
                            <li>Partagez vos trajets et gagnez de l'argent!</li>
                        </c:when>
                        <c:otherwise>
                            <li>Connectez-vous à votre compte</li>
                            <li>Recherchez des trajets disponibles</li>
                            <li>Réservez votre place</li>
                            <li>Voyagez en toute sécurité!</li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
            
            <div class="btn-group">
                <a href="connexion.jsp" class="btn btn-primary">
                    🔑 Se connecter
                </a>
                <a href="index.jsp" class="btn btn-secondary">
                    🏠 Accueil
                </a>
            </div>
        </div>
    </div>
    
    <script>
        // Optionnel: redirection automatique après 10 secondes
        // setTimeout(function() {
        //     window.location.href = 'connexion.jsp';
        // }, 10000);
    </script>
</body>
</html>