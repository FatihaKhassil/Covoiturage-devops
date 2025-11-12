<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Reservation, java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="models.Conducteur" %>
<%
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    Integer nbConfirmees = (Integer) request.getAttribute("nbConfirmees");
    Integer nbAnnulees = (Integer) request.getAttribute("nbAnnulees");
    Integer nbTerminees = (Integer) request.getAttribute("nbTerminees");
    
    if (nbConfirmees == null) nbConfirmees = 0;
    if (nbAnnulees == null) nbAnnulees = 0;
    if (nbTerminees == null) nbTerminees = 0;
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<style>
    .reservations-grid {
        display: grid;
        gap: 20px;
    }
    
    .reservation-card {
        background: white;
        border: 1px solid #e9ecef;
        border-radius: 12px;
        padding: 25px;
        transition: all 0.3s;
        position: relative;
        overflow: hidden;
    }
    
    .reservation-card:hover {
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        transform: translateY(-3px);
    }
    
    .reservation-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 5px;
        height: 100%;
    }
    
    .reservation-card.confirmee::before {
        background: #28a745;
    }
    
    .reservation-card.terminee::before {
        background: #17a2b8;
    }
    
    .reservation-card.annulee::before {
        background: #dc3545;
    }
    
    .reservation-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 20px;
    }
    
    .reservation-route h3 {
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
    
    .reservation-date {
        color: #7f8c8d;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .status-badge {
        padding: 6px 15px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .status-confirmee {
        background: #d4edda;
        color: #155724;
    }
    
    .status-terminee {
        background: #d1ecf1;
        color: #0c5460;
    }
    
    .status-annulee {
        background: #f8d7da;
        color: #721c24;
    }
    
    .reservation-details {
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
    
    .btn-cancel {
        background: #f8d7da;
        color: #721c24;
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-cancel:hover {
        background: #f5c6cb;
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
    
    .message-box {
        background: #e7f3ff;
        padding: 10px 15px;
        border-radius: 6px;
        margin-top: 10px;
        font-size: 14px;
        color: #495057;
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
    
    .modal-body p {
        color: #495057;
        line-height: 1.6;
        margin-bottom: 20px;
    }
    
    .modal-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }
</style>

<div class="top-bar">
    <div>
        <h1>Mes Réservations</h1>
        <div class="breadcrumb">Accueil / Réservations</div>
    </div>
</div>

<!-- Statistiques -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Confirmées</h3>
            <div class="stat-icon green">✅</div>
        </div>
        <div class="value"><%= nbConfirmees %></div>
        <div class="label">Réservations actives</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Terminées</h3>
            <div class="stat-icon blue">🎯</div>
        </div>
        <div class="value"><%= nbTerminees %></div>
        <div class="label">Trajets effectués</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Annulées</h3>
            <div class="stat-icon orange">❌</div>
        </div>
        <div class="value"><%= nbAnnulees %></div>
        <div class="label">Réservations annulées</div>
    </div>
</div>

<!-- Liste des réservations -->
<div class="content-section">
    <div class="section-header">
        <h2>Toutes mes Réservations (<%= reservations != null ? reservations.size() : 0 %>)</h2>
    </div>
    
    <% if (reservations == null || reservations.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-state-icon">📋</div>
            <h3>Aucune réservation</h3>
            <p>Vous n'avez pas encore effectué de réservation</p>
            <a href="Passager?page=rechercher" style="color: #667eea; text-decoration: none; font-weight: 600;">
                Rechercher un trajet →
            </a>
        </div>
    <% } else { %>
        <div class="reservations-grid">
            <% for (Reservation reservation : reservations) { 
                String statut = reservation.getStatut();
                String statusClass = "";
                String statusLabel = "";
                String cardClass = "";
                
                if ("CONFIRMEE".equals(statut)) {
                    statusClass = "status-confirmee";
                    statusLabel = "Confirmée";
                    cardClass = "confirmee";
                } else if ("TERMINEE".equals(statut)) {
                    statusClass = "status-terminee";
                    statusLabel = "Terminée";
                    cardClass = "terminee";
                } else if ("ANNULEE".equals(statut)) {
                    statusClass = "status-annulee";
                    statusLabel = "Annulée";
                    cardClass = "annulee";
                }
            %>
                <div class="reservation-card <%= cardClass %>">
                    <div class="reservation-header">
                        <div class="reservation-route">
                            <h3>
                                📍 <%= reservation.getOffre().getVilleDepart() %> <span class="route-arrow">→</span> <%= reservation.getOffre().getVilleArrivee() %>
                            </h3>
                            <div class="reservation-date">
                                🗓 <%= dateFormat.format(reservation.getOffre().getDateDepart()) %> à <%= timeFormat.format(reservation.getOffre().getHeureDepart()) %>
                            </div>
                        </div>
                        <span class="status-badge <%= statusClass %>"><%= statusLabel %></span>
                    </div>
                    
                    <div class="reservation-details">
                        <div class="detail-item">
                            <span class="detail-label">Places Réservées</span>
                            <span class="detail-value"><%= reservation.getNombrePlaces() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Prix Total</span>
                            <span class="detail-value price-highlight"><%= String.format("%.0f", reservation.getPrixTotal()) %> DH</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Réservé le</span>
                            <span class="detail-value"><%= dateFormat.format(reservation.getDateReservation()) %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Conducteur</span>
                            <span class="detail-value">
    <% 
        Conducteur conducteur = reservation.getOffre().getConducteur();
        if (conducteur != null && conducteur.getPrenom() != null) {
            out.print(conducteur.getPrenom());
        } else {
            out.print("N/A");
        }
    %>
</span>
                        </div>
                    </div>
                    
                    <% if (reservation.getMessagePassager() != null && !reservation.getMessagePassager().trim().isEmpty()) { %>
                        <div class="message-box">
                            💬 Votre message: <%= reservation.getMessagePassager() %>
                        </div>
                    <% } %>
                    
                    <% if ("CONFIRMEE".equals(statut)) { %>
                        <div style="margin-top: 15px;">
                            <button class="btn-cancel" onclick="cancelReservation(<%= reservation.getIdReservation() %>)">
                                ❌ Annuler la Réservation
                            </button>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<!-- Modal de confirmation d'annulation -->
<div id="cancelModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Confirmer l'annulation</h3>
            <button class="close-modal" onclick="closeCancelModal()">&times;</button>
        </div>
        <div class="modal-body">
            <p>Êtes-vous sûr de vouloir annuler cette réservation ? Cette action est irréversible.</p>
        </div>
        <div class="modal-actions">
            <button class="btn-search" onclick="closeCancelModal()">Retour</button>
            <form method="POST" action="Passager" style="display: inline;">
                <input type="hidden" name="action" value="annulerReservation">
                <input type="hidden" name="reservationId" id="cancelReservationId">
                <button type="submit" class="btn-cancel">Confirmer l'annulation</button>
            </form>
        </div>
    </div>
</div>

<script>
    function cancelReservation(id) {
        document.getElementById('cancelReservationId').value = id;
        document.getElementById('cancelModal').classList.add('active');
    }
    
    function closeCancelModal() {
        document.getElementById('cancelModal').classList.remove('active');
    }
    
    window.onclick = function(event) {
        const modal = document.getElementById('cancelModal');
        if (event.target == modal) {
            closeCancelModal();
        }
    }
</script>