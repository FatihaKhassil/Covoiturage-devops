<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - CIV</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-container {
            display: flex;
            width: 100%;
            background: white;
            border-radius: 0;
            box-shadow: none;
            overflow: hidden;
            min-height: auto;
        }
        
        .form-section {
            flex: 0.6;
            padding: 40px 35px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: white;
        }
        
        .image-section {
            flex: 1.4;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        
        .image-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('includes/assets/img_con.png') center/contain no-repeat;
            opacity: 1;
        }
        
        .image-overlay {
            position: relative;
            z-index: 2;
            text-align: center;
            color: white;
            max-width: 400px;
            display: none;
        }
        
        .logo {
            margin-bottom: 30px;
        }
        
        .logo h1 {
            font-size: 2.2em;
            color: #1e293b;
            margin-bottom: 8px;
            font-weight: 700;
        }
        
        .logo p {
            color: #64748b;
            font-size: 0.95em;
            font-weight: 400;
            line-height: 1.5;
        }
        
        .alert {
            padding: 14px 18px;
            margin-bottom: 25px;
            border-radius: 10px;
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9em;
        }
        
        .alert::before {
            content: '⚠';
            font-size: 1.2em;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
        }
        
        input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: white;
            font-family: inherit;
        }
        
        input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        input::placeholder {
            color: #9ca3af;
        }
        
        .btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transition: all 0.3s ease;
            margin-top: 10px;
            font-family: inherit;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.35);
        }

        .btn:active {
            transform: translateY(0);
        }
        
        .link-container {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
            color: #6b7280;
            font-size: 0.95em;
        }
        
        .link-container a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .link-container a:hover {
            color: #5a67d8;
            text-decoration: underline;
        }
        
        /* Responsive Design */
        @media (max-width: 968px) {
            .login-container {
                flex-direction: column;
            }
            
            .form-section {
                flex: 1;
                padding: 40px 30px;
            }
            
            .image-section {
                flex: 1;
                min-height: 300px;
            }
            
            .logo h1 {
                font-size: 1.8em;
            }
        }
        
        @media (max-width: 480px) {
            .form-section {
                padding: 30px 20px;
            }
            
            .logo h1 {
                font-size: 1.5em;
            }

            .image-section {
                min-height: 250px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Section Formulaire (Gauche) -->
        <div class="form-section">
            <div class="logo">
                <h1>Bienvenue sur CIV</h1>
                <p>Rejoignez notre communauté de covoiturage</p>
            </div>
            
            <c:if test="${not empty erreur}">
                <div class="alert">
                    ${erreur}
                </div>
            </c:if>
            
            <form action="connexion" method="post">
                <div class="form-group">
                    <label for="email">Adresse Email</label>
                    <input type="email" id="email" name="email" required 
                           placeholder="exemple@email.com">
                </div>
                
                <div class="form-group">
                    <label for="motDePasse">Mot de passe</label>
                    <input type="password" id="motDePasse" name="motDePasse" required 
                           placeholder="Votre mot de passe">
                </div>
                
                <button type="submit" class="btn">Se connecter</button>
            </form>
            
            <div class="link-container">
                Nouveau sur CIV ? <a href="inscription">Créer un compte</a>
            </div>
        </div>
        
        <!-- Section Image (Droite) -->
        <div class="image-section">
            <div class="image-overlay">
                <h2>Bienvenue sur CIV</h2>
                <p>Rejoignez notre communauté de covoiturage et voyagez de manière écologique et économique</p>
            </div>
        </div>
    </div>
</body>
</html>