<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur" %>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    
    if (success != null) {
        session.removeAttribute("success");
    }
    if (error != null) {
        session.removeAttribute("error");
    }
%>

<style>
    .form-container {
        max-width: 900px;
        margin: 0 auto;
    }
    
    .form-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        margin-bottom: 25px;
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
        margin: 0;
    }
    
    .form-section-icon {
        font-size: 28px;
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
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .required {
        color: #e74c3c;
    }
    
    .form-group input,
    .form-group select,
    .form-group textarea {
        padding: 12px 15px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 15px;
        transition: all 0.3s;
        font-family: inherit;
    }
    
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    .form-group textarea {
        resize: vertical;
        min-height: 100px;
    }
    
    .form-help {
        font-size: 13px;
        color: #6c757d;
        margin-top: 5px;
    }
    
    .form-actions {
        display: flex;
        gap: 15px;
        justify-content: flex-end;
        padding-top: 20px;
    }
    
    .btn-submit {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 14px 35px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
    }
    
    .btn-cancel {
        background: #e9ecef;
        color: #495057;
        padding: 14px 35px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
        display: inline-block;
    }
    
    .btn-cancel:hover {
        background: #dee2e6;
    }
    
    .info-box {
        background: #e7f3ff;
        border-left: 4px solid #0066cc;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 25px;
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
    
    .vehicule-info {
        background: #f8f9fa;
        padding: 15px 20px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 20px;
    }
    
    .vehicule-info-icon {
        font-size: 32px;
    }
    
    .vehicule-details h4 {
        font-size: 16px;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    
    .vehicule-details p {
        font-size: 14px;
        color: #6c757d;
        margin: 0;
    }
    
    .price-preview {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 20px;
        border-radius: 8px;
        text-align: center;
    }
    
    .price-preview h4 {
        font-size: 14px;
        margin-bottom: 10px;
        opacity: 0.9;
    }
    
    .price-preview .price {
        font-size: 36px;
        font-weight: bold;
    }
    
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
</style>

<div class="top-bar">
    <div>
        <h1>Publier un Trajet</h1>
        <div class="breadcrumb">Accueil / Nouvelle offre</div>
    </div>
</div>

<div class="form-container">
    <!-- Messages d'alerte -->
    <% if (success != null) { %>
    <div class="alert alert-success">
        ✅ <%= success %>
    </div>
    <% } %>
    
    <% if (error != null) { %>
    <div class="alert alert-error">
        ❌ <%= error %>
    </div>
    <% } %>

    <!-- Information sur le véhicule -->
    <div class="vehicule-info">
        <div class="vehicule-info-icon">🚗</div>
        <div class="vehicule-details">
            <h4><%= conducteur.getMarqueVehicule() != null ? conducteur.getMarqueVehicule() : "Marque non définie" %> 
                <%= conducteur.getModeleVehicule() != null ? conducteur.getModeleVehicule() : "Modèle non défini" %></h4>
            <p>Immatriculation: <%= conducteur.getImmatriculation() != null ? conducteur.getImmatriculation() : "Non définie" %> | 
               <%= conducteur.getNombrePlacesVehicule() != null ? conducteur.getNombrePlacesVehicule() : 0 %> places disponibles</p>
        </div>
    </div>
    
    <!-- Info Box -->
    <div class="info-box">
        <h4>💡 Conseils pour publier une offre</h4>
        <p>Remplissez tous les détails avec précision pour attirer plus de passagers. 
           Les offres complètes et précises ont plus de chances d'être réservées.</p>
    </div>
    
    <form method="POST" action="Conducteur" id="publierForm">
        <input type="hidden" name="action" value="publierOffre">
        
        <!-- Section Itinéraire -->
        <div class="form-section">
            <div class="form-section-header">
                <span class="form-section-icon">📍</span>
                <h3>Itinéraire</h3>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <label>
                        Ville de Départ <span class="required">*</span>
                    </label>
                    <select name="villeDepart" required>
                        <option value="">Sélectionnez une ville</option>
                        <option value="Casablanca">Casablanca</option>
                        <option value="Rabat">Rabat</option>
                        <option value="Marrakech">Marrakech</option>
                        <option value="Fès">Fès</option>
                        <option value="Tanger">Tanger</option>
                        <option value="Agadir">Agadir</option>
                        <option value="Meknès">Meknès</option>
                        <option value="Oujda">Oujda</option>
                        <option value="Kenitra">Kenitra</option>
                        <option value="Tétouan">Tétouan</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>
                        Ville d'Arrivée <span class="required">*</span>
                    </label>
                    <select name="villeArrivee" required>
                        <option value="">Sélectionnez une ville</option>
                        <option value="Casablanca">Casablanca</option>
                        <option value="Rabat">Rabat</option>
                        <option value="Marrakech">Marrakech</option>
                        <option value="Fès">Fès</option>
                        <option value="Tanger">Tanger</option>
                        <option value="Agadir">Agadir</option>
                        <option value="Meknès">Meknès</option>
                        <option value="Oujda">Oujda</option>
                        <option value="Kenitra">Kenitra</option>
                        <option value="Tétouan">Tétouan</option>
                    </select>
                </div>
            </div>
        </div>
        
        <!-- Section Date et Heure -->
        <div class="form-section">
            <div class="form-section-header">
                <span class="form-section-icon">📅</span>
                <h3>Date et Heure</h3>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <label>
                        Date du Trajet <span class="required">*</span>
                    </label>
                    <input type="date" name="dateDepart" required 
                           min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>
                
                <div class="form-group">
                    <label>
                        Heure de Départ <span class="required">*</span>
                    </label>
                    <input type="time" name="heureDepart" required>
                </div>
            </div>
        </div>
        
        <!-- Section Places et Prix -->
        <div class="form-section">
            <div class="form-section-header">
                <span class="form-section-icon">💰</span>
                <h3>Places et Prix</h3>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <label>
                        Nombre de Places <span class="required">*</span>
                    </label>
                    <input type="number" name="nombrePlaces" required 
                           min="1" max="<%= conducteur.getNombrePlacesVehicule() != null ? conducteur.getNombrePlacesVehicule() : 4 %>"
                           value="<%= conducteur.getNombrePlacesVehicule() != null ? conducteur.getNombrePlacesVehicule() : 4 %>">
                    <span class="form-help">
                        Maximum: <%= conducteur.getNombrePlacesVehicule() != null ? conducteur.getNombrePlacesVehicule() : 4 %> places
                    </span>
                </div>
                
                <div class="form-group">
                    <label>
                        Prix par Place <span class="required">*</span>
                    </label>
                    <input type="number" name="prixParPlace" required 
                           min="10" step="5" placeholder="50" id="prixInput">
                    <span class="form-help">En dirhams (DH)</span>
                </div>
                
                <div class="form-group">
                    <div class="price-preview">
                        <h4>Revenu Potentiel</h4>
                        <div class="price" id="revenuTotal">0 DH</div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Section Description -->
        <div class="form-section">
            <div class="form-section-header">
                <span class="form-section-icon">📝</span>
                <h3>Description</h3>
            </div>
            
            <div class="form-grid">
                <div class="form-group full-width">
                    <label>Description et Remarques</label>
                    <textarea name="description" 
                              placeholder="Ajoutez des informations supplémentaires pour les passagers..."></textarea>
                    <span class="form-help">
                        Partagez des détails utiles: conditions particulières, équipements du véhicule, etc.
                    </span>
                </div>
            </div>
        </div>
        
        <!-- Actions -->
        <div class="form-section">
            <div class="form-actions">
                <a href="Conducteur?page=offres" class="btn-cancel">
                    Annuler
                </a>
                <button type="submit" class="btn-submit">
                    ✅ Publier l'offre
                </button>
            </div>
        </div>
    </form>
</div>

<script>
    // Calculer le revenu potentiel
    function updateRevenu() {
        const prix = parseFloat(document.getElementById('prixInput').value) || 0;
        const places = parseInt(document.querySelector('input[name="nombrePlaces"]').value) || 0;
        const revenu = prix * places;
        document.getElementById('revenuTotal').textContent = revenu + ' DH';
    }
    
    document.getElementById('prixInput').addEventListener('input', updateRevenu);
    document.querySelector('input[name="nombrePlaces"]').addEventListener('input', updateRevenu);
    
    // Validation du formulaire
    document.getElementById('publierForm').addEventListener('submit', function(e) {
        const villeDepart = document.querySelector('select[name="villeDepart"]').value;
        const villeArrivee = document.querySelector('select[name="villeArrivee"]').value;
        
        if (villeDepart === villeArrivee) {
            e.preventDefault();
            alert('La ville de départ et d\'arrivée ne peuvent pas être identiques!');
            return false;
        }
        
        const prix = parseFloat(document.getElementById('prixInput').value);
        if (prix < 10) {
            e.preventDefault();
            alert('Le prix minimum par place est de 10 DH');
            return false;
        }
        
        const dateDepart = document.querySelector('input[name="dateDepart"]').value;
        const today = new Date().toISOString().split('T')[0];
        if (dateDepart < today) {
            e.preventDefault();
            alert('La date de départ ne peut pas être dans le passé!');
            return false;
        }
    });
    
    // Initialiser le calcul
    updateRevenu();
</script>