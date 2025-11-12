<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Reservation, java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="models.Conducteur" %>
<%
    List<Reservation> historiqueReservations = (List<Reservation>) request.getAttribute("historiqueReservations");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<style>
    .historique-grid {
        display: grid;
        gap: 20px;
    }
    
    .historique-card {
        background: white;
        border: 1px solid #e9ecef;
        border-radius: 12px;
        padding: 25px;
        transition: all 0.3s;
        position: relative;
        overflow: hidden;
        border-left: 5px solid #17a2b8;
    }
    
    .historique-card:hover {
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        transform: translateY(-3px);
    }
    
    .historique-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 20px;
    }
    
    .historique-route h3 {
        font-size: 20px;
        color: #2c3e50;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .route-arrow {
        color: #17a2b8;
        font-weight: bold;
    }
    
    .historique-date {
        color: #7f8c8d;
        font-size: 14px;
    }
    
    .historique-badge {
        padding: 6px 15px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        background: #d1ecf1;
        color: #0c5460;
    }
    
    .historique-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 15px;
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
</style>

<div class="top-bar">
    <div>
        <h1>Historique des Trajets</h1>
        <div class="breadcrumb">Accueil / Historique</div>
    </div>
</div>

<div class="content-section">
    <div class="section-header">
        <h2>Trajets Terminés (<%= historiqueReservations != null ? historiqueReservations.size() : 0 %>)</h2>
    </div>
    
    <% if (historiqueReservations == null || historiqueReservations.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-state-icon">📜</div>
            <h3>Aucun trajet terminé</h3>
            <p>Votre historique de trajets apparaîtra ici</p>
        </div>
    <% } else { %>
        <div class="historique-grid">
            <% for (Reservation reservation : historiqueReservations) { %>
                <div class="historique-card">
                    <div class="historique-header">
                        <div class="historique-route">
                            <h3>
                                📍 <%= reservation.getOffre().getVilleDepart() %> <span class="route-arrow">→</span> <%= reservation.getOffre().getVilleArrivee() %>
                            </h3>
                            <div class="historique-date">
                                🗓 <%= dateFormat.format(reservation.getOffre().getDateDepart()) %> à <%= timeFormat.format(reservation.getOffre().getHeureDepart()) %>
                            </div>
                        </div>
                        <span class="historique-badge">✅ Terminé</span>
                    </div>
                    
                    <div class="historique-details">
                        <div class="detail-item">
                            <span class="detail-label">Places</span>
                            <span class="detail-value"><%= reservation.getNombrePlaces() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Prix Total</span>
                            <span class="detail-value price-highlight"><%= String.format("%.0f", reservation.getPrixTotal()) %> DH</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Conducteur</span>
                            <span class="detail-value">
    <% 
        Conducteur cond = reservation.getOffre().getConducteur();
        if (cond != null && cond.getPrenom() != null && cond.getNom() != null) {
            out.print(cond.getPrenom() + " " + cond.getNom().charAt(0) + ".");
        } else {
            out.print("N/A");
        }
    %>
</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Date Réservation</span>
                            <span class="detail-value"><%= dateFormat.format(reservation.getDateReservation()) %></span>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>