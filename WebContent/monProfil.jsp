<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<style>
    .profile-grid {
        display: grid;
        grid-template-columns: 300px 1fr;
        gap: 25px;
    }
    
    /* Profile Card */
    .profile-card {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        text-align: center;
        height: fit-content;
    }
    
    .profile-avatar {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        font-size: 64px;
        color: white;
        font-weight: bold;
    }
    
    .profile-name {
        font-size: 24px;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .profile-email {
        color: #6c757d;
        font-size: 14px;
        margin-bottom: 15px;
    }
    
    .profile-rating {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    
    .profile-rating .stars {
        color: #f39c12;
        font-size: 20px;
    }
    
    .profile-rating .score {
        font-size: 20px;
        font-weight: bold;
        color: #2c3e50;
    }
    
    .profile-stats {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
        margin-bottom: 20px;
    }
    
    .stat-item {
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
    }
    
    .stat-value {
        font-size: 24px;
        font-weight: bold;
        color: #667eea;
        margin-bottom: 5px;
    }
    
    .stat-label {
        font-size: 12px;
        color: #6c757d;
    }
    
    .profile-badge {
        display: inline-block;
        padding: 8px 16px;
        background: #d4edda;
        color: #155724;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        margin-bottom: 10px;
    }
    
    .member-since {
        font-size: 13px;
        color: #6c757d;
    }
    
    /* Forms Section */
    .forms-container {
        display: flex;
        flex-direction: column;
        gap: 25px;
    }
    
    .form-section {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .form-section-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .form-section-header h3 {
        font-size: 20px;
        color: #2c3e50;
    }
    
    .form-section-icon {
        font-size: 24px;
    }
    
    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
    }
    
    .form-group {
        display: flex;
        flex-direction: column;
    }
    
    .form-group.full-width {
        grid-column: 1 / -1;
    }
    
    .form-group label {
        font-size: 14px;
        font-weight: 600;
        color: #495057;
        margin-bottom: 8px;
    }
    
    .form-group input,
    .form-group select {
        padding: 12px 15px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 15px;
        transition: all 0.3s;
    }
    
    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    .form-group input:disabled {
        background: #f8f9fa;
        cursor: not-allowed;
    }
    
    .form-actions {
        display: flex;
        gap: 15px;
        justify-content: flex-end;
        margin-top: 20px;
    }
    
    .btn {
        padding: 12px 30px;
        border-radius: 8px;
        border: none;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
    }
    
    .btn-secondary {
        background: #e9ecef;
        color: #495057;
    }
    
    .btn-secondary:hover {
        background: #dee2e6;
    }
    
    .btn-danger {
        background: #f8d7da;
        color: #721c24;
    }
    
    .btn-danger:hover {
        background: #f5c6cb;
    }
    
    .info-box {
        background: #e7f3ff;
        border-left: 4px solid #0066cc;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    
    .info-box p {
        color: #495057;
        font-size: 14px;
        line-height: 1.6;
        margin: 0;
    }
    
    .success-message {
        background: #d4edda;
        border-left: 4px solid #28a745;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        display: none;
    }
    
    .success-message p {
        color: #155724;
        font-size: 14px;
        margin: 0;
    }
    
    .success-message.show {
        display: block;
    }
</style>

<div class="top-bar">
    <div>
        <h1>Mon Profil</h1>
        <div class="breadcrumb">Accueil / Profil</div>
    </div>
</div>

<div class="profile-grid">
    <!-- Profile Card -->
    <div class="profile-card">
        <div class="profile-avatar">
            <%= conducteur.getPrenom().substring(0,1) + conducteur.getNom().substring(0,1) %>
        </div>
        
        <h2 class="profile-name">
            <%= conducteur.getPrenom() %> <%= conducteur.getNom() %>
        </h2>
        
        <p class="profile-email"><%= conducteur.getEmail() %></p>
        
        <div class="profile-rating">
            <span class="stars">★★★★★</span>
            <span class="score"><%= String.format("%.1f", conducteur.getNoteMoyenne()) %>/5</span>
        </div>
        
        <div class="profile-stats">
            <div class="stat-item">
                <div class="stat-value">42</div>
                <div class="stat-label">Trajets</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">128</div>
                <div class="stat-label">Passagers</div>
            </div>
        </div>
        
        <span class="profile-badge">✓ Vérifié</span>
        
        <p class="member-since">
            Membre depuis <%= dateFormat.format(conducteur.getDateInscription()) %>
        </p>
    </div>
    
    <!-- Forms Container -->
    <div class="forms-container">
        <!-- Success Message -->
        <div id="successMessage" class="success-message">
            <p>✅ Profil mis à jour avec succès !</p>
        </div>
        
        <!-- Informations Personnelles -->
        <div class="form-section">
            <div class="form-section-header">
                <span class="form-section-icon">👤</span>
                <h3>Informations Personnelles</h3>
            </div>
            
            <form method="POST" action="Conducteur" id="formInfoPersonnelles">
                <input type="hidden" name="action" value="updateProfil">
                
                <div class="form-grid">
                    <div class="form-group">
                        <label>Prénom</label>
                        <input type="text" name="prenom" value="<%= conducteur.getPrenom() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Nom</label>
                        <input type="text" name="nom" value="<%= conducteur.getNom() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= conducteur.getEmail() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Téléphone</label>
                        <input type="tel" name="telephone" value="<%= conducteur.getTelephone() %>" required>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="resetForm('formInfoPersonnelles')">
                        Annuler
                    </button>
                    <button type="submit" class="btn btn-primary">
                        💾 Enregistrer
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Informations Véhicule -->
        <div class="form-section">
            <div class="form-section-header">
                <span class="form-section-icon">🚗</span>
                <h3>Informations Véhicule</h3>
            </div>
            
            <form method="POST" action="Conducteur" id="formVehicule">
                <input type="hidden" name="action" value="updateVehicule">
                
                <div class="form-grid">
                    <div class="form-group">
                        <label>Marque</label>
                        <input type="text" name="marqueVehicule" value="<%= conducteur.getMarqueVehicule() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Modèle</label>
                        <input type="text" name="modeleVehicule" value="<%= conducteur.getModeleVehicule() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Immatriculation</label>
                        <input type="text" name="immatriculation" value="<%= conducteur.getImmatriculation() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Nombre de Places</label>
                        <input type="number" name="nombrePlaces" value="<%= conducteur.getNombrePlacesVehicule() %>" 
                               min="1" max="8" required>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="resetForm('formVehicule')">
                        Annuler
                    </button>
                    <button type="submit" class="btn btn-primary">
                        💾 Enregistrer
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Sécurité -->
        <div class="form-section">
            <div class="form-section-header">
                <span class="form-section-icon">🔒</span>
                <h3>Sécurité</h3>
            </div>
            
            <div class="info-box">
                <p>Pour votre sécurité, nous vous recommandons de changer votre mot de passe régulièrement.</p>
            </div>
            
            <form method="POST" action="Conducteur" id="formMotDePasse">
                <input type="hidden" name="action" value="updateMotDePasse">
                
                <div class="form-grid">
                    <div class="form-group">
                        <label>Mot de Passe Actuel</label>
                        <input type="password" name="ancienMotDePasse" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Nouveau Mot de Passe</label>
                        <input type="password" name="nouveauMotDePasse" required minlength="6">
                    </div>
                    
                    <div class="form-group">
                        <label>Confirmer le Mot de Passe</label>
                        <input type="password" name="confirmerMotDePasse" required minlength="6">
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="resetForm('formMotDePasse')">
                        Annuler
                    </button>
                    <button type="submit" class="btn btn-primary">
                        🔒 Changer le Mot de Passe
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Supprimer le Compte -->
        <div class="form-section">
            <div class="form-section-header">
                <span class="form-section-icon">⚠️</span>
                <h3>Zone Dangereuse</h3>
            </div>
            
            <div class="info-box" style="background: #fff3cd; border-color: #ff9800;">
                <p><strong>Attention :</strong> La suppression de votre compte est irréversible. 
                Toutes vos données seront définitivement perdues.</p>
            </div>
            
            <div class="form-actions">
                <button type="button" class="btn btn-danger" onclick="confirmerSuppression()">
                    🗑️ Supprimer Mon Compte
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    function resetForm(formId) {
        document.getElementById(formId).reset();
    }
    
    // Validation du formulaire de mot de passe
    document.getElementById('formMotDePasse').addEventListener('submit', function(e) {
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
    
    function confirmerSuppression() {
        if (confirm('Êtes-vous absolument sûr de vouloir supprimer votre compte ?\n\nCette action est IRRÉVERSIBLE et toutes vos données seront définitivement perdues.')) {
            if (confirm('Dernière confirmation : Voulez-vous vraiment supprimer votre compte ?')) {
                alert('Fonctionnalité de suppression en développement');
            }
        }
    }
    
    // Afficher le message de succès après soumission
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('success') === 'true') {
        document.getElementById('successMessage').classList.add('show');
        setTimeout(() => {
            document.getElementById('successMessage').classList.remove('show');
        }, 5000);
    }
</script>