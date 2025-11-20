<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Offre" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    Integer totalUtilisateurs = (Integer) request.getAttribute("totalUtilisateurs");
    Integer totalConducteurs = (Integer) request.getAttribute("totalConducteurs");
    Integer totalPassagers = (Integer) request.getAttribute("totalPassagers");
    Integer totalOffres = (Integer) request.getAttribute("totalOffres");
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    Integer offresEnAttenteCount = (Integer) request.getAttribute("offresEnAttenteCount");
    Integer offresActives = (Integer) request.getAttribute("offresActives");
    Integer offresTerminees = (Integer) request.getAttribute("offresTerminees");
    Integer offresAnnulees = (Integer) request.getAttribute("offresAnnulees");
    Double revenuTotal = (Double) request.getAttribute("revenuTotal");
    List<Offre> dernieresOffres = (List<Offre>) request.getAttribute("dernieresOffres");
    
    if (totalUtilisateurs == null) totalUtilisateurs = 0;
    if (totalConducteurs == null) totalConducteurs = 0;
    if (totalPassagers == null) totalPassagers = 0;
    if (totalOffres == null) totalOffres = 0;
    if (totalReservations == null) totalReservations = 0;
    if (offresEnAttenteCount == null) offresEnAttenteCount = 0;
    if (offresActives == null) offresActives = 0;
    if (offresTerminees == null) offresTerminees = 0;
    if (offresAnnulees == null) offresAnnulees = 0;
    if (revenuTotal == null) revenuTotal = 0.0;
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<style>
    .dashboard-container {
        padding: 0;
    }
    
    /* Header Styling */
    .top-bar {
        background: white;
        padding: 32px 40px;
        border-radius: 16px;
        margin-bottom: 32px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        border: 1px solid #e8edf2;
        transition: all 0.3s ease;
    }
    
    .top-bar:hover {
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    
    .top-bar h1 {
        font-size: 2rem;
        font-weight: 700;
        color: #1a202c;
        margin-bottom: 6px;
        letter-spacing: -0.5px;
    }
    
    .breadcrumb {
        color: #64748b;
        font-size: 0.95rem;
        font-weight: 500;
    }
    
    /* Stats Grid - Style uniforme */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
        gap: 20px;
        margin-bottom: 32px;
    }
    
    .stat-card {
        background: white;
        padding: 28px;
        border-radius: 14px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        border: 1px solid #e8edf2;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
    }
    
    .stat-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 3px;
        background: linear-gradient(90deg, #667eea, #764ba2);
        opacity: 0;
        transition: opacity 0.3s ease;
    }
    
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        border-color: #667eea40;
    }
    
    .stat-card:hover::before {
        opacity: 1;
    }
    
    .stat-card-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 18px;
    }
    
    .stat-card h3 {
        font-size: 13px;
        font-weight: 600;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.8px;
        margin: 0;
    }
    
    .stat-icon {
        width: 46px;
        height: 46px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        background: linear-gradient(135deg, #f0f4ff, #e8eeff);
        transition: all 0.3s ease;
    }
    
    .stat-card:hover .stat-icon {
        background: linear-gradient(135deg, #667eea15, #764ba215);
        transform: scale(1.1) rotate(5deg);
    }
    
    .stat-card .value {
        font-size: 2.5rem;
        font-weight: 800;
        color: #1a202c;
        line-height: 1;
        margin-bottom: 10px;
        letter-spacing: -1px;
    }
    
    .stat-card .label {
        font-size: 14px;
        color: #64748b;
        font-weight: 500;
        line-height: 1.5;
    }
    
    /* Content Section - Style uniforme */
    .content-section {
        background: white;
        border-radius: 14px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        border: 1px solid #e8edf2;
        margin-bottom: 32px;
        overflow: hidden;
        transition: all 0.3s ease;
    }
    
    .content-section:hover {
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    
    .section-header {
        padding: 24px 32px;
        border-bottom: 1px solid #e8edf2;
        background: linear-gradient(to bottom, #fafbff, #ffffff);
    }
    
    .section-header h2 {
        font-size: 1.4rem;
        font-weight: 700;
        color: #1a202c;
        margin: 0;
        letter-spacing: -0.3px;
    }
    
    /* Activity List - Style professionnel */
    .activity-list {
        padding: 0;
    }
    
    .activity-item {
        display: flex;
        align-items: center;
        padding: 22px 32px;
        border-bottom: 1px solid #f1f5f9;
        transition: all 0.25s ease;
        background: white;
        position: relative;
    }
    
    .activity-item::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 3px;
        background: linear-gradient(180deg, #667eea, #764ba2);
        opacity: 0;
        transition: opacity 0.25s ease;
    }
    
    .activity-item:last-child {
        border-bottom: none;
    }
    
    .activity-item:hover {
        background: #fafbff;
        padding-left: 36px;
    }
    
    .activity-item:hover::before {
        opacity: 1;
    }
    
    .activity-icon {
        width: 50px;
        height: 50px;
        background: linear-gradient(135deg, #667eea, #764ba2);
        border-radius: 13px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        margin-right: 18px;
        color: white;
        box-shadow: 0 6px 18px rgba(102, 126, 234, 0.35);
        flex-shrink: 0;
        transition: all 0.3s ease;
    }
    
    .activity-item:hover .activity-icon {
        transform: scale(1.08) rotate(5deg);
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.45);
    }
    
    .activity-details {
        flex: 1;
        min-width: 0;
    }
    
    .activity-details h4 {
        font-size: 16px;
        font-weight: 600;
        color: #1a202c;
        margin-bottom: 6px;
        letter-spacing: -0.2px;
    }
    
    .activity-details p {
        font-size: 13px;
        color: #64748b;
        margin: 0;
        line-height: 1.6;
    }
    
    .activity-status {
        padding: 7px 16px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.7px;
        white-space: nowrap;
        flex-shrink: 0;
        transition: all 0.3s ease;
    }
    
    .status-active {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
        box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
    }
    
    .status-active:hover {
        box-shadow: 0 6px 18px rgba(16, 185, 129, 0.4);
        transform: translateY(-2px);
    }
    
    .status-completed {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
    }
    
    .status-completed:hover {
        box-shadow: 0 6px 18px rgba(59, 130, 246, 0.4);
        transform: translateY(-2px);
    }
    
    .status-cancelled {
        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: white;
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
    }
    
    .status-cancelled:hover {
        box-shadow: 0 6px 18px rgba(239, 68, 68, 0.4);
        transform: translateY(-2px);
    }
    
    .status-pending {
        background: linear-gradient(135deg, #f59e0b, #d97706);
        color: white;
        box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
    }
    
    .status-pending:hover {
        box-shadow: 0 6px 18px rgba(245, 158, 11, 0.4);
        transform: translateY(-2px);
    }
    
    /* Quick Actions - Style uniforme */
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 18px;
        margin-top: 32px;
    }
    
    .quick-action-btn {
        padding: 28px 24px;
        background: white;
        border-radius: 14px;
        text-align: center;
        text-decoration: none;
        color: #1a202c;
        box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        border: 1px solid #e8edf2;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
    }
    
    .quick-action-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 3px;
        background: linear-gradient(90deg, #667eea, #764ba2);
        opacity: 0;
        transition: opacity 0.3s ease;
    }
    
    .quick-action-btn:hover {
        transform: translateY(-6px);
        box-shadow: 0 12px 35px rgba(0,0,0,0.15);
        color: #1a202c;
        border-color: #667eea40;
    }
    
    .quick-action-btn:hover::before {
        opacity: 1;
    }
    
    .quick-action-btn .icon {
        font-size: 34px;
        margin-bottom: 14px;
        display: block;
        transition: all 0.3s ease;
    }
    
    .quick-action-btn:hover .icon {
        transform: scale(1.15) rotate(5deg);
    }
    
    .quick-action-btn .title {
        font-weight: 600;
        font-size: 15px;
        color: #1a202c;
        letter-spacing: -0.2px;
    }
    
    /* Empty State - Style élégant */
    .empty-state {
        text-align: center;
        padding: 70px 40px;
        color: #64748b;
    }
    
    .empty-state-icon {
        font-size: 4.5rem;
        margin-bottom: 22px;
        opacity: 0.4;
        filter: grayscale(0.3);
    }
    
    .empty-state h3 {
        font-size: 1.4rem;
        margin-bottom: 10px;
        color: #475569;
        font-weight: 600;
    }
    
    .empty-state p {
        color: #94a3b8;
        font-size: 15px;
    }
    
    /* Responsive Design */
    @media (max-width: 1024px) {
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        
        .quick-actions {
            grid-template-columns: repeat(2, 1fr);
        }
    }
    
    @media (max-width: 768px) {
        .stats-grid {
            grid-template-columns: 1fr;
        }
        
        .quick-actions {
            grid-template-columns: 1fr;
        }
        
        .activity-item {
            flex-direction: column;
            align-items: flex-start;
            gap: 14px;
            padding: 20px 24px;
        }
        
        .activity-status {
            align-self: flex-start;
        }
        
        .section-header {
            padding: 20px 24px;
        }
        
        .top-bar {
            padding: 24px 28px;
        }
        
        .top-bar h1 {
            font-size: 1.6rem;
        }
        
        .stat-card .value {
            font-size: 2.2rem;
        }
    }
    
    /* Animations au chargement */
    @keyframes slideInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .stat-card, .content-section, .quick-action-btn {
        animation: slideInUp 0.5s ease-out backwards;
    }
    
    .stat-card:nth-child(1) { animation-delay: 0.05s; }
    .stat-card:nth-child(2) { animation-delay: 0.1s; }
    .stat-card:nth-child(3) { animation-delay: 0.15s; }
    .stat-card:nth-child(4) { animation-delay: 0.2s; }
    .stat-card:nth-child(5) { animation-delay: 0.25s; }
    .stat-card:nth-child(6) { animation-delay: 0.3s; }
    
    .content-section { animation-delay: 0.35s; }
    
    .quick-action-btn:nth-child(1) { animation-delay: 0.4s; }
    .quick-action-btn:nth-child(2) { animation-delay: 0.45s; }
    .quick-action-btn:nth-child(3) { animation-delay: 0.5s; }
    .quick-action-btn:nth-child(4) { animation-delay: 0.55s; }
</style>

<div class="dashboard-container">
    <!-- Header -->
    <div class="top-bar">
        <div>
            <h1>📊 Tableau de Bord Administrateur</h1>
            <div class="breadcrumb">Accueil / Dashboard</div>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-card-header">
                <h3>Utilisateurs Total</h3>
                <div class="stat-icon">👥</div>
            </div>
            <div class="value"><%= totalUtilisateurs %></div>
            <div class="label"><%= totalConducteurs %> Conducteurs • <%= totalPassagers %> Passagers</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-card-header">
                <h3>Offres Publiées</h3>
                <div class="stat-icon">🚗</div>
            </div>
            <div class="value"><%= totalOffres %></div>
            <div class="label"><%= offresActives %> Actives • <%= offresTerminees %> Terminées</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-card-header">
                <h3>En Attente</h3>
                <div class="stat-icon">⏳</div>
            </div>
            <div class="value"><%= offresEnAttenteCount %></div>
            <div class="label">Offres à valider</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-card-header">
                <h3>Réservations</h3>
                <div class="stat-icon">📋</div>
            </div>
            <div class="value"><%= totalReservations %></div>
            <div class="label">Total réservations</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-card-header">
                <h3>Revenus Générés</h3>
                <div class="stat-icon">💰</div>
            </div>
            <div class="value"><%= String.format("%.0f", revenuTotal) %> DH</div>
            <div class="label">Total transactions</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-card-header">
                <h3>Offres Annulées</h3>
                <div class="stat-icon">❌</div>
            </div>
            <div class="value"><%= offresAnnulees %></div>
            <div class="label">Annulations totales</div>
        </div>
    </div>

    <!-- Recent Activity -->
    <div class="content-section">
        <div class="section-header">
            <h2>🕒 Activité Récente</h2>
        </div>
        
        <div class="activity-list">
            <% if (dernieresOffres == null || dernieresOffres.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-state-icon">📊</div>
                    <h3>Aucune activité récente</h3>
                    <p>Les nouvelles offres apparaîtront ici</p>
                </div>
            <% } else { %>
                <% for (Offre offre : dernieresOffres) { 
                    String statut = offre.getStatut();
                    String statusClass = "";
                    String statusLabel = "";
                    
                    if ("EN_ATTENTE".equals(statut)) {
                        statusClass = "status-pending";
                        statusLabel = "En Attente";
                    } else if ("TERMINEE".equals(statut)) {
                        statusClass = "status-completed";
                        statusLabel = "Terminée";
                    } else if ("ANNULEE".equals(statut)) {
                        statusClass = "status-cancelled";
                        statusLabel = "Annulée";
                    } else {
                        statusClass = "status-active";
                        statusLabel = "Active";
                    }
                %>
                    <div class="activity-item">
                        <div class="activity-icon">🚗</div>
                        <div class="activity-details">
                            <h4><%= offre.getVilleDepart() %> → <%= offre.getVilleArrivee() %></h4>
                            <p>
                                📅 <%= dateFormat.format(offre.getDateDepart()) %> à <%= timeFormat.format(offre.getHeureDepart()) %>
                                | 💺 <%= offre.getPlacesDisponibles() %>/<%= offre.getPlacesTotales() %> places
                                | 💰 <%= String.format("%.0f", offre.getPrixParPlace()) %> DH
                            </p>
                        </div>
                        <span class="activity-status <%= statusClass %>"><%= statusLabel %></span>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <a href="Admin?page=utilisateurs" class="quick-action-btn">
            <div class="icon">👥</div>
            <div class="title">Gérer Utilisateurs</div>
        </a>
        <a href="Admin?page=validation" class="quick-action-btn">
            <div class="icon">✅</div>
            <div class="title">Valider Offres</div>
        </a>
        <a href="Admin?page=rapports" class="quick-action-btn">
            <div class="icon">📈</div>
            <div class="title">Voir Rapports</div>
        </a>
    </div>
</div>