<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Offre, java.util.List, java.text.SimpleDateFormat" %>
<%
    List<Offre> offres = (List<Offre>) request.getAttribute("offres");
    String villeDepart = (String) request.getAttribute("villeDepart");
    String villeArrivee = (String) request.getAttribute("villeArrivee");
    String dateDepart = (String) request.getAttribute("dateDepart");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<style>
    .search-container {
        background: white;
        padding: 25px;
        border-radius: 10px;
        margin-bottom: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .search-form {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        align-items: end;
    }
    
    .form-group {
        display: flex;
        flex-direction: column;
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
    
    .btn-search {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-search:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
    }
    
    .btn-reset {
        background: #e9ecef;
        color: #495057;
        padding: 12px 30px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-reset:hover {
        background: #dee2e6;
    }
    
    .offres-grid {
        display: grid;
        gap: 20px;
    }
    
    .offre-card {
        background: white;
        border: 1px solid #e9ecef;
        border-radius: 12px;
        padding: 25px;
        transition: all 0.3s;
        position: relative;
    }
    
    .offre-card:hover {
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        transform: translateY(-3px);
    }
    
    .offre-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 20px;
    }
    
    .offre-route h3 {
        font-size: 20px;
        color: #2c3e50;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .route-arrow {
        color: #667eea;
        font-weight: bold;
    }
    
    .offre-date {
        color: #7f8c8d;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .offre-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 15px;
        margin-bottom: 20px;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
    }
    
    .detail-item {
        display: flex;
        flex-direction: column;
    }
    
    .detail-label {
        font-size: 12px;
        color: #6c757d;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 5px;
    }
    
    .detail-value {
        font-size: 16px;
        color: #2c3e50;
        font-weight: 600;
    }
    
    .price-highlight {
        color: #28a745;
        font-size: 20px;
    }
    
    .btn-reserve {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 12px 25px;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-reserve:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }
    
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #6c757d;
        background: white;
        border-radius: 12px;
    }
    
    .empty-state-icon {
        font-size: 64px;
        margin-bottom: 20px;
        opacity: 0.5;
    }
    
    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        z-index: 1000;
        align-items: center;
        justify-content: center;
    }
    
    .modal.active {
        display: flex;
    }
    
    .modal-content {
        background: white;
        padding: 30px;
        border-radius: 12px;
        max-width: 500px;
        width: 90%;
    }
    
    .modal-header {
        margin-bottom: 20px;
    }
    
    .modal-header h3 {
        font-size: 22px;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .close-modal {
        float: right;
        background: none;
        border: none;
        font-size: 28px;
        cursor: pointer;
        color: #6c757d;
    }
    
    .modal-body {
        margin-bottom: 20px;
    }
    
    .modal-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }
    
    .commentaire-box {
        background: #f8f9fa;
        padding: 10px 15px;
        border-radius: 6px;
        margin-top: 10px;
        font-size: 14px;
        color: #495057;
        font-style: italic;
    }
</style>

<div class="top-bar">
    <div>
        <h1>Rechercher un Trajet</h1>
        <div class="breadcrumb">Accueil / Rechercher</div>
    </div>
</div>

