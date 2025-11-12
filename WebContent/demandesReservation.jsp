<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur, models.Reservation, models.Passager, models.Offre, java.util.List, java.text.SimpleDateFormat" %>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    
    List<Reservation> enAttente = (List<Reservation>) request.getAttribute("enAttente");
    List<Reservation> confirmees = (List<Reservation>) request.getAttribute("confirmees");
    List<Reservation> annulees = (List<Reservation>) request.getAttribute("annulees");
    List<Reservation> terminees = (List<Reservation>) request.getAttribute("terminees");
    
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
%>

<style>
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
    
    .stat-mini.warning .number {
        color: #ff9800;
    }
    
    .stat-mini.success .number {
        color: #4caf50;
    }
    
    .stat-mini.danger .number {
        color: #e74c3c;
    }
    
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
    
    .tab-button:hover {
        background: #f8f9fa;
    }
    
    .tab-button.active {
        color: #667eea;
    }
    
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
    
    .tab-content.active {
        display: block;
    }
    
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
    
    .demande-card.en-attente {
        border-left-color: #ff9800;
    }
    
    .demande-card.confirmee {
        border-left-color: #4caf50;
    }
    
    .demande-card.annulee {
        border-left-color: #e74c3c;
    }
    
    .demande-card.terminee {
        border-left-color: #17a2b8;
    }
    
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
    
    .status-en-attente {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-confirmee {
        background: #d4edda;
        color: #155724;
    }
    
    .status-annulee {
        background: #f8d7da;
        color: #721c24;
    }
    
    .status-terminee {
        background: #d1ecf1;
        color: #0c5460;
    }
    
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
    
    .trajet-route .arrow {
        color: #667eea;
    }
    
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
    
    .btn-contact:hover {
        background: #cce5ff;
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
</style>

<div class="top-bar">
    <div>
        <h1>Demandes de Réservation</h1>
        <div class="breadcrumb">Accueil / Demandes</div>
    </div>
</div>

<!-- Statistiques des demandes -->
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
    <div class="stat-mini">
        <div class="number"><%= totalReservations %></div>
        <div class="label">Total</div>
    </div>
</div>

<!-- Onglets -->
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
    
    <!-- Onglet En Attente -->
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
                                    ⭐ <%= String.format("%.1f", passager != null ? passager.getNoteMoyenne() : 0.0) %>/5
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
    
    <!-- Onglet Confirmées -->
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
            %>
                <div class="demande-card confirmee">
                    <div class="demande-header">
                        <div class="passager-info">
                            <div class="passager-avatar"><%= initiales %></div>
                            <div class="passager-details">
                                <h4><%= passager != null ? passager.getPrenom() + " " + passager.getNom() : "N/A" %></h4>
                                <div class="passager-rating">
                                    ⭐ <%= String.format("%.1f", passager != null ? passager.getNoteMoyenne() : 0.0) %>/5
                                </div>
                                <div class="demande-time">✅ Confirmée le <%= dateFormat.format(reservation.getDateReservation()) %></div>
                            </div>
                        </div>
                        <span class="demande-status status-confirmee">Confirmée</span>
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
                    
                    <% if (passager != null && passager.getTelephone() != null) { %>
                        <div class="contact-info">
                            <strong>📞 Téléphone:</strong> <%= passager.getTelephone() %>
                        </div>
                    <% } %>
                    
                    <div class="demande-actions">
                        <% if (passager != null && passager.getTelephone() != null) { %>
                            <a href="tel:<%= passager.getTelephone() %>" class="btn-action btn-contact" style="text-decoration: none;">
                                📞 Appeler
                            </a>
                        <% } %>
                        <button class="btn-action btn-reject" onclick="refuserReservation(<%= reservation.getIdReservation() %>)">
                            ❌ Annuler
                        </button>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
    
    <!-- Onglet Annulées -->
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
    
    <!-- Onglet Historique -->
    <div id="tab-historique" class="tab-content">
        <div class="empty-demandes">
            <div class="empty-demandes-icon">📚</div>
            <h3>Historique des demandes</h3>
            <p>Toutes vos demandes traitées apparaîtront ici</p>
        </div>
    </div>
</div>

<script>
    function showTab(tabName) {
        // Masquer tous les onglets
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.classList.remove('active');
        });
        
        // Désactiver tous les boutons
        document.querySelectorAll('.tab-button').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // Activer l'onglet sélectionné
        document.getElementById('tab-' + tabName).classList.add('active');
        event.target.classList.add('active');
    }
    
    function confirmerReservation(id) {
        if (confirm('Confirmer cette réservation ?')) {
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
    
    function refuserReservation(id) {
        const motif = prompt('Raison du refus (optionnel):');
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
    
    function contacterPassager(id) {
        alert('Fonctionnalité de contact en développement');
    }
    
    function annulerReservation(id) {
        if (confirm('Êtes-vous sûr de vouloir annuler cette réservation confirmée ?')) {
            alert('Réservation annulée');
        }
    }
</script>