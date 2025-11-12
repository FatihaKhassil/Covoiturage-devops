<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur" %>
<%@ page import="models.Offre" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
    List<Offre> offres = (List<Offre>) request.getAttribute("offres");
    Integer totalOffres = (Integer) request.getAttribute("totalOffres");
    Integer offresActives = (Integer) request.getAttribute("offresActives");
    Integer offresCompletes = (Integer) request.getAttribute("offresCompletes");
    Integer offresTerminees = (Integer) request.getAttribute("offresTerminees");
    Integer offresAnnulees = (Integer) request.getAttribute("offresAnnulees");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    
    if (totalOffres == null) totalOffres = 0;
    if (offresActives == null) offresActives = 0;
    if (offresCompletes == null) offresCompletes = 0;
    if (offresTerminees == null) offresTerminees = 0;
    if (offresAnnulees == null) offresAnnulees = 0;
%>

<style>
    .offres-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 12px 25px;
        border: none;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: transform 0.3s, box-shadow 0.3s;
        cursor: pointer;
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }
    
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-bottom: 25px;
    }
    
    .stat-card {
        background: white;
        padding: 20px;
        border-radius: 8px;
        border-left: 4px solid #667eea;
    }
    
    .stat-card.active { border-left-color: #28a745; }
    .stat-card.full { border-left-color: #ffc107; }
    .stat-card.completed { border-left-color: #17a2b8; }
    .stat-card.cancelled { border-left-color: #dc3545; }
    
    .stat-card h4 {
        font-size: 14px;
        color: #6c757d;
        margin-bottom: 10px;
    }
    
    .stat-card .stat-value {
        font-size: 32px;
        font-weight: bold;
        color: #2c3e50;
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
        overflow: hidden;
    }
    
    .offre-card:hover {
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        transform: translateY(-3px);
    }
    
    .offre-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 5px;
        height: 100%;
        background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
    }
    
    .offre-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 20px;
    }
    
    .offre-route {
        flex: 1;
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
    
    .status-badge {
        padding: 6px 15px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .status-en-attente {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-validee {
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
    
    .offre-actions {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
    
    .btn {
        padding: 10px 20px;
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
    
    .btn-complete {
        background: #d4edda;
        color: #155724;
    }
    
    .btn-complete:hover {
        background: #c3e6cb;
    }
    
    .btn-cancel {
        background: #f8d7da;
        color: #721c24;
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
    
    .empty-state h3 {
        font-size: 24px;
        color: #495057;
        margin-bottom: 10px;
    }
    
    .empty-state p {
        font-size: 16px;
        margin-bottom: 25px;
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
        <h1>Gérer Mes Offres</h1>
        <div class="breadcrumb">Accueil / Mes Offres</div>
    </div>
    <a href="Conducteur?page=publier" class="btn-primary">
        ➕ Nouvelle Offre
    </a>
</div>

<!-- Statistiques -->
<div class="stats-grid">
    <div class="stat-card active">
        <h4>Offres Validées</h4>
        <div class="stat-value"><%= offresActives %></div>
    </div>
    <div class="stat-card full">
        <h4>En Attente</h4>
        <div class="stat-value"><%= offresCompletes %></div>
    </div>
    <div class="stat-card completed">
        <h4>Offres Terminées</h4>
        <div class="stat-value"><%= offresTerminees %></div>
    </div>
    <div class="stat-card cancelled">
        <h4>Offres Annulées</h4>
        <div class="stat-value"><%= offresAnnulees %></div>
    </div>
</div>

<!-- Liste des offres -->
<div class="content-section">
    <div class="section-header">
        <h2>Mes Trajets (<%= totalOffres %>)</h2>
    </div>
    
    <% if (offres == null || offres.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-state-icon">🚗</div>
            <h3>Aucune offre pour le moment</h3>
            <p>Commencez par publier votre première offre de covoiturage</p>
            <a href="Conducteur?page=publier" class="btn-primary">
                ➕ Publier une offre
            </a>
        </div>
    <% } else { %>
        <div class="offres-grid">
            <% for (Offre offre : offres) { 
                String statut = offre.getStatut();
                String statusClass = "";
                String statusLabel = "";
                
                // Mapper les statuts de la base de données
                if ("EN_ATTENTE".equals(statut)) {
                    statusClass = "status-en-attente";
                    statusLabel = "En Attente";
                } else if ("VALIDEE".equals(statut)) {
                    statusClass = "status-validee";
                    statusLabel = "Validée";
                } else if ("TERMINEE".equals(statut)) {
                    statusClass = "status-terminee";
                    statusLabel = "Terminée";
                } else if ("ANNULEE".equals(statut)) {
                    statusClass = "status-annulee";
                    statusLabel = "Annulée";
                }
                
                Double revenu = offre.calculerRevenuTotal();
            %>
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
                        <span class="status-badge <%= statusClass %>"><%= statusLabel %></span>
                    </div>
                    
                    <div class="offre-details">
                        <div class="detail-item">
                            <span class="detail-label">Places</span>
                            <span class="detail-value"><%= offre.getPlacesDisponibles() %> / <%= offre.getPlacesTotales() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Prix/Place</span>
                            <span class="detail-value price-highlight"><%= String.format("%.0f", offre.getPrixParPlace()) %> DH</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Revenus</span>
                            <span class="detail-value price-highlight"><%= String.format("%.0f", revenu) %> DH</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Publiée le</span>
                            <span class="detail-value"><%= dateFormat.format(offre.getDatePublication()) %></span>
                        </div>
                    </div>
                    
                    <% if (offre.getCommentaire() != null && !offre.getCommentaire().trim().isEmpty()) { %>
                        <div class="commentaire-box">
                            💬 <%= offre.getCommentaire() %>
                        </div>
                    <% } %>
                    
                    <div class="offre-actions">
                        <% if ("VALIDEE".equals(statut)) { %>
                            <form method="POST" action="Conducteur" style="display: inline;">
                                <input type="hidden" name="action" value="marquerEffectuee">
                                <input type="hidden" name="offreId" value="<%= offre.getIdOffre() %>">
                                <button type="submit" class="btn btn-complete" onclick="return confirm('Marquer cette offre comme effectuée ?')">
                                    ✅ Marquer effectuée
                                </button>
                            </form>
                            <button class="btn btn-cancel" onclick="cancelOffre(<%= offre.getIdOffre() %>)">
                                ❌ Annuler
                            </button>
                        <% } else if ("EN_ATTENTE".equals(statut)) { %>
                            <span style="color: #856404; font-size: 14px;">⏳ En attente de validation par l'administrateur</span>
                        <% } %>
                    </div>
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
            <button class="close-modal" onclick="closeModal()">&times;</button>
        </div>
        <div class="modal-body">
            <p>Êtes-vous sûr de vouloir annuler cette offre ? Cette action est irréversible.</p>
        </div>
        <div class="modal-actions">
            <button class="btn btn-primary" onclick="closeModal()">Retour</button>
            <form method="POST" action="Conducteur" style="display: inline;">
                <input type="hidden" name="action" value="annulerOffre">
                <input type="hidden" name="offreId" id="cancelOffreId">
                <button type="submit" class="btn btn-cancel">Confirmer l'annulation</button>
            </form>
        </div>
    </div>
</div>

<script>
    function cancelOffre(id) {
        document.getElementById('cancelOffreId').value = id;
        document.getElementById('cancelModal').classList.add('active');
    }
    
    function closeModal() {
        document.getElementById('cancelModal').classList.remove('active');
    }
    
    window.onclick = function(event) {
        const modal = document.getElementById('cancelModal');
        if (event.target == modal) {
            closeModal();
        }
    }
</script>