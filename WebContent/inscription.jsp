<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Covoiturage</title>
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
            animation: slideIn 0.5s ease;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .form-content {
            padding: 40px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 10px;
            font-weight: 500;
            animation: fadeIn 0.3s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .alert-error {
            background-color: #fee;
            color: #c33;
            border: 2px solid #fcc;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 0.95em;
        }
        
        .required {
            color: #e74c3c;
            margin-left: 3px;
        }
        
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="tel"],
        input[type="number"],
        select {
            width: 100%;
            padding: 14px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            font-family: inherit;
        }
        
        input:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        select {
            cursor: pointer;
            background-color: white;
        }
        
        .role-selector {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .role-option {
            position: relative;
        }
        
        .role-option input[type="radio"] {
            position: absolute;
            opacity: 0;
        }
        
        .role-card {
            padding: 25px;
            border: 3px solid #e0e0e0;
            border-radius: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }
        
        .role-card:hover {
            border-color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .role-option input[type="radio"]:checked + .role-card {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
        }
        
        .role-icon {
            font-size: 3em;
            margin-bottom: 10px;
        }
        
        .role-title {
            font-weight: 700;
            font-size: 1.2em;
            color: #333;
            margin-bottom: 5px;
        }
        
        .role-description {
            font-size: 0.9em;
            color: #666;
        }
        
        .specific-fields {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        
        .specific-fields.active {
            display: block;
        }
        
        .fields-header {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
            color: #555;
        }
        
        .btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
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
        
        .btn-primary:active {
            transform: translateY(0);
        }
        
        .btn-primary:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .input-hint {
            font-size: 0.85em;
            color: #666;
            margin-top: 5px;
        }
        
        .link-container {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #e0e0e0;
        }
        
        .link-container a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .link-container a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .role-selector {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .form-content {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚗 Inscription</h1>
            <p>Rejoignez notre communauté de covoiturage</p>
        </div>
        
        <div class="form-content">
            <c:if test="${not empty erreur}">
                <div class="alert alert-error">
                    ✗ ${erreur}
                </div>
            </c:if>
            
            <form action="inscription" method="post" id="inscriptionForm">
                <!-- Sélection du rôle -->
                <div class="form-group">
                    <label>Vous êtes :<span class="required">*</span></label>
                    <div class="role-selector">
                        <div class="role-option">
                            <input type="radio" name="typeUtilisateur" id="conducteur" value="conducteur" required>
                            <label for="conducteur" class="role-card">
                                <div class="role-icon">🚗</div>
                                <div class="role-title">Conducteur</div>
                                <div class="role-description">Je propose des trajets</div>
                            </label>
                        </div>
                        
                        <div class="role-option">
                            <input type="radio" name="typeUtilisateur" id="passager" value="passager" required>
                            <label for="passager" class="role-card">
                                <div class="role-icon">👤</div>
                                <div class="role-title">Passager</div>
                                <div class="role-description">Je recherche des trajets</div>
                            </label>
                        </div>
                    </div>
                </div>
                
                <!-- Champs communs -->
                <div class="form-group">
                    <label for="nom">Nom<span class="required">*</span></label>
                    <input type="text" id="nom" name="nom" required placeholder="Votre nom">
                </div>
                
                <div class="form-group">
                    <label for="prenom">Prénom<span class="required">*</span></label>
                    <input type="text" id="prenom" name="prenom" required placeholder="Votre prénom">
                </div>
                
                <div class="form-group">
                    <label for="email">Email<span class="required">*</span></label>
                    <input type="email" id="email" name="email" required placeholder="votre.email@exemple.com">
                </div>
                
                <div class="form-group">
                    <label for="motDePasse">Mot de passe<span class="required">*</span></label>
                    <input type="password" id="motDePasse" name="motDePasse" required 
                           placeholder="Minimum 6 caractères" minlength="6">
                    <div class="input-hint">Minimum 6 caractères</div>
                </div>
                
                <div class="form-group">
                    <label for="telephone">Téléphone</label>
                    <input type="tel" id="telephone" name="telephone" placeholder="0612345678">
                </div>
                
                <!-- Champs spécifiques au conducteur -->
                <div id="champtsConducteur" class="specific-fields">
                    <div class="fields-header">
                        🚗 Informations sur votre véhicule
                    </div>
                    
                    <div class="form-group">
                        <label for="marqueVehicule">Marque du véhicule<span class="required">*</span></label>
                        <input type="text" id="marqueVehicule" name="marqueVehicule" 
                               placeholder="Ex: Peugeot, Renault...">
                    </div>
                    
                    <div class="form-group">
                        <label for="modeleVehicule">Modèle du véhicule<span class="required">*</span></label>
                        <input type="text" id="modeleVehicule" name="modeleVehicule" 
                               placeholder="Ex: 208, Clio...">
                    </div>
                    
                    <div class="form-group">
                        <label for="immatriculation">Immatriculation<span class="required">*</span></label>
                        <input type="text" id="immatriculation" name="immatriculation" 
                               placeholder="Ex: AB-123-CD">
                    </div>
                    
                    <div class="form-group">
                        <label for="nombrePlaces">Nombre de places disponibles<span class="required">*</span></label>
                        <input type="number" id="nombrePlaces" name="nombrePlaces" 
                               min="1" max="8" value="3" placeholder="3">
                        <div class="input-hint">Nombre de places pour les passagers</div>
                    </div>
                </div>
                
                <!-- Champs spécifiques au passager -->
                <div id="champsPassager" class="specific-fields">
                    <div class="fields-header">
                        👤 En tant que passager
                    </div>
                    <p style="color: #666; text-align: center; padding: 20px;">
                        Vous pourrez rechercher et réserver des trajets proposés par nos conducteurs.
                    </p>
                </div>
                
                <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
                    S'inscrire
                </button>
                
                <div class="link-container">
                    Déjà inscrit ? <a href="connexion.jsp">Se connecter</a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        const conducteurRadio = document.getElementById('conducteur');
        const passagerRadio = document.getElementById('passager');
        const champtsConducteur = document.getElementById('champtsConducteur');
        const champsPassager = document.getElementById('champsPassager');
        const submitBtn = document.getElementById('submitBtn');
        const form = document.getElementById('inscriptionForm');
        
        // Champs spécifiques au conducteur
        const marqueVehicule = document.getElementById('marqueVehicule');
        const modeleVehicule = document.getElementById('modeleVehicule');
        const immatriculation = document.getElementById('immatriculation');
        const nombrePlaces = document.getElementById('nombrePlaces');
        
        // Fonction pour afficher les champs selon le rôle
        function updateFields() {
            if (conducteurRadio.checked) {
                champtsConducteur.classList.add('active');
                champsPassager.classList.remove('active');
                
                // Rendre les champs conducteur obligatoires
                marqueVehicule.required = true;
                modeleVehicule.required = true;
                immatriculation.required = true;
                nombrePlaces.required = true;
                
                submitBtn.disabled = false;
                
            } else if (passagerRadio.checked) {
                champsPassager.classList.add('active');
                champtsConducteur.classList.remove('active');
                
                // Rendre les champs conducteur non obligatoires
                marqueVehicule.required = false;
                modeleVehicule.required = false;
                immatriculation.required = false;
                nombrePlaces.required = false;
                
                submitBtn.disabled = false;
            }
        }
        
        // Événements sur les radios
        conducteurRadio.addEventListener('change', updateFields);
        passagerRadio.addEventListener('change', updateFields);
        
        // Validation du formulaire
        form.addEventListener('submit', function(e) {
            if (!conducteurRadio.checked && !passagerRadio.checked) {
                e.preventDefault();
                alert('Veuillez sélectionner un type d\'utilisateur (Conducteur ou Passager)');
                return false;
            }
        });
    </script>
</body>
</html>