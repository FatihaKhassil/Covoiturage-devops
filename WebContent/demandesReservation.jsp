<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur, models.Reservation, models.Passager, models.Offre, models.Evaluation, java.util.List, java.text.SimpleDateFormat, java.sql.Connection, java.util.Date" %>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    
    // ✅ CORRECTION : Récupérer les messages AVANT de les supprimer
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    
    // ✅ Supprimer les messages APRÈS les avoir récupérés
    if (success != null) {
        session.removeAttribute("success");
    }
    if (error != null) {
        session.removeAttribute("error");
    }
    
    List<Reservation> enAttente = (List<Reservation>) request.getAttribute("enAttente");
    List<Reservation> confirmees = (List<Reservation>) request.getAttribute("confirmees");
    List<Reservation> annulees = (List<Reservation>) request.getAttribute("annulees");
    List<Reservation> terminees = (List<Reservation>) request.getAttribute("terminees");
    
    // Récupérer la map des évaluations existantes
    java.util.Map<Long, Evaluation> evaluationsExistantes = (java.util.Map<Long, Evaluation>) request.getAttribute("evaluationsExistantes");
    if (evaluationsExistantes == null) {
        evaluationsExistantes = new java.util.HashMap<>();
    }
    
    Integer nbEnAttente = (Integer) request.getAttribute("nbEnAttente");
    Integer nbConfirmees = (Integer) request.getAttribute("nbConfirmees");
    Integer nbAnnulees = (Integer) request.getAttribute("nbAnnulees");
    Integer nbTerminees = (Integer) request.getAttribute("nbTerminees");
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    
    if (nbEnAttente == null) nbEnAttente = 0;
    if (nbConfirmees == null) nbConfirmees = 0;
    if (nbAnnulees == null) nbAnnulees = 0;
    if (nbTerminees == null) nbTerminees = 0;
    if (totalReservations == null) totalReservations = 0;
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    // Date actuelle pour vérifier si le trajet est passé
    Date dateActuelle = new Date();
%>

