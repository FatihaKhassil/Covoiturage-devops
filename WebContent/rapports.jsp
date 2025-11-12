<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer totalOffres = (Integer) request.getAttribute("totalOffres");
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    
    if (totalOffres == null) totalOffres = 0;
    if (totalReservations == null) totalReservations = 0;
%>

<style>
    .rapports-container {
        display: grid;
        gap: 25px;
    }
    
    .rapport-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .section-title {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .section-title h3 {
        font-size: 20px;
        color: #2c3e50;
    }
    
    .section-icon {
        font-size: 28px;
    }
    
    .form-rapports {
        display: grid;
        gap: 20px;
    }
    
    .form-row {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
    }
    
    .form-group {
        display: flex;
        flex-direction: column;
    }
    
    .form-group label {
        font-size: 14px;
        font-weight: 600;
        color: #495057;
        margin-bottom: 8px;
    }
    
    .form-group select,
    .form-group input {
        padding: 12px 15px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 15px;
        transition: all 0.3s;
    }
    
    .form-group select:focus,
    .form-group input:focus {
        outline: none;
        border-color: #e74c3c;
        box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
    }
    
    .btn-generate {
        padding: 15px 30px;
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }
    
    .btn-generate:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(231, 76, 60, 0.4);
    }
    
    .stats-rapports {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
    }
    
    .stat-rapport {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
        text-align: center;
    }
    
    .stat-rapport .number {
        font-size: 36px;
        font-weight: bold;
        color: #e74c3c;
        margin-bottom: 8px;
    }
    
    .stat-rapport .label {
        font-size: 14px;
        color: #6c757d;
    }
    
    .info-box {
        background: #e7f3ff;
        border-left: 4px solid #0066cc;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    
    .info-box p {
        color: #495057;
        font-size: 14px;
        line-height: 1.6;
        margin: 0;
    }
    
    .charts-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
        margin-top: 25px;
    }
    
    .chart-box {
        background: #f8f9fa;
        padding: 25px;
        border-radius: 10px;
        text-align: center;
    }
    
    .chart-box h4 {
        font-size: 16px;
        color: #2c3e50;
        margin-bottom: 15px;
    }
    
    .chart-placeholder {
        height: 200px;
        background: white;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #6c757d;
        font-size: 14px;
    }
    
    .rapport-types {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-bottom: 20px;
    }
    
    .rapport-type-card {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
        border: 2px solid transparent;
    }
    
    .rapport-type-card:hover {
        background: white;
        border-color: #e74c3c;
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    
    .rapport-type-card.selected {
        background: white;
        border-color: #e74c3c;
    }
    
    .rapport-type-card .icon {
        font-size: 48px;
        margin-bottom: 10px;
    }
    
    .rapport-type-card .title {
        font-size: 14px;
        font-weight: 600;
        color: #2c3e50;
    }
</style>

<div class="top-bar">
    <div>
        <h1>Rapports & Statistiques</h1>
        <div class="breadcrumb">Accueil / Rapports</div>
    </div>
</div>

<!-- Statistiques Globales -->
<div class="rapport-section">
    <div class="section-title">
        <span class="section-icon">📊</span>
        <h3>Statistiques Globales</h3>
    </div>
    
    <div class="stats-rapports">
        <div class="stat-rapport">
            <div class="number"><%= totalOffres %></div>
            <div class="label">Offres Totales</div>
        </div>
        <div class="stat-rapport">
            <div class="number"><%= totalReservations %></div>
            <div class="label">Réservations</div>
        </div>
        <div class="stat-rapport">
            <div class="number"><%= totalOffres > 0 ? String.format("%.0f%%", (totalReservations * 100.0 / totalOffres)) : "0%" %></div>
            <div class="label">Taux de Réservation</div>
        </div>
        <div class="stat-rapport">
            <div class="number">4.5</div>
            <div class="label">Note Moyenne</div>
        </div>
    </div>
</div>

<!-- Générateur de Rapports -->
<div class="rapport-section">
    <div class="section-title">
        <span class="section-icon">📈</span>
        <h3>Générateur de Rapports</h3>
    </div>
    
    <div class="info-box">
        <p>💡 Générez des rapports détaillés sur l'activité de la plateforme. Sélectionnez le type de rapport et la période souhaitée.</p>
    </div>
    
    <form method="POST" action="Admin" class="form-rapports">
        <input type="hidden" name="action" value="genererRapport">
        
        <div class="form-group">
            <label>Type de Rapport</label>
            <div class="rapport-types">
                <label class="rapport-type-card" onclick="selectRapportType(this, 'utilisateurs')">
                    <input type="radio" name="typeRapport" value="utilisateurs" style="display: none;">
                    <div class="icon">👥</div>
                    <div class="title">Utilisateurs</div>
                </label>
                <label class="rapport-type-card" onclick="selectRapportType(this, 'offres')">
                    <input type="radio" name="typeRapport" value="offres" style="display: none;">
                    <div class="icon">🚗</div>
                    <div class="title">Offres</div>
                </label>
                <label class="rapport-type-card" onclick="selectRapportType(this, 'reservations')">
                    <input type="radio" name="typeRapport" value="reservations" style="display: none;">
                    <div class="icon">📋</div>
                    <div class="title">Réservations</div>
                </label>
                <label class="rapport-type-card" onclick="selectRapportType(this, 'financier')">
                    <input type="radio" name="typeRapport" value="financier" style="display: none;">
                    <div class="icon">💰</div>
                    <div class="title">Financier</div>
                </label>
            </div>
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label>Période</label>
                <select name="periode" required>
                    <option value="">Sélectionner une période</option>
                    <option value="aujourd'hui">Aujourd'hui</option>
                    <option value="7jours">7 derniers jours</option>
                    <option value="30jours">30 derniers jours</option>
                    <option value="mois">Ce mois</option>
                    <option value="trimestre">Ce trimestre</option>
                    <option value="annee">Cette année</option>
                    <option value="personnalise">Période personnalisée</option>
                </select>
            </div>
            
            <div class="form-group" id="dateDebut" style="display: none;">
                <label>Date de Début</label>
                <input type="date" name="dateDebut">
            </div>
            
            <div class="form-group" id="dateFin" style="display: none;">
                <label>Date de Fin</label>
                <input type="date" name="dateFin">
            </div>
        </div>
        
        <div class="form-group">
            <label>Format d'Export</label>
            <select name="format">
                <option value="pdf">PDF</option>
                <option value="excel">Excel (.xlsx)</option>
                <option value="csv">CSV</option>
            </select>
        </div>
        
        <button type="submit" class="btn-generate">
            📊 Générer le Rapport
        </button>
    </form>
</div>

<!-- Visualisations -->
<div class="rapport-section">
    <div class="section-title">
        <span class="section-icon">📉</span>
        <h3>Visualisations & Tendances</h3>
    </div>
    
    <div class="charts-container">
        <div class="chart-box">
            <h4>Évolution des Inscriptions</h4>
            <div class="chart-placeholder">📈 Graphique à venir</div>
        </div>
        <div class="chart-box">
            <h4>Répartition par Ville</h4>
            <div class="chart-placeholder">🗺️ Carte à venir</div>
        </div>
        <div class="chart-box">
            <h4>Taux de Réservation</h4>
            <div class="chart-placeholder">📊 Statistiques à venir</div>
        </div>
        <div class="chart-box">
            <h4>Revenus Mensuels</h4>
            <div class="chart-placeholder">💰 Graphique à venir</div>
        </div>
    </div>
</div>

<!-- Rapports Rapides -->
<div class="rapport-section">
    <div class="section-title">
        <span class="section-icon">⚡</span>
        <h3>Rapports Rapides</h3>
    </div>
    
    <div class="info-box">
        <p>🎯 Accédez rapidement aux rapports les plus demandés avec des paramètres prédéfinis.</p>
    </div>
    
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
        <form method="POST" action="Admin" style="display: contents;">
            <input type="hidden" name="action" value="genererRapport">
            <input type="hidden" name="typeRapport" value="utilisateurs">
            <input type="hidden" name="periode" value="mois">
            <button type="submit" style="padding: 15px; background: #e7f3ff; border: 2px solid #0066cc; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s;">
                👥 Nouveaux Utilisateurs du Mois
            </button>
        </form>
        
        <form method="POST" action="Admin" style="display: contents;">
            <input type="hidden" name="action" value="genererRapport">
            <input type="hidden" name="typeRapport" value="offres">
            <input type="hidden" name="periode" value="7jours">
            <button type="submit" style="padding: 15px; background: #e8f5e9; border: 2px solid #4caf50; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s;">
                🚗 Offres de la Semaine
            </button>
        </form>
        
        <form method="POST" action="Admin" style="display: contents;">
            <input type="hidden" name="action" value="genererRapport">
            <input type="hidden" name="typeRapport" value="financier">
            <input type="hidden" name="periode" value="trimestre">
            <button type="submit" style="padding: 15px; background: #fff3e0; border: 2px solid #ff9800; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s;">
                💰 Rapport Financier Trimestriel
            </button>
        </form>
        
        <form method="POST" action="Admin" style="display: contents;">
            <input type="hidden" name="action" value="genererRapport">
            <input type="hidden" name="typeRapport" value="reservations">
            <input type="hidden" name="periode" value="mois">
            <button type="submit" style="padding: 15px; background: #f3e5f5; border: 2px solid #9c27b0; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s;">
                📋 Réservations Mensuelles
            </button>
        </form>
    </div>
</div>

<script>
    // Gestion de la sélection du type de rapport
    function selectRapportType(element, type) {
        // Désélectionner tous
        document.querySelectorAll('.rapport-type-card').forEach(card => {
            card.classList.remove('selected');
        });
        
        // Sélectionner celui-ci
        element.classList.add('selected');
        element.querySelector('input[type="radio"]').checked = true;
    }
    
    // Afficher les champs de date personnalisée
    document.querySelector('select[name="periode"]').addEventListener('change', function() {
        const dateDebut = document.getElementById('dateDebut');
        const dateFin = document.getElementById('dateFin');
        
        if (this.value === 'personnalise') {
            dateDebut.style.display = 'block';
            dateFin.style.display = 'block';
            dateDebut.querySelector('input').required = true;
            dateFin.querySelector('input').required = true;
        } else {
            dateDebut.style.display = 'none';
            dateFin.style.display = 'none';
            dateDebut.querySelector('input').required = false;
            dateFin.querySelector('input').required = false;
        }
    });
    
    // Validation du formulaire
    document.querySelector('.form-rapports').addEventListener('submit', function(e) {
        const typeRapport = document.querySelector('input[name="typeRapport"]:checked');
        
        if (!typeRapport) {
            e.preventDefault();
            alert('Veuillez sélectionner un type de rapport');
            return false;
        }
    });
</script>