<!-- Formulaire de recherche -->
<div class="search-container">
    <form method="GET" action="Passager" class="search-form">
        <input type="hidden" name="page" value="rechercher">
        
        <div class="form-group">
            <label>Ville de Départ</label>
            <select name="villeDepart">
                <option value="">Toutes les villes</option>
                <option value="Casablanca" <%= "Casablanca".equals(villeDepart) ? "selected" : "" %>>Casablanca</option>
                <option value="Rabat" <%= "Rabat".equals(villeDepart) ? "selected" : "" %>>Rabat</option>
                <option value="Marrakech" <%= "Marrakech".equals(villeDepart) ? "selected" : "" %>>Marrakech</option>
                <option value="Fès" <%= "Fès".equals(villeDepart) ? "selected" : "" %>>Fès</option>
                <option value="Tanger" <%= "Tanger".equals(villeDepart) ? "selected" : "" %>>Tanger</option>
                <option value="Agadir" <%= "Agadir".equals(villeDepart) ? "selected" : "" %>>Agadir</option>
                <option value="Meknès" <%= "Meknès".equals(villeDepart) ? "selected" : "" %>>Meknès</option>
                <option value="Oujda" <%= "Oujda".equals(villeDepart) ? "selected" : "" %>>Oujda</option>
            </select>
        </div>
        
        <div class="form-group">
            <label>Ville d'Arrivée</label>
            <select name="villeArrivee">
                <option value="">Toutes les villes</option>
                <option value="Casablanca" <%= "Casablanca".equals(villeArrivee) ? "selected" : "" %>>Casablanca</option>
                <option value="Rabat" <%= "Rabat".equals(villeArrivee) ? "selected" : "" %>>Rabat</option>
                <option value="Marrakech" <%= "Marrakech".equals(villeArrivee) ? "selected" : "" %>>Marrakech</option>
                <option value="Fès" <%= "Fès".equals(villeArrivee) ? "selected" : "" %>>Fès</option>
                <option value="Tanger" <%= "Tanger".equals(villeArrivee) ? "selected" : "" %>>Tanger</option>
                <option value="Agadir" <%= "Agadir".equals(villeArrivee) ? "selected" : "" %>>Agadir</option>
                <option value="Meknès" <%= "Meknès".equals(villeArrivee) ? "selected" : "" %>>Meknès</option>
                <option value="Oujda" <%= "Oujda".equals(villeArrivee) ? "selected" : "" %>>Oujda</option>
            </select>
        </div>
        
        <div class="form-group">
            <label>Date de Départ</label>
            <input type="date" name="dateDepart" value="<%= dateDepart != null ? dateDepart : "" %>">
        </div>
        
        <div class="form-group">
            <button type="submit" class="btn-search">🔍 Rechercher</button>
        </div>
        
        <div class="form-group">
            <a href="Passager?page=rechercher" class="btn-reset" style="text-decoration: none; text-align: center; display: block;">🔄 Réinitialiser</a>
        </div>
    </form>
</div>