<style>
    /* Styles pour les alertes */
    .alert {
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 15px;
        font-weight: 500;
        border: 1px solid;
    }
    
    .alert-success {
        background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
        color: #155724;
        border-color: #c3e6cb;
    }
    
    .alert-error {
        background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
        color: #721c24;
        border-color: #f5c6cb;
    }
    
    .alert i {
        font-size: 18px;
    }
    
    .alert-success i {
        color: #28a745;
    }
    
    .alert-error i {
        color: #dc3545;
    }

    .demandes-stats {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-bottom: 25px;
    }
    
    .stat-mini {
        background: white;
        padding: 20px;
        border-radius: 10px;
        text-align: center;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .stat-mini .number {
        font-size: 32px;
        font-weight: bold;
        color: #667eea;
        margin-bottom: 5px;
    }
    
    .stat-mini.warning .number { color: #ff9800; }
    .stat-mini.success .number { color: #4caf50; }
    .stat-mini.danger .number { color: #e74c3c; }
    .stat-mini.info .number { color: #17a2b8; }
    
    .stat-mini .label {
        font-size: 14px;
        color: #6c757d;
    }
    
    .tabs-container {
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .tabs-header {
        display: flex;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .tab-button {
        flex: 1;
        padding: 15px 20px;
        background: none;
        border: none;
        font-size: 15px;
        font-weight: 600;
        color: #6c757d;
        cursor: pointer;
        transition: all 0.3s;
        position: relative;
    }
    
    .tab-button:hover { background: #f8f9fa; }
    .tab-button.active { color: #667eea; }
    
    .tab-button.active::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        right: 0;
        height: 3px;
        background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
    }
    
    .tab-badge {
        display: inline-block;
        background: #e74c3c;
        color: white;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 12px;
        margin-left: 8px;
    }
    
    .tab-content {
        display: none;
        padding: 25px;
    }
    
    .tab-content.active { display: block; }
    
    .demande-card {
        background: #f8f9fa;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 15px;
        transition: all 0.3s;
        border-left: 4px solid transparent;
    }
    
    .demande-card:hover {
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        transform: translateX(5px);
    }
    
    .demande-card.en-attente { border-left-color: #ff9800; }
    .demande-card.confirmee { border-left-color: #4caf50; }
    .demande-card.annulee { border-left-color: #e74c3c; }
    .demande-card.terminee { border-left-color: #17a2b8; }
    
    .demande-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 15px;
    }
    
    .passager-info {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .passager-avatar {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 24px;
        font-weight: bold;
    }
    
    .passager-details h4 {
        font-size: 18px;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    
    .passager-rating {
        display: flex;
        align-items: center;
        gap: 5px;
        font-size: 14px;
        color: #f39c12;
    }
    
    .demande-status {
        padding: 6px 15px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
    }
    
    .status-en-attente { background: #fff3cd; color: #856404; }
    .status-confirmee { background: #d4edda; color: #155724; }
    .status-annulee { background: #f8d7da; color: #721c24; }
    .status-terminee { background: #d1ecf1; color: #0c5460; }
    
    .trajet-info {
        background: white;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 15px;
    }
    
    .trajet-route {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 10px;
        font-weight: 600;
        color: #2c3e50;
    }
    
    .trajet-route .arrow { color: #667eea; }
    
    .trajet-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 15px;
        margin-top: 10px;
    }
    
    .trajet-detail-item {
        font-size: 14px;
        color: #6c757d;
    }
    
    .trajet-detail-item strong {
        color: #2c3e50;
        display: block;
        margin-bottom: 3px;
    }
    
    .demande-message {
        background: white;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 15px;
        font-size: 14px;
        color: #495057;
        line-height: 1.6;
        font-style: italic;
    }
    
    .demande-actions {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
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
    
    .btn-accept {
        background: #d4edda;
        color: #155724;
    }
    
    .btn-accept:hover {
        background: #c3e6cb;
        transform: translateY(-2px);
    }
    
    .btn-reject {
        background: #f8d7da;
        color: #721c24;
    }
    
    .btn-reject:hover {
        background: #f5c6cb;
        transform: translateY(-2px);
    }
    
    .btn-contact {
        background: #e7f3ff;
        color: #0066cc;
    }
    
    .btn-contact:hover { background: #cce5ff; }
    
    .btn-terminer {
        background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
        color: white;
    }
    
    .btn-terminer:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 10px rgba(23, 162, 184, 0.3);
    }
    
    .btn-evaluate {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .btn-evaluate:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 10px rgba(102, 126, 234, 0.3);
    }
    
    .evaluation-info {
        background: #d4edda;
        padding: 10px 15px;
        border-radius: 6px;
        font-size: 14px;
        color: #155724;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .trajet-passe-info {
        background: #fff3cd;
        padding: 10px 15px;
        border-radius: 6px;
        font-size: 13px;
        color: #856404;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .evaluation-modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.6);
        z-index: 9999;
        align-items: center;
        justify-content: center;
    }
    
    .evaluation-modal.active { display: flex; }
    
    .evaluation-modal-content {
        background: white;
        padding: 30px;
        border-radius: 12px;
        max-width: 500px;
        width: 90%;
        box-shadow: 0 10px 40px rgba(0,0,0,0.2);
    }
    
    .evaluation-header {
        text-align: center;
        margin-bottom: 25px;
    }
    
    .evaluation-header h3 {
        font-size: 24px;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .evaluation-user {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 15px;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
    }
    
    .evaluation-user-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 20px;
        font-weight: bold;
    }
    
    .star-rating {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin: 25px 0;
    }
    
    .star {
        font-size: 40px;
        cursor: pointer;
        color: #ddd;
        transition: all 0.2s;
    }
    
    .star:hover,
    .star.active {
        color: #ffc107;
        transform: scale(1.2);
    }
    
    .evaluation-form textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        resize: vertical;
        min-height: 100px;
        font-family: inherit;
        box-sizing: border-box;
    }
    
    .evaluation-form label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #2c3e50;
    }
    
    .evaluation-actions {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }
    
    .evaluation-actions button {
        flex: 1;
        padding: 12px;
        border-radius: 8px;
        border: none;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-cancel-eval {
        background: #f0f0f0;
        color: #6c757d;
    }
    
    .btn-cancel-eval:hover {
        background: #e0e0e0;
    }
    
    .btn-submit-eval {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .btn-submit-eval:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }
    
    .btn-submit-eval:disabled {
        background: #ccc;
        cursor: not-allowed;
        transform: none;
    }
    
    .btn-terminer {
        background: #d1ecf1;
        color: #0c5460;
    }
    
    .btn-terminer:hover {
        background: #bee5eb;
        transform: translateY(-2px);
    }
    
    .btn-evaluer {
        background: #fff3cd;
        color: #856404;
    }
    
    .btn-evaluer:hover {
        background: #ffeaa7;
        transform: translateY(-2px);
    }
    
    .btn-evaluated {
        background: #e2e3e5;
        color: #6c757d;
        cursor: not-allowed;
    }
    
    .empty-demandes {
        text-align: center;
        padding: 60px 20px;
        color: #6c757d;
    }
    
    .empty-demandes-icon {
        font-size: 64px;
        margin-bottom: 20px;
        opacity: 0.5;
    }
    
    .empty-demandes h3 {
        font-size: 22px;
        color: #495057;
        margin-bottom: 10px;
    }
    
    .empty-demandes p {
        font-size: 16px;
    }
    
    .demande-time {
        font-size: 13px;
        color: #95a5a6;
        margin-top: 5px;
    }
    
    .contact-info {
        background: #e7f3ff;
        padding: 10px 15px;
        border-radius: 6px;
        margin-top: 10px;
        font-size: 14px;
    }
    
    .contact-info strong {
        color: #0066cc;
    }
    
    .evaluation-info {
        background: #d4edda;
        padding: 10px 15px;
        border-radius: 6px;
        margin-top: 10px;
        font-size: 14px;
        color: #155724;
    }
    
    /* Styles améliorés pour l'affichage des évaluations */
    .evaluation-display {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        margin-top: 10px;
        border-left: 4px solid #28a745;
    }
    
    .evaluation-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }
    
    .evaluation-note {
        font-size: 16px;
        font-weight: 600;
        color: #2c3e50;
    }
    
    .stars-display {
        display: flex;
        gap: 2px;
    }
    
    .star-filled {
        color: #ffc107;
        font-size: 18px;
    }
    
    .star-empty {
        color: #ddd;
        font-size: 18px;
    }
    
    .evaluation-comment {
        font-size: 14px;
        color: #495057;
        line-height: 1.5;
        font-style: italic;
        margin-top: 8px;
        padding-top: 8px;
        border-top: 1px solid #e9ecef;
    }
    
    .evaluation-date {
        font-size: 12px;
        color: #6c757d;
        margin-top: 5px;
    }

    /* Styles pour le modal d'évaluation */
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
    
    .rating-container {
        text-align: center;
        margin-bottom: 25px;
    }
    
    .rating-label {
        font-size: 16px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 15px;
        display: block;
    }
    
    .rating-stars {
        display: flex;
        gap: 5px;
        justify-content: center;
        margin-bottom: 10px;
    }
    
    .star {
        background: none;
        border: none;
        font-size: 40px;
        cursor: pointer;
        transition: all 0.2s;
        padding: 5px;
        color: #ddd;
    }
    
    .star:hover {
        transform: scale(1.2);
    }
    
    .star.active {
        color: #ffc107;
        text-shadow: 0 0 10px rgba(255, 193, 7, 0.5);
    }
    
    .star.hover {
        color: #ffc107;
    }
    
    .rating-text {
        font-size: 14px;
        color: #6c757d;
        margin-top: 5px;
        min-height: 20px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #2c3e50;
    }
    
    .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        resize: vertical;
        font-family: inherit;
        font-size: 14px;
    }
    
    .form-group textarea:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
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
    
    .btn-complete {
        background: #28a745;
        color: white;
    }
    
    .btn-complete:hover {
        background: #218838;
    }
</style>

<div class="top-bar">
    <div>
        <h1>Demandes de Réservation</h1>
    </div>
</div>

<div style="margin-bottom: 20px;">
    <% if (success != null) { %>
        <div class="alert alert-success">
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle"></i>
                <div>
                    <strong>Succès !</strong> <%= success %>
                </div>
            </div>
        </div>
    <% } %>
    
    <% if (error != null) { %>
        <div class="alert alert-error">
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-exclamation-triangle"></i>
                <div>
                    <strong>Information</strong> <%= error %>
                </div>
            </div>
        </div>
    <% } %>
</div>

<div class="demandes-stats">
    <div class="stat-mini warning">
        <div class="number"><%= nbEnAttente %></div>
        <div class="label">En Attente</div>
    </div>
    <div class="stat-mini success">
        <div class="number"><%= nbConfirmees %></div>
        <div class="label">Confirmées</div>
    </div>
    <div class="stat-mini danger">
        <div class="number"><%= nbAnnulees %></div>
        <div class="label">Annulées</div>
    </div>
    <div class="stat-mini info">
        <div class="number"><%= nbTerminees %></div>
        <div class="label">Terminées</div>
    </div>
</div>

<div class="tabs-container">
    <div class="tabs-header">
        <button class="tab-button active" onclick="showTab('en-attente')">
            ⏳ En Attente <% if (nbEnAttente > 0) { %><span class="tab-badge"><%= nbEnAttente %></span><% } %>
        </button>
        <button class="tab-button" onclick="showTab('confirmees')">
            ✅ Confirmées
        </button>
        <button class="tab-button" onclick="showTab('annulees')">
            ❌ Annulées
        </button>
        <button class="tab-button" onclick="showTab('terminees')">
            🎯 Terminées
        </button>
    </div>
    
    <div id="tab-en-attente" class="tab-content active">
        <% if (enAttente == null || enAttente.isEmpty()) { %>
            <div class="empty-demandes">
                <div class="empty-demandes-icon">⏳</div>
                <h3>Aucune demande en attente</h3>
                <p>Les nouvelles demandes de réservation apparaîtront ici</p>
            </div>
        <% } else { %>
            <% for (Reservation reservation : enAttente) { 
                Passager passager = reservation.getPassager();
                Offre offre = reservation.getOffre();
                String initiales = "";
                if (passager != null && passager.getPrenom() != null && passager.getNom() != null) {
                    initiales = passager.getPrenom().substring(0, 1).toUpperCase() + 
                               passager.getNom().substring(0, 1).toUpperCase();
                }
            %>
                <div class="demande-card en-attente">
                    <div class="demande-header">
                        <div class="passager-info">
                            <div class="passager-avatar"><%= initiales %></div>
                            <div class="passager-details">
                                <h4><%= passager != null ? passager.getPrenom() + " " + passager.getNom() : "N/A" %></h4>
                                <div class="passager-rating">
                                    <%= generateStarsDisplay(passager != null ? passager.getNoteMoyenne() : 0.0) %>
                                    <%= String.format("%.1f", passager != null ? passager.getNoteMoyenne() : 0.0) %>/5
                                </div>
                                <div class="demande-time">🕒 <%= dateTimeFormat.format(reservation.getDateReservation()) %></div>
                            </div>
                        </div>
                        <span class="demande-status status-en-attente">En Attente</span>
                    </div>
                    
                    <div class="trajet-info">
                        <div class="trajet-route">
                            📍 <%= offre.getVilleDepart() %> <span class="arrow">→</span> <%= offre.getVilleArrivee() %>
                        </div>
                        <div class="trajet-details">
                            <div class="trajet-detail-item">
                                <strong>Date</strong>
                                <%= dateFormat.format(offre.getDateDepart()) %>
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Heure</strong>
                                <%= timeFormat.format(offre.getHeureDepart()) %>
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Places</strong>
                                <%= reservation.getNombrePlaces() %> place(s)
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Montant</strong>
                                <%= String.format("%.0f", reservation.getPrixTotal()) %> DH
                            </div>
                        </div>
                    </div>
                    
                    <% if (reservation.getMessagePassager() != null && !reservation.getMessagePassager().trim().isEmpty()) { %>
                        <div class="demande-message">
                            💬 "<%= reservation.getMessagePassager() %>"
                        </div>
                    <% } %>
                    
                    <div class="demande-actions">
                        <button class="btn-action btn-accept" onclick="confirmerReservation(<%= reservation.getIdReservation() %>)">
                            ✅ Accepter
                        </button>
                        <button class="btn-action btn-reject" onclick="refuserReservation(<%= reservation.getIdReservation() %>)">
                            ❌ Refuser
                        </button>
                        <% if (passager != null && passager.getTelephone() != null) { %>
                            <a href="tel:<%= passager.getTelephone() %>" class="btn-action btn-contact" style="text-decoration: none;">
                                📞 <%= passager.getTelephone() %>
                            </a>
                        <% } %>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
    
    <div id="tab-confirmees" class="tab-content">
        <% if (confirmees == null || confirmees.isEmpty()) { %>
            <div class="empty-demandes">
                <div class="empty-demandes-icon">✅</div>
                <h3>Aucune réservation confirmée</h3>
                <p>Les réservations confirmées apparaîtront ici</p>
            </div>
        <% } else { %>
            <% for (Reservation reservation : confirmees) { 
                Passager passager = reservation.getPassager();
                Offre offre = reservation.getOffre();
                String initiales = "";
                if (passager != null && passager.getPrenom() != null && passager.getNom() != null) {
                    initiales = passager.getPrenom().substring(0, 1).toUpperCase() + 
                               passager.getNom().substring(0, 1).toUpperCase();
                }
                
                // ✅ VÉRIFIER SI LE TRAJET EST PASSÉ
                boolean trajetPasse = false;
                if (offre != null && offre.getDateDepart() != null) {
                    trajetPasse = offre.getDateDepart().before(dateActuelle);
                }
            %>
                <div class="demande-card confirmee">
                    <div class="demande-header">
                        <div class="passager-info">
                            <div class="passager-avatar"><%= initiales %></div>
                            <div class="passager-details">
                                <h4><%= passager != null ? passager.getPrenom() + " " + passager.getNom() : "N/A" %></h4>
                                <div class="passager-rating">
                                    <%= generateStarsDisplay(passager != null ? passager.getNoteMoyenne() : 0.0) %>
                                    <%= String.format("%.1f", passager != null ? passager.getNoteMoyenne() : 0.0) %>/5
                                </div>
                                <div class="demande-time">✅ Confirmée le <%= dateFormat.format(reservation.getDateReservation()) %></div>
                            </div>
                        </div>
                        <span class="demande-status status-confirmee">Confirmée</span>
                    </div>
                    
                    <% if (trajetPasse) { %>
                        <div class="trajet-passe-info">
                            ⏰ Le trajet est passé - Vous pouvez le marquer comme terminé
                        </div>
                    <% } %>
                    
                    <div class="trajet-info">
                        <div class="trajet-route">
                            📍 <%= offre.getVilleDepart() %> <span class="arrow">→</span> <%= offre.getVilleArrivee() %>
                        </div>
                        <div class="trajet-details">
                            <div class="trajet-detail-item">
                                <strong>Date</strong>
                                <%= dateFormat.format(offre.getDateDepart()) %>
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Heure</strong>
                                <%= timeFormat.format(offre.getHeureDepart()) %>
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Places</strong>
                                <%= reservation.getNombrePlaces() %> place(s)
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Montant</strong>
                                <%= String.format("%.0f", reservation.getPrixTotal()) %> DH
                            </div>
                        </div>
                    </div>
                    
                    <% if (passager != null && passager.getTelephone() != null) { %>
                        <div class="contact-info">
                            <strong>📞 Téléphone:</strong> <%= passager.getTelephone() %>
                        </div>
                    <% } %>
                    
                    <div class="demande-actions">
                        
                        <% if (trajetPasse) { %>
                            <button class="btn-action btn-terminer" onclick="terminerReservation(<%= reservation.getIdReservation() %>)">
                                🎯 Marquer comme terminé
                            </button>
                        <% } %>
                        
                        <button class="btn-action btn-reject" onclick="refuserReservation(<%= reservation.getIdReservation() %>)">
                            ❌ Annuler
                        </button>
                        
                        <% if (passager != null && passager.getTelephone() != null) { %>
                            <a href="tel:<%= passager.getTelephone() %>" class="btn-action btn-contact" style="text-decoration: none;">
                                📞 Appeler
                            </a>
                        <% } %>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
    
    <div id="tab-annulees" class="tab-content">
        <% if (annulees == null || annulees.isEmpty()) { %>
            <div class="empty-demandes">
                <div class="empty-demandes-icon">❌</div>
                <h3>Aucune réservation annulée</h3>
                <p>Les réservations annulées apparaîtront ici</p>
            </div>
        <% } else { %>
            <% for (Reservation reservation : annulees) { 
                Passager passager = reservation.getPassager();
                Offre offre = reservation.getOffre();
                String initiales = "";
                if (passager != null && passager.getPrenom() != null && passager.getNom() != null) {
                    initiales = passager.getPrenom().substring(0, 1).toUpperCase() + 
                               passager.getNom().substring(0, 1).toUpperCase();
                }
            %>
                <div class="demande-card annulee">
                    <div class="demande-header">
                        <div class="passager-info">
                            <div class="passager-avatar"><%= initiales %></div>
                            <div class="passager-details">
                                <h4><%= passager != null ? passager.getPrenom() + " " + passager.getNom() : "N/A" %></h4>
                                <div class="demande-time">❌ Annulée</div>
                            </div>
                        </div>
                        <span class="demande-status status-annulee">Annulée</span>
                    </div>
                    
                    <div class="trajet-info">
                        <div class="trajet-route">
                            📍 <%= offre.getVilleDepart() %> <span class="arrow">→</span> <%= offre.getVilleArrivee() %>
                        </div>
                        <div class="trajet-details">
                            <div class="trajet-detail-item">
                                <strong>Date</strong>
                                <%= dateFormat.format(offre.getDateDepart()) %>
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Places</strong>
                                <%= reservation.getNombrePlaces() %> place(s)
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
    
    <div id="tab-terminees" class="tab-content">
        <% if (terminees == null || terminees.isEmpty()) { %>
            <div class="empty-demandes">
                <div class="empty-demandes-icon">🎯</div>
                <h3>Aucun trajet terminé</h3>
                <p>Les trajets terminés apparaîtront ici</p>
            </div>
        <% } else { %>
            <% for (Reservation reservation : terminees) { 
                Passager passager = reservation.getPassager();
                Offre offre = reservation.getOffre();
                String initiales = "";
                if (passager != null && passager.getPrenom() != null && passager.getNom() != null) {
                    initiales = passager.getPrenom().substring(0, 1).toUpperCase() + 
                               passager.getNom().substring(0, 1).toUpperCase();
                }
                
                // Vérifier si une évaluation existe déjà pour cette réservation
                boolean dejaEvalue = evaluationsExistantes.containsKey(reservation.getIdReservation());
                Evaluation evaluation = evaluationsExistantes.get(reservation.getIdReservation());
            %>
                <div class="demande-card terminee">
                    <div class="demande-header">
                        <div class="passager-info">
                            <div class="passager-avatar"><%= initiales %></div>
                            <div class="passager-details">
                                <h4><%= passager != null ? passager.getPrenom() + " " + passager.getNom() : "N/A" %></h4>
                                <div class="passager-rating">
                                    <%= generateStarsDisplay(passager != null ? passager.getNoteMoyenne() : 0.0) %>
                                    <%= String.format("%.1f", passager != null ? passager.getNoteMoyenne() : 0.0) %>/5
                                </div>
                                <div class="demande-time">🎯 Trajet terminé</div>
                            </div>
                        </div>
                        <span class="demande-status status-terminee">Terminée</span>
                    </div>
                    
                    <div class="trajet-info">
                        <div class="trajet-route">
                            📍 <%= offre.getVilleDepart() %> <span class="arrow">→</span> <%= offre.getVilleArrivee() %>
                        </div>
                        <div class="trajet-details">
                            <div class="trajet-detail-item">
                                <strong>Date</strong>
                                <%= dateFormat.format(offre.getDateDepart()) %>
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Heure</strong>
                                <%= timeFormat.format(offre.getHeureDepart()) %>
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Places</strong>
                                <%= reservation.getNombrePlaces() %> place(s)
                            </div>
                            <div class="trajet-detail-item">
                                <strong>Revenus</strong>
                                <%= String.format("%.0f", reservation.getPrixTotal()) %> DH
                            </div>
                        </div>
                    </div>
                    
                    <% if (dejaEvalue && evaluation != null) { %>
                        <div class="evaluation-display">
                            <div class="evaluation-header">
                                <div class="evaluation-note">Votre évaluation</div>
                                <div class="stars-display">
                                    <%= generateStarsDisplay(evaluation.getNote()) %>
                                </div>
                            </div>
                            <% if (evaluation.getCommentaire() != null && !evaluation.getCommentaire().trim().isEmpty()) { %>
                                <div class="evaluation-comment">
                                    "<%= evaluation.getCommentaire() %>"
                                </div>
                            <% } %>
                            <div class="evaluation-date">
                                Évalué le <%= dateFormat.format(evaluation.getDateEvaluation()) %>
                            </div>
                        </div>
                    <% } %>
                    
                    <div class="demande-actions">
                        <% if (!dejaEvalue) { %>
                            <button class="btn-action btn-evaluer" 
                                    onclick="ouvrirEvaluation(<%= reservation.getIdReservation() %>, <%= passager != null ? passager.getId() : "0" %>)">
                                ⭐ Évaluer le passager
                            </button>
                        <% } else { %>
                            <button class="btn-action btn-evaluated" disabled>
                                ✅ Déjà évalué
                            </button>
                        <% } %>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
    
</div>

<div id="evaluerModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Évaluer le Passager</h3>
            <button class="close-modal" onclick="closeEvaluerModal()">&times;</button>
        </div>
        <form method="POST" action="Conducteur" id="evaluationForm">
            <input type="hidden" name="action" value="evaluerPassager">
            <input type="hidden" name="reservationId" id="evalReservationId">
            <input type="hidden" name="idPassager" id="evalPassagerId">
            
            <div class="modal-body">
                <div class="rating-container">
                    <span class="rating-label">Donnez une note de 1 à 5 étoiles</span>
                    <div class="rating-stars">
                        <% for (int i = 1; i <= 5; i++) { %>
                            <button type="button" class="star" data-value="<%= i %>" 
                                    onmouseover="hoverStar(<%= i %>)" 
                                    onmouseout="resetStars()" 
                                    onclick="setNote(<%= i %>)">
                                ⭐
                            </button>
                        <% } %>
                    </div>
                    <div class="rating-text" id="ratingText">Sélectionnez une note</div>
                    <input type="hidden" name="note" id="noteInput" required>
                </div>
                
                <div class="form-group">
                    <label for="commentaire">Commentaire (optionnel)</label>
                    <textarea name="commentaire" id="commentaire" rows="4" 
                              placeholder="Partagez votre expérience avec ce passager..."></textarea>
                </div>
            </div>
            
            <div class="modal-actions">
                <button type="button" class="btn btn-primary" onclick="closeEvaluerModal()">Annuler</button>
                <button type="submit" class="btn btn-complete" id="submitEvaluation" disabled>
                    Envoyer l'évaluation
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let currentNote = 0;
    let currentHover = 0;

    function showTab(tabName) {
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.classList.remove('active');
        });
        
        document.querySelectorAll('.tab-button').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // La ligne ci-dessous doit être adaptée si vous utilisez un système d'onglets avancé
        const targetTab = document.getElementById('tab-' + tabName);
        if (targetTab) {
            targetTab.classList.add('active');
        }

        // Trouver le bouton cliqué pour lui ajouter la classe active
        const clickedButton = event.target.closest('.tab-button');
        if (clickedButton) {
            clickedButton.classList.add('active');
        }
    }
    
    // ========== ACTIONS RÉSERVATIONS ==========
    function confirmerReservation(id) {
        if (confirm('✅ Confirmer cette réservation ?\n\nLe passager sera notifié et les places seront réservées.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'Conducteur';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'confirmerReservation';
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'reservationId';
            idInput.value = id;
            
            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }
    }
    
    function terminerReservation(id) {
        if (confirm('🎯 Marquer cette réservation comme terminée ?\n\nVous pourrez ensuite évaluer le passager.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'Conducteur';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'terminerReservation';
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'reservationId';
            idInput.value = id;
            
            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }
    }
    
    function refuserReservation(id) {
        const motif = prompt('❌ Raison du refus/annulation (optionnel):');
        if (motif !== null) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'Conducteur';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'refuserReservation';
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'reservationId';
            idInput.value = id;
            
            const motifInput = document.createElement('input');
            motifInput.type = 'hidden';
            motifInput.name = 'motif';
            motifInput.value = motif;
            
            form.appendChild(actionInput);
            form.appendChild(idInput);
            form.appendChild(motifInput);
            document.body.appendChild(form);
            form.submit();
        }
    }

    // ========== GESTION MODAL ÉVALUATION ==========
    
    function ouvrirEvaluation(reservationId, passagerId) {
        document.getElementById('evalReservationId').value = reservationId;
        document.getElementById('evalPassagerId').value = passagerId;
        document.getElementById('evaluerModal').classList.add('active');
        resetEvaluationForm();
    }
    
    function closeEvaluerModal() {
        document.getElementById('evaluerModal').classList.remove('active');
    }
    
    function resetEvaluationForm() {
        currentNote = 0;
        currentHover = 0;
        document.getElementById('noteInput').value = '';
        document.getElementById('commentaire').value = '';
        document.getElementById('submitEvaluation').disabled = true;
        resetStars();
        updateRatingText();
    }
    
    function hoverStar(note) {
        currentHover = note;
        updateStarsDisplay();
        updateRatingText();
    }
    
    function resetStars() {
        currentHover = 0;
        updateStarsDisplay();
        updateRatingText();
    }
    
    function setNote(note) {
        currentNote = note;
        document.getElementById('noteInput').value = note;
        document.getElementById('submitEvaluation').disabled = false;
        updateStarsDisplay();
        updateRatingText();
    }
    
    function updateStarsDisplay() {
        const stars = document.querySelectorAll('.star');
        const displayNote = currentHover || currentNote;
        
        stars.forEach((star, index) => {
            const starValue = index + 1;
            if (starValue <= displayNote) {
                star.classList.add('active');
                if (currentHover > 0 && currentNote === 0) {
                    star.classList.add('hover');
                } else {
                    star.classList.remove('hover');
                }
            } else {
                star.classList.remove('active');
                star.classList.remove('hover');
            }
        });
    }
    
    function updateRatingText() {
        const ratingText = document.getElementById('ratingText');
        const displayNote = currentHover || currentNote;
        
        if (displayNote === 0) {
            ratingText.textContent = 'Sélectionnez une note';
            ratingText.style.color = '#6c757d';
        } else {
            const texts = {
                1: 'Mauvais - Expérience très décevante',
                2: 'Moyen - Quelques problèmes',
                3: 'Bien - Expérience correcte',
                4: 'Très bien - Expérience positive',
                5: 'Excellent - Expérience exceptionnelle'
            };
            ratingText.textContent = texts[displayNote] || `Note: ${displayNote}/5`;
            ratingText.style.color = '#28a745';
        }
    }
    
    // Fermer le modal en cliquant à l'extérieur
    window.onclick = function(event) {
        const modal = document.getElementById('evaluerModal');
        if (event.target == modal) {
            closeEvaluerModal();
        }
    }
    
    // Empêcher la soumission du formulaire si aucune note n'est sélectionnée
    document.getElementById('evaluationForm').addEventListener('submit', function(e) {
        if (currentNote === 0) {
            e.preventDefault();
            alert('Veuillez sélectionner une note avant de soumettre l\'évaluation.');
        }
    });
</script>

<%!
    // Méthode helper pour générer l'affichage des étoiles
    public String generateStarsDisplay(double note) {
        StringBuilder stars = new StringBuilder();
        int fullStars = (int) note;
        // La version de Oumaima utilisait probablement seulement les étoiles pleines
        // On conserve la logique d'arrondi simple pour 5 étoiles.
        
        for (int i = 1; i <= 5; i++) {
            if (i <= fullStars) {
                stars.append("<span class='star-filled'>★</span>");
            } else {
                stars.append("<span class='star-empty'>☆</span>");
            }
        }
        
        return stars.toString();
    }
%>