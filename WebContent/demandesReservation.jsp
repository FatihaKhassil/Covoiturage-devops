<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur" %>
<%@ page import="models.Reservation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    
    // Filtrer les réservations par statut
    List<Reservation> enAttente = new ArrayList<>();
    List<Reservation> confirmees = new ArrayList<>();
    List<Reservation> refusees = new ArrayList<>();
    
    if (reservations != null) {
        for (Reservation r : reservations) {
            switch (r.getStatut()) {
                case "en_attente":
                    enAttente.add(r);
                    break;
                case "confirmee":
                    confirmees.add(r);
                    break;
                case "refusee":
                    refusees.add(r);
                    break;
            }
        }
    }
    
    int totalReservations = reservations != null ? reservations.size() : 0;
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
    
    .demande-card.refusee {
        border-left-color: #e74c3c;
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
    
    .status-refusee {
        background: #f8d7da;
        color: #721c24;
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
</style>

<div class="top-bar">
    <div>
        <h1>Demandes de Réservation</h1>
        <div class="breadcrumb">Accueil / Demandes</div>
    </div>
</div>

<!-- Statistiques des demandes -->
<div class="demandes-stats">
    <div class="stat-mini">
        <div class="number">5</div>
        <div class="label">En Attente</div>
    </div>
    <div class="stat-mini">
        <div class="number">12</div>
        <div class="label">Confirmées</div>
    </div>
    <div class="stat-mini">
        <div class="number">3</div>
        <div class="label">Refusées</div>
    </div>
    <div class="stat-mini">
        <div class="number">20</div>
        <div class="label">Total</div>
    </div>
</div>

<!-- Onglets -->
<div class="tabs-container">
    <div class="tabs-header">
        <button class="tab-button active" onclick="showTab('en-attente')">
            ⏳ En Attente <span class="tab-badge">5</span>
        </button>
        <button class="tab-button" onclick="showTab('confirmees')">
            ✅ Confirmées
        </button>
        <button class="tab-button" onclick="showTab('refusees')">
            ❌ Refusées
        </button>
        <button class="tab-button" onclick="showTab('historique')">
            📚 Historique
        </button>
    </div>
    
    <!-- Onglet En Attente -->
    <div id="tab-en-attente" class="tab-content active">
        <!-- Demande 1 -->
        <div class="demande-card en-attente">
            <div class="demande-header">
                <div class="passager-info">
                    <div class="passager-avatar">AE</div>
                    <div class="passager-details">
                        <h4>Ahmed El Amrani</h4>
                        <div class="passager-rating">
                            ⭐ 4.8/5 <span style="color: #6c757d;">(23 voyages)</span>
                        </div>
                        <div class="demande-time">🕒 Il y a 2 heures</div>
                    </div>
                </div>
                <span class="demande-status status-en-attente">En Attente</span>
            </div>
            
            <div class="trajet-info">
                <div class="trajet-route">
                    📍 Casablanca <span class="arrow">→</span> Rabat
                </div>
                <div class="trajet-details">
                    <div class="trajet-detail-item">
                        <strong>Date</strong>
                        Lundi 11 Nov 2025
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Heure</strong>
                        08:00
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Places</strong>
                        2 places
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Montant</strong>
                        100 DH (50 DH/place)
                    </div>
                </div>
            </div>
            
            <div class="demande-message">
                💬 "Bonjour, je souhaite réserver 2 places pour ce trajet. Je suis ponctuel et je voyage léger. Merci!"
            </div>
            
            <div class="demande-actions">
                <button class="btn-action btn-accept" onclick="confirmerReservation(1)">
                    ✅ Accepter
                </button>
                <button class="btn-action btn-reject" onclick="refuserReservation(1)">
                    ❌ Refuser
                </button>
                <button class="btn-action btn-contact" onclick="contacterPassager(1)">
                    💬 Contacter
                </button>
            </div>
        </div>
        
        <!-- Demande 2 -->
        <div class="demande-card en-attente">
            <div class="demande-header">
                <div class="passager-info">
                    <div class="passager-avatar">SK</div>
                    <div class="passager-details">
                        <h4>Salma Karim</h4>
                        <div class="passager-rating">
                            ⭐ 5.0/5 <span style="color: #6c757d;">(8 voyages)</span>
                        </div>
                        <div class="demande-time">🕒 Il y a 5 heures</div>
                    </div>
                </div>
                <span class="demande-status status-en-attente">En Attente</span>
            </div>
            
            <div class="trajet-info">
                <div class="trajet-route">
                    📍 Marrakech <span class="arrow">→</span> Agadir
                </div>
                <div class="trajet-details">
                    <div class="trajet-detail-item">
                        <strong>Date</strong>
                        Mercredi 13 Nov 2025
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Heure</strong>
                        14:30
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Places</strong>
                        1 place
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Montant</strong>
                        120 DH
                    </div>
                </div>
            </div>
            
            <div class="demande-message">
                💬 "Bonjour, est-il possible de faire un arrêt rapide à Essaouira ? Merci d'avance."
            </div>
            
            <div class="demande-actions">
                <button class="btn-action btn-accept" onclick="confirmerReservation(2)">
                    ✅ Accepter
                </button>
                <button class="btn-action btn-reject" onclick="refuserReservation(2)">
                    ❌ Refuser
                </button>
                <button class="btn-action btn-contact" onclick="contacterPassager(2)">
                    💬 Contacter
                </button>
            </div>
        </div>
    </div>
    
    <!-- Onglet Confirmées -->
    <div id="tab-confirmees" class="tab-content">
        <div class="demande-card confirmee">
            <div class="demande-header">
                <div class="passager-info">
                    <div class="passager-avatar">MB</div>
                    <div class="passager-details">
                        <h4>Mohammed Bennani</h4>
                        <div class="passager-rating">
                            ⭐ 4.6/5 <span style="color: #6c757d;">(15 voyages)</span>
                        </div>
                        <div class="demande-time">✅ Confirmée le 08 Nov 2025</div>
                    </div>
                </div>
                <span class="demande-status status-confirmee">Confirmée</span>
            </div>
            
            <div class="trajet-info">
                <div class="trajet-route">
                    📍 Casablanca <span class="arrow">→</span> Rabat
                </div>
                <div class="trajet-details">
                    <div class="trajet-detail-item">
                        <strong>Date</strong>
                        Lundi 11 Nov 2025
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Heure</strong>
                        08:00
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Places</strong>
                        1 place
                    </div>
                    <div class="trajet-detail-item">
                        <strong>Téléphone</strong>
                        0612345678
                    </div>
                </div>
            </div>
            
            <div class="demande-actions">
                <button class="btn-action btn-contact" onclick="contacterPassager(3)">
                    📞 Appeler
                </button>
                <button class="btn-action btn-reject" onclick="annulerReservation(3)">
                    ❌ Annuler
                </button>
            </div>
        </div>
    </div>
    
    <!-- Onglet Refusées -->
    <div id="tab-refusees" class="tab-content">
        <div class="demande-card refusee">
            <div class="demande-header">
                <div class="passager-info">
                    <div class="passager-avatar">FA</div>
                    <div class="passager-details">
                        <h4>Fatima Alaoui</h4>
                        <div class="passager-rating">
                            ⭐ 4.2/5 <span style="color: #6c757d;">(10 voyages)</span>
                        </div>
                        <div class="demande-time">❌ Refusée le 07 Nov 2025</div>
                    </div>
                </div>
                <span class="demande-status status-refusee">Refusée</span>
            </div>
            
            <div class="trajet-info">
                <div class="trajet-route">
                    📍 Fès <span class="arrow">→</span> Meknès
                </div>
                <div class="trajet-details">
                    <div class="trajet-detail-item">
                        <strong>Motif</strong>
                        Places déjà complètes
                    </div>
                </div>
            </div>
        </div>
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