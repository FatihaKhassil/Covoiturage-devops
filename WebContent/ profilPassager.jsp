<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Passager, java.text.SimpleDateFormat" %>
<%
    Passager passager = (Passager) session.getAttribute("utilisateur");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<style>
    .profil-container {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 25px;
    }
    
    .profil-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .profil-section h3 {
        font-size: 20px;
        color: #2c3e50;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid #ecf0f1;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #495057;
        margin-bottom: 8px;
    }
    
    .form-group input {
        width: 100%;
        padding: 12px 15px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 15px;
        transition: all 0.3s;
    }
    
    .form-group input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    .form-group input:disabled {
        background: #f8f9fa;
        cursor: not-allowed;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        width: 100%;
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
    }
    
    .info-box {
        background: #e7f3ff;
        border-left: 4px solid #0066cc;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    
    .info-box h4 {
        color: #0066cc;
        margin-bottom: 8px;
        font-size: 16px;
    }
    
    .info-box p {
        color: #495057;
        font-size: 14px;
        line-height: 1.6;
        margin: 0;
    }
    
    .stats-box {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    
    .stats-item {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid #e9ecef;
    }
    
    .stats-item:last-child {
        border-bottom: none;
    }
    
    .stats-label {
        color: #7f8c8d;
        font-size: 14px;
    }
    
    .stats-value {
        font-weight: 600;
        color: #2c3e50;
        font-size: 16px;
    }
    
    @media (max-width: 768px) {
        .profil-container {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="top-bar">
    <div>
        <h1>Mon Profil</h1>
        <div class="breadcrumb">Accueil / Profil</div>
    </div>
</div>

<div class="profil-container">
    <!-- Informations Personnelles -->
    <div class="profil-section">
        <h3>👤 Informations Personnelles</h3>
        
        <div class="info-box">
            <h4>💡 Conseil</h4>
            <p>Gardez vos informations à jour pour une meilleure expérience de covoiturage.</p>
        </div>
        
        <form method="POST" action="Passager">
            <input type="hidden" name="action" value="updateProfil">
            
            <div class="form-group">
                <label>Nom</label>
                <input type="text" name="nom" value="<%= passager.getNom() %>" required>
            </div>
            
            <div class="form-group">
                <label>Prénom</label>
                <input type="text" name="prenom" value="<%= passager.getPrenom() %>" required>
            </div>
            
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="<%= passager.getEmail() %>" required>
            </div>
            
            <div class="form-group">
                <label>Téléphone</label>
                <input type="tel" name="telephone" value="<%= passager.getTelephone() != null ? passager.getTelephone() : "" %>" required>
            </div>
            
            <div class="form-group">
                <label>Date d'inscription</label>
                <input type="text" value="<%= passager.getDateInscription() != null ? dateFormat.format(passager.getDateInscription()) : "N/A" %>" disabled>
            </div>
            
            <button type="submit" class="btn-primary">💾 Enregistrer les Modifications</button>
        </form>
    </div>
    
    <!-- Sécurité et Statistiques -->
    <div>
        <!-- Changer le mot de passe -->
        <div class="profil-section" style="margin-bottom: 25px;">
            <h3>🔒 Sécurité</h3>
            
            <form method="POST" action="Passager">
                <input type="hidden" name="action" value="updateMotDePasse">
                
                <div class="form-group">
                    <label>Mot de passe actuel</label>
                    <input type="password" name="ancienMotDePasse" required>
                </div>
                
                <div class="form-group">
                    <label>Nouveau mot de passe</label>
                    <input type="password" name="nouveauMotDePasse" required minlength="6">
                </div>
                
                <div class="form-group">
                    <label>Confirmer le nouveau mot de passe</label>
                    <input type="password" name="confirmerMotDePasse" required minlength="6">
                </div>
                
                <button type="submit" class="btn-primary">🔐 Changer le Mot de Passe</button>
            </form>
        </div>
        
        <!-- Statistiques -->
        <div class="profil-section">
            <h3>📊 Mes Statistiques</h3>
            
            <div class="stats-box">
                <div class="stats-item">
                    <span class="stats-label">Note Moyenne</span>
                    <span class="stats-value">⭐ <%= String.format("%.1f", passager.getNoteMoyenne()) %>/5</span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">Statut du Compte</span>
                    <span class="stats-value" style="color: <%= passager.getEstActif() ? "#28a745" : "#dc3545" %>;">
                        <%= passager.getEstActif() ? "✅ Actif" : "❌ Inactif" %>
                    </span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">Membre depuis</span>
                    <span class="stats-value">
                        <%= passager.getDateInscription() != null ? dateFormat.format(passager.getDateInscription()) : "N/A" %>
                    </span>
                </div>
            </div>
            
            <div class="info-box">
                <h4>🎯 Améliorez votre profil</h4>
                <p>Un profil complet et une bonne note vous aideront à trouver plus facilement des trajets.</p>
            </div>
        </div>
    </div>
</div>

<script>
    // Validation du changement de mot de passe
    document.querySelector('form[action*="updateMotDePasse"]').addEventListener('submit', function(e) {
        const nouveau = document.querySelector('input[name="nouveauMotDePasse"]').value;
        const confirmer = document.querySelector('input[name="confirmerMotDePasse"]').value;
        
        if (nouveau !== confirmer) {
            e.preventDefault();
            alert('Les mots de passe ne correspondent pas !');
            return false;
        }
        
        if (nouveau.length < 6) {
            e.preventDefault();
            alert('Le mot de passe doit contenir au moins 6 caractères !');
            return false;
        }
    });
</script>