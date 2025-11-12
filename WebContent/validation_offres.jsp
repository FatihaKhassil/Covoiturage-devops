<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Offre, java.util.List, java.text.SimpleDateFormat" %>
<%
    List<Offre> offresEnAttente = (List<Offre>) request.getAttribute("offresEnAttente");
    Integer totalEnAttente = (Integer) request.getAttribute("totalEnAttente");
    
    if (totalEnAttente == null) totalEnAttente = 0;
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<style>
    .validation-header {
        background: white;
        padding: 20px 30px;
        border-radius: 10px;
        margin-bottom: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .validation-count {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .count-badge {
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        color: white;
        padding: 10px 20px;
        border-radius: 25px;
        font-size: 18px;
        font-weight: bold;
    }
    
    .offres-validation-grid {
        display: grid;
        gap: 20px;
    }
    
    .offre-validation-card {
        background: white;
        border: 2px solid #e9ecef;
        border-radius: 12px;
        padding: 25px;
        transition: all 0.3s;
        position: relative;
    }
    
    .offre-validation-card:hover {
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        border-color: #e74c3c;
    }
    
    .offre-validation-card::before {
        content: '⏳';
        position: absolute;
        top: 15px;
        right: 15px;
        font-size: 32px;
    }
    
    .offre-validation-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 20px;
    }
    
    .offre-route h3 {
        font-size: 22px;
        color: #2c3e50;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .route-arrow {
        color: #e74c3c;
        font-weight: bold;
    }
    
    .offre-date {
        color: #7f8c8d;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .offre-validation-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 15px;
        margin-bottom: 20px;
        padding: 20px;
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
    
    .commentaire-box {
        background: #fff3cd;
        border-left: 4px solid #ff9800;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    
    .commentaire-box h4 {
        font-size: 14px;
        color: #856404;
        margin-bottom: 8px;
        font-weight: 600;
    }
    
    .commentaire-box p {
        font-size: 14px;
        color: #495057;
        line-height: 1.6;
        font-style: italic;
    }
    
    .validation-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
    }
    
    .btn-validate {
        flex: 1;
        padding: 12px 25px;
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }
    
    .btn-validate:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(40, 167, 69, 0.4);
    }
    
    .btn-reject {
        flex: 1;
        padding: 12px 25px;
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }
    
    .btn-reject:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(231, 76, 60, 0.4);
    }
    
    .empty-validation {
        text-align: center;
        padding: 80px 20px;
        background: white;
        border-radius: 12px;
    }
    
    .empty-validation-icon {
        font-size: 96px;
        margin-bottom: 20px;
        opacity: 0.5;
    }
    
    .empty-validation h3 {
        font-size: 24px;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .empty-validation p {
        font-size: 16px;
        color: #6c757d;
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
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    
    .modal-header h3 {
        font-size: 22px;
        color: #2c3e50;
    }
    
    .close-modal {
        background: none;
        border: none;
        font-size: 28px;
        cursor: pointer;
        color: #6c757d;
    }
    
    .modal-body textarea {
        width: 100%;
        padding: 12px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 14px;
        font-family: inherit;
        resize: vertical;
        min-height: 100px;
    }
    
    .modal-body textarea:focus {
        outline: none;
        border-color: #e74c3c;
    }
    
    .modal-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
        margin-top: 20px;
    }
    
    .btn-secondary {
        padding: 10px 20px;
        background: #e9ecef;
        color: #495057;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
    }
    
    .btn-secondary:hover {
        background: #dee2e6;
    }
</style>

<div class="top-bar">
    <div>
        <h1>Validation des Offres</h1>
        <div class="breadcrumb">Accueil / Validation</div>
    </div>
</div>

<div class="validation-header">
    <div>
        <h2 style="font-size: 20px; color: #2c3e50; margin-bottom: 5px;">Offres en Attente de Validation</h2>
        <p style="font-size: 14px; color: #6c757d;">Vérifiez et validez les offres publiées par les conducteurs</p>
    </div>
    <div class="validation-count">
        <span class="count-badge"><%= totalEnAttente %></span>
        <span style="font-size: 14px; color: #6c757d;">offre(s) à valider</span>
    </div>
</div>

<!-- Liste des offres à valider -->
<% if (offresEnAttente == null || offresEnAttente.isEmpty()) { %>
    <div class="empty-validation">
        <div class="empty-validation-icon">✅</div>
        <h3>Aucune offre en attente</h3>
        <p>Toutes les offres ont été validées. Excellent travail !</p>
    </div>
<% } else { %>
    <div class="offres-validation-grid">
        <% for (Offre offre : offresEnAttente) { %>
            <div class="offre-validation-card">
                <div class="offre-validation-header">
                    <div class="offre-route">
                        <h3>
                            📍 <%= offre.getVilleDepart() %> <span class="route-arrow">→</span> <%= offre.getVilleArrivee() %>
                        </h3>
                        <div class="offre-date">
                            🗓 <%= dateFormat.format(offre.getDateDepart()) %> à <%= timeFormat.format(offre.getHeureDepart()) %>
                        </div>
                    </div>
                </div>
                
                <div class="offre-validation-details">
                    <div class="detail-item">
                        <span class="detail-label">Places Totales</span>
                        <span class="detail-value">💺 <%= offre.getPlacesTotales() %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Places Disponibles</span>
                        <span class="detail-value">✅ <%= offre.getPlacesDisponibles() %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Prix par Place</span>
                        <span class="detail-value price-highlight"><%= String.format("%.0f", offre.getPrixParPlace()) %> DH</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Date Publication</span>
                        <span class="detail-value"><%= dateFormat.format(offre.getDatePublication()) %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">ID Conducteur</span>
                        <span class="detail-value">#<%= offre.getIdConducteur() %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">ID Offre</span>
                        <span class="detail-value">#<%= offre.getIdOffre() %></span>
                    </div>
                </div>
                
                <% if (offre.getCommentaire() != null && !offre.getCommentaire().trim().isEmpty()) { %>
                    <div class="commentaire-box">
                        <h4>📝 Commentaire du Conducteur</h4>
                        <p><%= offre.getCommentaire() %></p>
                    </div>
                <% } %>
                
                <div class="validation-actions">
                    <form method="POST" action="Admin" style="flex: 1;">
                        <input type="hidden" name="action" value="validerOffre">
                        <input type="hidden" name="offreId" value="<%= offre.getIdOffre() %>">
                        <button type="submit" class="btn-validate" 
                                onclick="return confirm('Valider cette offre ?')">
                            ✅ Valider l\'Offre
                        </button>
                    </form>
                    <button class="btn-reject" onclick="openRejectModal(<%= offre.getIdOffre() %>)">
                        ❌ Rejeter l\'Offre
                    </button>
                </div>
            </div>
        <% } %>
    </div>
<% } %>

<!-- Modal de Rejet -->
<div id="rejectModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Rejeter l'Offre</h3>
            <button class="close-modal" onclick="closeRejectModal()">&times;</button>
        </div>
        <form method="POST" action="Admin" id="rejectForm">
            <input type="hidden" name="action" value="rejeterOffre">
            <input type="hidden" name="offreId" id="rejectOffreId">
            <div class="modal-body">
                <label style="display: block; font-weight: 600; margin-bottom: 10px; color: #2c3e50;">
                    Motif du rejet (obligatoire) :
                </label>
                <textarea name="motif" id="rejectMotif" placeholder="Expliquez pourquoi cette offre est rejetée..." required></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeRejectModal()">Annuler</button>
                <button type="submit" class="btn-reject">Confirmer le Rejet</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openRejectModal(offreId) {
        document.getElementById('rejectOffreId').value = offreId;
        document.getElementById('rejectMotif').value = '';
        document.getElementById('rejectModal').classList.add('active');
    }
    
    function closeRejectModal() {
        document.getElementById('rejectModal').classList.remove('active');
    }
    
    window.onclick = function(event) {
        const modal = document.getElementById('rejectModal');
        if (event.target == modal) {
            closeRejectModal();
        }
    }
    
    // Validation du formulaire
    document.getElementById('rejectForm').addEventListener('submit', function(e) {
        const motif = document.getElementById('rejectMotif').value.trim();
        if (motif.length < 10) {
            e.preventDefault();
            alert('Le motif doit contenir au moins 10 caractères');
            return false;
        }
    });
</script>