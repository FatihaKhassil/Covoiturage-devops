<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Conducteur, models.Passager, java.util.List, java.text.SimpleDateFormat" %>
<%
    List<Conducteur> conducteurs = (List<Conducteur>) request.getAttribute("conducteurs");
    List<Passager> passagers = (List<Passager>) request.getAttribute("passagers");
    Integer totalConducteurs = (Integer) request.getAttribute("totalConducteurs");
    Integer totalPassagers = (Integer) request.getAttribute("totalPassagers");
    Long conducteursActifs = (Long) request.getAttribute("conducteursActifs");
    Long passagersActifs = (Long) request.getAttribute("passagersActifs");
    Long conducteursInactifs = (Long) request.getAttribute("conducteursInactifs");
    Long passagersInactifs = (Long) request.getAttribute("passagersInactifs");
    
    if (totalConducteurs == null) totalConducteurs = 0;
    if (totalPassagers == null) totalPassagers = 0;
    if (conducteursActifs == null) conducteursActifs = 0L;
    if (passagersActifs == null) passagersActifs = 0L;
    if (conducteursInactifs == null) conducteursInactifs = 0L;
    if (passagersInactifs == null) passagersInactifs = 0L;
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<style>
    .users-stats {
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
        color: #e74c3c;
        margin-bottom: 5px;
    }
    
    .stat-mini.success .number {
        color: #4caf50;
    }
    
    .stat-mini.warning .number {
        color: #ff9800;
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
        color: #e74c3c;
    }
    
    .tab-button.active::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        right: 0;
        height: 3px;
        background: linear-gradient(90deg, #e74c3c 0%, #c0392b 100%);
    }
    
    .tab-content {
        display: none;
        padding: 25px;
    }
    
    .tab-content.active {
        display: block;
    }
    
    .users-table {
        width: 100%;
        border-collapse: collapse;
    }
    
    .users-table thead {
        background: #f8f9fa;
    }
    
    .users-table th {
        padding: 15px;
        text-align: left;
        font-weight: 600;
        color: #495057;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .users-table td {
        padding: 15px;
        border-bottom: 1px solid #e9ecef;
        vertical-align: middle;
    }
    
    .users-table tbody tr:hover {
        background: #f8f9fa;
    }
    
    .user-info {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .user-avatar {
        width: 45px;
        height: 45px;
        border-radius: 50%;
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: bold;
        font-size: 16px;
    }
    
    .user-details h4 {
        font-size: 15px;
        color: #2c3e50;
        margin-bottom: 3px;
    }
    
    .user-details p {
        font-size: 13px;
        color: #6c757d;
    }
    
    .status-badge {
        padding: 5px 12px;
        border-radius: 15px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
    }
    
    .status-active {
        background: #d4edda;
        color: #155724;
    }
    
    .status-inactive {
        background: #f8d7da;
        color: #721c24;
    }
    
    .rating {
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .rating .stars {
        color: #f39c12;
    }
    
    .rating .score {
        font-weight: 600;
        color: #2c3e50;
    }
    
    .action-buttons {
        display: flex;
        gap: 8px;
    }
    
    .btn-action {
        padding: 8px 15px;
        border-radius: 6px;
        border: none;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-block {
        background: #fff3cd;
        color: #856404;
    }
    
    .btn-block:hover {
        background: #ffc107;
        color: white;
    }
    
    .btn-unblock {
        background: #d4edda;
        color: #155724;
    }
    
    .btn-unblock:hover {
        background: #28a745;
        color: white;
    }
    
    .btn-view {
        background: #e7f3ff;
        color: #0066cc;
    }
    
    .btn-view:hover {
        background: #0066cc;
        color: white;
    }
    
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #6c757d;
    }
    
    .empty-state-icon {
        font-size: 64px;
        margin-bottom: 20px;
        opacity: 0.5;
    }
</style>

<div class="top-bar">
    <div>
        <h1>Gestion des Utilisateurs</h1>
        <div class="breadcrumb">Accueil / Utilisateurs</div>
    </div>
</div>

<!-- Statistiques -->
<div class="users-stats">
    <div class="stat-mini">
        <div class="number"><%= totalConducteurs %></div>
        <div class="label">Conducteurs</div>
    </div>
    <div class="stat-mini success">
        <div class="number"><%= conducteursActifs %></div>
        <div class="label">Conducteurs Actifs</div>
    </div>
    <div class="stat-mini">
        <div class="number"><%= totalPassagers %></div>
        <div class="label">Passagers</div>
    </div>
    <div class="stat-mini success">
        <div class="number"><%= passagersActifs %></div>
        <div class="label">Passagers Actifs</div>
    </div>
    <div class="stat-mini warning">
        <div class="number"><%= conducteursInactifs + passagersInactifs %></div>
        <div class="label">Comptes Bloqués</div>
    </div>
</div>

<!-- Onglets -->
<div class="tabs-container">
    <div class="tabs-header">
        <button class="tab-button active" onclick="showTab('conducteurs')">
            🚗 Conducteurs (<%= totalConducteurs %>)
        </button>
        <button class="tab-button" onclick="showTab('passagers')">
            👤 Passagers (<%= totalPassagers %>)
        </button>
    </div>
    
    <!-- Onglet Conducteurs -->
    <div id="tab-conducteurs" class="tab-content active">
        <% if (conducteurs == null || conducteurs.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-state-icon">🚗</div>
                <h3>Aucun conducteur inscrit</h3>
            </div>
        <% } else { %>
            <table class="users-table">
                <thead>
                    <tr>
                        <th>Conducteur</th>
                        <th>Contact</th>
                        <th>Véhicule</th>
                        <th>Note</th>
                        <th>Inscription</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Conducteur conducteur : conducteurs) { 
                        String initiales = conducteur.getPrenom().substring(0,1) + conducteur.getNom().substring(0,1);
                    %>
                        <tr>
                            <td>
                                <div class="user-info">
                                    <div class="user-avatar"><%= initiales %></div>
                                    <div class="user-details">
                                        <h4><%= conducteur.getPrenom() %> <%= conducteur.getNom() %></h4>
                                        <p>ID: <%= conducteur.getIdUtilisateur() %></p>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <p style="font-size: 14px; color: #2c3e50; margin-bottom: 3px;">
                                    <%= conducteur.getEmail() %>
                                </p>
                                <p style="font-size: 13px; color: #6c757d;">
                                    <%= conducteur.getTelephone() %>
                                </p>
                            </td>
                            <td>
                                <p style="font-size: 14px; color: #2c3e50; margin-bottom: 3px;">
                                    <%= conducteur.getMarqueVehicule() %> <%= conducteur.getModeleVehicule() %>
                                </p>
                                <p style="font-size: 13px; color: #6c757d;">
                                    <%= conducteur.getImmatriculation() %> | <%= conducteur.getNombrePlacesVehicule() %> places
                                </p>
                            </td>
                            <td>
                                <div class="rating">
                                    <span class="stars">⭐</span>
                                    <span class="score"><%= String.format("%.1f", conducteur.getNoteMoyenne()) %>/5</span>
                                </div>
                            </td>
                            <td><%= dateFormat.format(conducteur.getDateInscription()) %></td>
                            <td>
                                <span class="status-badge <%= conducteur.getEstActif() ? "status-active" : "status-inactive" %>">
                                    <%= conducteur.getEstActif() ? "Actif" : "Bloqué" %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <% if (conducteur.getEstActif()) { %>
                                        <form method="POST" action="Admin" style="display: inline;">
                                            <input type="hidden" name="action" value="bloquerUtilisateur">
                                            <input type="hidden" name="userId" value="<%= conducteur.getIdUtilisateur() %>">
                                            <button type="submit" class="btn-action btn-block" 
                                                    onclick="return confirm('Bloquer cet utilisateur ?')">
                                                🚫 Bloquer
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <form method="POST" action="Admin" style="display: inline;">
                                            <input type="hidden" name="action" value="debloquerUtilisateur">
                                            <input type="hidden" name="userId" value="<%= conducteur.getIdUtilisateur() %>">
                                            <button type="submit" class="btn-action btn-unblock">
                                                ✅ Débloquer
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
    
    <!-- Onglet Passagers -->
    <div id="tab-passagers" class="tab-content">
        <% if (passagers == null || passagers.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-state-icon">👤</div>
                <h3>Aucun passager inscrit</h3>
            </div>
        <% } else { %>
            <table class="users-table">
                <thead>
                    <tr>
                        <th>Passager</th>
                        <th>Contact</th>
                        <th>Note</th>
                        <th>Inscription</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Passager passager : passagers) { 
                        String initiales = passager.getPrenom().substring(0,1) + passager.getNom().substring(0,1);
                    %>
                        <tr>
                            <td>
                                <div class="user-info">
                                    <div class="user-avatar"><%= initiales %></div>
                                    <div class="user-details">
                                        <h4><%= passager.getPrenom() %> <%= passager.getNom() %></h4>
                                        <p>ID: <%= passager.getIdUtilisateur() %></p>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <p style="font-size: 14px; color: #2c3e50; margin-bottom: 3px;">
                                    <%= passager.getEmail() %>
                                </p>
                                <p style="font-size: 13px; color: #6c757d;">
                                    <%= passager.getTelephone() %>
                                </p>
                            </td>
                            <td>
                                <div class="rating">
                                    <span class="stars">⭐</span>
                                    <span class="score"><%= String.format("%.1f", passager.getNoteMoyenne()) %>/5</span>
                                </div>
                            </td>
                            <td><%= dateFormat.format(passager.getDateInscription()) %></td>
                            <td>
                                <span class="status-badge <%= passager.getEstActif() ? "status-active" : "status-inactive" %>">
                                    <%= passager.getEstActif() ? "Actif" : "Bloqué" %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <% if (passager.getEstActif()) { %>
                                        <form method="POST" action="Admin" style="display: inline;">
                                            <input type="hidden" name="action" value="bloquerUtilisateur">
                                            <input type="hidden" name="userId" value="<%= passager.getIdUtilisateur() %>">
                                            <button type="submit" class="btn-action btn-block" 
                                                    onclick="return confirm('Bloquer cet utilisateur ?')">
                                                🚫 Bloquer
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <form method="POST" action="Admin" style="display: inline;">
                                            <input type="hidden" name="action" value="debloquerUtilisateur">
                                            <input type="hidden" name="userId" value="<%= passager.getIdUtilisateur() %>">
                                            <button type="submit" class="btn-action btn-unblock">
                                                ✅ Débloquer
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
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
</script>