<!-- Résultats de recherche -->
<div class="content-section">
    <div class="section-header">
        <h2>Offres Disponibles (<%= offres != null ? offres.size() : 0 %>)</h2>
    </div>
    
    <% if (offres == null || offres.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-state-icon">🔍</div>
            <h3>Aucune offre trouvée</h3>
            <p>Essayez de modifier vos critères de recherche</p>
        </div>
    <% } else { %>
        <div class="offres-grid">
            <% for (Offre offre : offres) { %>
                <div class="offre-card">
                    <div class="offre-header">
                        <div class="offre-route">
                            <h3>
                                📍 <%= offre.getVilleDepart() %> <span class="route-arrow">→</span> <%= offre.getVilleArrivee() %>
                            </h3>
                            <div class="offre-date">
                                🗓 <%= dateFormat.format(offre.getDateDepart()) %> à <%= timeFormat.format(offre.getHeureDepart()) %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="offre-details">
                        <div class="detail-item">
                            <span class="detail-label">Places Disponibles</span>
                            <span class="detail-value"><%= offre.getPlacesDisponibles() %> / <%= offre.getPlacesTotales() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Prix par Place</span>
                            <span class="detail-value price-highlight"><%= String.format("%.0f", offre.getPrixParPlace()) %> DH</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Publié le</span>
                            <span class="detail-value"><%= dateFormat.format(offre.getDatePublication()) %></span>
                        </div>
                    </div>
                    
                    <% if (offre.getCommentaire() != null && !offre.getCommentaire().trim().isEmpty()) { %>
                        <div class="commentaire-box">
                            💬 <%= offre.getCommentaire() %>
                        </div>
                    <% } %>
                    
                    <div style="margin-top: 15px;">
                        <% if (offre.getPlacesDisponibles() > 0) { %>
                            <button class="btn-reserve" onclick="openReservationModal(<%= offre.getIdOffre() %>, '<%= offre.getVilleDepart() %>', '<%= offre.getVilleArrivee() %>', <%= offre.getPrixParPlace() %>, <%= offre.getPlacesDisponibles() %>)">
                                🎫 Réserver
                            </button>
                        <% } else { %>
                            <button class="btn-reserve" disabled style="background: #95a5a6; cursor: not-allowed;">
                                Complet
                            </button>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<!-- Modal de réservation -->
<div id="reservationModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <button class="close-modal" onclick="closeReservationModal()">&times;</button>
            <h3>Réserver un Trajet</h3>
            <p id="modalRoute" style="color: #7f8c8d; font-size: 14px;"></p>
        </div>
        
        <form method="POST" action="Passager" id="reservationForm">
            <input type="hidden" name="action" value="reserver">
            <input type="hidden" name="offreId" id="modalOffreId">
            
            <div class="modal-body">
                <div class="form-group">
                    <label>Nombre de Places <span style="color: #e74c3c;">*</span></label>
                    <input type="number" name="nombrePlaces" id="modalNombrePlaces" required min="1" onchange="calculerPrixTotal()">
                    <small style="color: #6c757d; font-size: 13px;">Places disponibles: <span id="modalPlacesMax"></span></small>
                </div>
                
                <div class="form-group" style="margin-top: 15px;">
                    <label>Message (optionnel)</label>
                    <textarea name="message" rows="3" style="width: 100%; padding: 10px; border: 2px solid #e9ecef; border-radius: 8px; font-family: inherit;" placeholder="Ajoutez un message pour le conducteur..."></textarea>
                </div>
                
                <div style="background: #e7f3ff; padding: 15px; border-radius: 8px; margin-top: 15px;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-weight: 600; color: #2c3e50;">Prix Total:</span>
                        <span id="prixTotal" style="font-size: 24px; font-weight: bold; color: #28a745;">0 DH</span>
                    </div>
                </div>
            </div>
            
            <div class="modal-actions">
                <button type="button" class="btn-reset" onclick="closeReservationModal()">Annuler</button>
                <button type="submit" class="btn-reserve">Confirmer la Réservation</button>
            </div>
        </form>
    </div>
</div>

<script>
    let prixParPlace = 0;
    let placesMax = 0;
    
    function openReservationModal(offreId, villeDepart, villeArrivee, prix, places) {
        document.getElementById('modalOffreId').value = offreId;
        document.getElementById('modalRoute').textContent = villeDepart + ' → ' + villeArrivee;
        document.getElementById('modalNombrePlaces').max = places;
        document.getElementById('modalNombrePlaces').value = 1;
        document.getElementById('modalPlacesMax').textContent = places;
        
        prixParPlace = prix;
        placesMax = places;
        
        calculerPrixTotal();
        document.getElementById('reservationModal').classList.add('active');
    }
    
    function closeReservationModal() {
        document.getElementById('reservationModal').classList.remove('active');
        document.getElementById('reservationForm').reset();
    }
    
    function calculerPrixTotal() {
        const nombrePlaces = parseInt(document.getElementById('modalNombrePlaces').value) || 0;
        const total = nombrePlaces * prixParPlace;
        document.getElementById('prixTotal').textContent = total + ' DH';
    }
    
    // Validation du formulaire
    document.getElementById('reservationForm').addEventListener('submit', function(e) {
        const nombrePlaces = parseInt(document.getElementById('modalNombrePlaces').value);
        
        if (nombrePlaces < 1) {
            e.preventDefault();
            alert('Veuillez sélectionner au moins 1 place');
            return false;
        }
        
        if (nombrePlaces > placesMax) {
            e.preventDefault();
            alert('Le nombre de places demandé dépasse les places disponibles');
            return false;
        }
    });
    
    // Fermer le modal en cliquant à l'extérieur
    window.onclick = function(event) {
        const modal = document.getElementById('reservationModal');
        if (event.target == modal) {
            closeReservationModal();
        }
    }
</script>