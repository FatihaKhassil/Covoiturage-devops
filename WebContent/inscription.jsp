<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - CIV</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8fafc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            background: #e8ecf1;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            max-width: 600px;
            width: 100%;
        }
        
        .header {
            background: #e8ecf1;
            color: #667eea;
            padding: 40px;
            text-align: center;
            border-bottom: none;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .header p {
            font-size: 1em;
            color: #64748b;
        }
        
        .form-content {
            padding: 40px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 10px;
            font-weight: 500;
        }
        
        .alert-error {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #1e293b;
            font-size: 0.95em;
        }
        
        .required {
            color: #dc2626;
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
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            font-family: inherit;
            background: white;
        }
        
        input:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        select {
            cursor: pointer;
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
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }
        
        .role-card:hover {
            border-color: #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
        }
        
        .role-option input[type="radio"]:checked + .role-card {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .role-title {
            font-weight: 700;
            font-size: 1.1em;
            color: #1e293b;
            margin-bottom: 5px;
        }
        
        .role-description {
            font-size: 0.9em;
            color: #64748b;
        }
        
        .specific-fields {
            display: none;
        }
        
        .specific-fields.active {
            display: block;
        }
        
        .fields-header {
            background: #f8fafc;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
            color: #334155;
        }
        
        .btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.35);
        }
        
        .btn-primary:active:not(:disabled) {
            transform: translateY(0);
        }
        
        .btn-primary:disabled {
            background: #cbd5e1;
            cursor: not-allowed;
        }
        
        .input-hint {
            font-size: 0.85em;
            color: #64748b;
            margin-top: 5px;
        }
        
        .link-container {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #e5e7eb;
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
            <h1>Inscription</h1>
            <p>Créez votre compte et rejoignez notre communauté</p>
        </div>
        
        <div class="form-content">
            <c:if test="${not empty erreur}">
                <div class="alert alert-error">
                    ${erreur}
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
                                <div class="role-title">Conducteur</div>
                                <div class="role-description">Je propose des trajets</div>
                            </label>
                        </div>
                        
                        <div class="role-option">
                            <input type="radio" name="typeUtilisateur" id="passager" value="passager" required>
                            <label for="passager" class="role-card">
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
                        Informations sur votre véhicule
                    </div>
                    
                    <div class="form-group">
                        <label for="marqueVehicule">Marque du véhicule<span class="required">*</span></label>
                        <input type="text" id="marqueVehicule" name="marqueVehicule" 
                               placeholder="Ex: Peugeot, Renault">
                    </div>
                    
                    <div class="form-group">
                        <label for="modeleVehicule">Modèle du véhicule<span class="required">*</span></label>
                        <input type="text" id="modeleVehicule" name="modeleVehicule" 
                               placeholder="Ex: 208, Clio">
                    </div>
                    
                    <div class="form-group">
                        <label for="immatriculation">Immatriculation<span class="required">*</span></label>
                        <input type="text" id="immatriculation" name="immatriculation" 
                               placeholder="Ex: AB-123-CD">
                    </div>
                    
                    <div class="form-group">
                        <label for="nombrePlaces">Nombre de places disponibles<span class="required">*</span></label>
                        <input type="number" id="nombrePlaces" name="nombrePlaces" 
                               min="1" max="8" value="3">
                        <div class="input-hint">Nombre de places pour les passagers</div>
                    </div>
                </div>
                
                <!-- Champs spécifiques au passager -->
                <div id="champsPassager" class="specific-fields">
                    <div class="fields-header">
                        En tant que passager
                    </div>
                    <p style="color: #64748b; text-align: center; padding: 20px; font-size: 0.95em;">
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
        
        const marqueVehicule = document.getElementById('marqueVehicule');
        const modeleVehicule = document.getElementById('modeleVehicule');
        const immatriculation = document.getElementById('immatriculation');
        const nombrePlaces = document.getElementById('nombrePlaces');
        
        function updateFields() {
            if (conducteurRadio.checked) {
                champtsConducteur.classList.add('active');
                champsPassager.classList.remove('active');
                
                marqueVehicule.required = true;
                modeleVehicule.required = true;
                immatriculation.required = true;
                nombrePlaces.required = true;
                
                submitBtn.disabled = false;
                
            } else if (passagerRadio.checked) {
                champsPassager.classList.add('active');
                champtsConducteur.classList.remove('active');
                
                marqueVehicule.required = false;
                modeleVehicule.required = false;
                immatriculation.required = false;
                nombrePlaces.required = false;
                
                submitBtn.disabled = false;
            }
        }
        
        conducteurRadio.addEventListener('change', updateFields);
        passagerRadio.addEventListener('change', updateFields);
        
        form.addEventListener('submit', function(e) {
            if (!conducteurRadio.checked && !passagerRadio.checked) {
                e.preventDefault();
                alert('Veuillez sélectionner un type d\'utilisateur');
                return false;
            }
        });
    </script>
</body>
</html>