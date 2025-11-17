<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Reservation, java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="models.Passager" %>
<%@ page import="models.Conducteur" %>
<%
    // Récupération des attributs passés par le PassagerServlet.afficherReservations
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    Integer nbEnAttente = (Integer) request.getAttribute("nbEnAttente");
    Integer nbConfirmees = (Integer) request.getAttribute("nbConfirmees");
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    
    // Initialisation des compteurs si non fournis (pour éviter les erreurs d'affichage)
    if (nbEnAttente == null) nbEnAttente = 0;
    if (nbConfirmees == null) nbConfirmees = 0;
    if (totalReservations == null) totalReservations = 0;
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<style>
    /* ------------------------------------------- */
    /* Styles pour la grille de la liste */
    /* ------------------------------------------- */
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
    
    /* Barres de statut de couleur */
    .reservation-card.en-attente::before {
        background: #ffc107;
    }
    
    .reservation-card.confirmee::before {
        background: #28a745;
    }
    
    /* ------------------------------------------- */
    /* Styles pour l'en-tête et le statut */
    /* ------------------------------------------- */
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
    
    /* Couleurs des badges de statut */
    .status-en-attente {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-confirmee {
        background: #d4edda;
        color: #155724;
    }
    
    /* ------------------------------------------- */
    /* Détails et Actions */
    /* ------------------------------------------- */
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
    
    .reservation-actions {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        margin-top: 15px;
    }
    
    .btn-action {
        padding: 10px 20px;
        border-radius: 6px;
        border: none;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .btn-cancel {
        background: #f8d7da;
        color: #721c24;
    }
    
    .btn-cancel:hover {
        background: #f5c6cb;
        transform: translateY(-2px);
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
    
    /* ------------------------------------------- */
    /* Modal d'annulation */
    /* ------------------------------------------- */
    .modal-cancel {
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
    
    .modal-cancel.active {
        display: flex;
    }
    
    .modal-content {
        background: white;
        padding: 30px;
        border-radius: 12px;
        max-width: 500px;
        width: 90%;
        max-height: 90vh;
        overflow-y: auto;
    }
    
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .modal-header h3 {
        font-size: 22px;
        color: #2c3e50;
        margin: 0;
    }
    
    .close-modal {
        background: none;
        border: none;
        font-size: 28px;
        cursor: pointer;
        color: #6c757d;
        padding: 0;
        width: 30px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .modal-body {
        margin-bottom: 20px;
    }
    
    .modal-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }
    
    .btn {
        padding: 12px 24px;
        border-radius: 6px;
        border: none;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .btn-primary {
        background: #667eea;
        color: white;
    }
    
    .btn-primary:hover {
        background: #5a6fd8;
        transform: translateY(-1px);
    }
    
    .btn-cancel-modal {
        background: #dc3545;
        color: white;
    }
    
    .btn-cancel-modal:hover {
        background: #c82333;
    }
    
    /* ------------------------------------------- */
    /* Cartes de statistiques */
    /* ------------------------------------------- */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: white;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
    
    .stat-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .stat-card-header h3 {
        font-size: 16px;
        color: #7f8c8d;
        margin: 0;
    }
    
    .stat-icon {
        font-size: 24px;
    }
    
    .stat-card .value {
        font-size: 32px;
        font-weight: bold;
        color: #2c3e50;
        margin-top: 10px;
    }
    
    .stat-card .label {
        font-size: 14px;
        color: #95a5a6;
    }
    
    .orange { color: #ff9800; }
    .green { color: #4caf50; }
</style>

<div class="top-bar">
    <div>
        <h1>Mes Réservations</h1>
        <div class="breadcrumb">Accueil / Réservations</div>
    </div>
</div>

<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>En Attente</h3>
            <div class="stat-icon orange">⏳</div>
        </div>
        <div class="value"><%= nbEnAttente %></div>
        <div class="label">En attente de confirmation</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-card-header">
            <h3>Confirmées</h3>
            <div class="stat-icon green">✅</div>
        </div>
        <div class="value"><%= nbConfirmees %></div>
        <div class="label">Réservations confirmées</div>
    </div>
</div>

<div class="content-section">
    <div class="section-header">
        <h2>Mes Réservations Actives (<%= totalReservations %>)</h2>
        <p style="color: #6c757d; font-size: 14px; margin-top: 5px;">
            Réservations en attente de confirmation ou confirmées (trajets à venir)
        </p>
    </div>
    
    <% if (reservations == null || reservations.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-state-icon">📋</div>
            <h3>Aucune réservation active</h3>
            <p>Vous n'avez pas de réservations en cours</p>
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
                
                // Détermination des classes CSS et des labels basés sur le statut de la BD
                if ("EN_ATTENTE".equals(statut)) {
                    statusClass = "status-en-attente";
                    statusLabel = "En Attente";
                    cardClass = "en-attente";
                } else if ("CONFIRMEE".equals(statut)) {
                    statusClass = "status-confirmee";
                    statusLabel = "Confirmée";
                    cardClass = "confirmee";
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
                                    // Vérification sécurisée du conducteur
                                    Conducteur conducteur = reservation.getOffre().getConducteur();
                                    if (conducteur != null && conducteur.getPrenom() != null) {
                                        out.print(conducteur.getPrenom() + " " + conducteur.getNom());
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
                    
                    <div class="reservation-actions">
                        <% if ("EN_ATTENTE".equals(statut)) { %>
                            <span style="color: #856404; font-size: 14px; display: flex; align-items: center;">
                                ⏳ En attente de confirmation du conducteur
                            </span>
                            <button class="btn-action btn-cancel" onclick="cancelReservation(<%= reservation.getIdReservation() %>)">
                                ❌ Annuler
                            </button>
                        <% } else if ("CONFIRMEE".equals(statut)) { %>
                            <button class="btn-action btn-cancel" onclick="cancelReservation(<%= reservation.getIdReservation() %>)">
                                ❌ Annuler la Réservation
                            </button>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<!-- Modal d'annulation -->
<div id="cancelModal" class="modal-cancel">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Confirmer l'annulation</h3>
            <button class="close-modal" onclick="closeCancelModal()">&times;</button>
        </div>
        <div class="modal-body">
            <p>Êtes-vous sûr de vouloir annuler cette réservation ? Cette action est irréversible.</p>
        </div>
        <div class="modal-actions">
            <button class="btn btn-primary" onclick="closeCancelModal()">Retour</button> 
            <form method="POST" action="Passager" style="display: inline;">
                <input type="hidden" name="action" value="annulerReservation">
                <input type="hidden" name="reservationId" id="cancelReservationId">
                <button type="submit" class="btn btn-cancel-modal">Confirmer l'annulation</button>
            </form>
        </div>
    </div>
</div>

<script>
    // Fonction appelée par le bouton Annuler de la carte de réservation
    function cancelReservation(id) {
        document.getElementById('cancelReservationId').value = id;
        document.getElementById('cancelModal').classList.add('active');
    }
    
    // Ferme le modal d'annulation
    function closeCancelModal() {
        document.getElementById('cancelModal').classList.remove('active');
    }
    
    // Fermer le modal en cliquant à l'extérieur
    window.onclick = function(event) {
        const modalCancel = document.getElementById('cancelModal');
        if (event.target == modalCancel) {
            closeCancelModal();
        }
    }
</script>