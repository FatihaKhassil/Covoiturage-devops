<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Reservation, models.Offre, models.Evaluation, java.util.List, java.text.SimpleDateFormat" %>
<%
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    Integer nbTerminees = (Integer) request.getAttribute("nbTerminees");
    Integer nbAnnulees = (Integer) request.getAttribute("nbAnnulees");
    Integer totalHistorique = (Integer) request.getAttribute("totalHistorique");
    
    if (reservations == null) reservations = new java.util.ArrayList<>();
    if (nbTerminees == null) nbTerminees = 0;
    if (nbAnnulees == null) nbAnnulees = 0;
    if (totalHistorique == null) totalHistorique = 0;
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    SimpleDateFormat dateLongFormat = new SimpleDateFormat("dd MMMM yyyy");
%>
<%-- Section des messages d'alerte --%>
<div style="margin-bottom: 20px;">
    <%-- Message de succès --%>
    <% if (session.getAttribute("success") != null) { %>
        <div style="background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%); 
                    border: 1px solid #c3e6cb; 
                    color: #155724; 
                    padding: 15px 20px; 
                    border-radius: 8px; 
                    margin-bottom: 15px;
                    display: flex;
                    align-items: center;
                    gap: 10px;">
            <i class="fas fa-check-circle" style="color: #28a745; font-size: 18px;"></i>
            <div>
                <strong>Succès !</strong> <%= session.getAttribute("success") %>
            </div>
        </div>
        <% session.removeAttribute("success"); %>
    <% } %>
    
    <%-- Message d'erreur --%>
    <% if (session.getAttribute("error") != null) { %>
        <div style="background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%); 
                    border: 1px solid #f5c6cb; 
                    color: #721c24; 
                    padding: 15px 20px; 
                    border-radius: 8px; 
                    margin-bottom: 15px;
                    display: flex;
                    align-items: center;
                    gap: 10px;">
            <i class="fas fa-exclamation-triangle" style="color: #dc3545; font-size: 18px;"></i>
            <div>
                <strong>Information</strong> <%= session.getAttribute("error") %>
            </div>
        </div>
        <% session.removeAttribute("error"); %>
    <% } %>
</div>

<style>
.historique-container {
    max-width: 100%;
}

.stats-historique {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.stat-historique {
    background: white;
    padding: 25px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    border-left: 4px solid;
}

.stat-historique.terminees {
    border-left-color: #10b981;
    background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
}

.stat-historique.annulees {
    border-left-color: #ef4444;
    background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
}

.stat-historique .number {
    font-size: 32px;
    font-weight: bold;
    margin-bottom: 8px;
}

.stat-historique.terminees .number {
    color: #10b981;
}

.stat-historique.annulees .number {
    color: #ef4444;
}

.stat-historique .label {
    font-size: 14px;
    color: #6b7280;
    font-weight: 500;
}

.reservation-card {
    background: white;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    border: 1px solid #e5e7eb;
    transition: all 0.3s ease;
}

.reservation-card:hover {
    box-shadow: 0 4px 20px rgba(0,0,0,0.12);
    transform: translateY(-2px);
}

.reservation-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 2px solid #f3f4f6;
}

.reservation-info {
    flex: 1;
}

.reservation-title {
    font-size: 18px;
    font-weight: 600;
    color: #1f2937;
    margin-bottom: 8px;
}

.reservation-route {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 16px;
    font-weight: 500;
    color: #374151;
    margin-bottom: 5px;
}

.reservation-date {
    font-size: 14px;
    color: #6b7280;
}

.reservation-status {
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
}

.status-terminee {
    background: #d1fae5;
    color: #065f46;
}

.status-annulee {
    background: #fee2e2;
    color: #991b1b;
}

.reservation-details {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 20px;
}

.detail-item {
    display: flex;
    flex-direction: column;
}

.detail-label {
    font-size: 12px;
    color: #6b7280;
    font-weight: 500;
    margin-bottom: 4px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.detail-value {
    font-size: 16px;
    font-weight: 600;
    color: #1f2937;
}

.conducteur-info {
    background: #f8fafc;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 20px;
    border-left: 4px solid #667eea;
}

.conducteur-name {
    font-size: 16px;
    font-weight: 600;
    color: #1f2937;
    margin-bottom: 5px;
}

.conducteur-contact {
    font-size: 14px;
    color: #6b7280;
    margin-bottom: 5px;
}

.conducteur-rating {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    color: #6b7280;
}

.conducteur-vehicule {
    font-size: 13px;
    color: #6b7280;
    margin-top: 5px;
    font-style: italic;
}

.evaluation-section {
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #e5e7eb;
}

.btn-evaluer {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    color: white;
    border: none;
    padding: 12px 24px;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.btn-evaluer:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(245, 158, 11, 0.4);
}

.empty-history {
    text-align: center;
    padding: 60px 20px;
    color: #6b7280;
}

.empty-icon {
    font-size: 64px;
    margin-bottom: 20px;
    opacity: 0.5;
}

/* Styles pour l'évaluation déjà faite */
.evaluation-faite {
    background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
    border: 1px solid #ff9800;
    padding: 20px;
    border-radius: 10px;
    margin-top: 15px;
}

.evaluation-header-faite {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}

.evaluation-titre {
    font-size: 16px;
    font-weight: 600;
    color: #e65100;
    display: flex;
    align-items: center;
    gap: 8px;
}

.evaluation-date-faite {
    font-size: 12px;
    color: #f57c00;
    font-weight: 500;
}

.rating-display {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 10px;
}

.stars-display {
    color: #f59e0b;
    font-size: 20px;
}

.rating-value {
    font-size: 16px;
    font-weight: 600;
    color: #1f2937;
}

.commentaire-display {
    background: white;
    padding: 15px;
    border-radius: 8px;
    border-left: 3px solid #ff9800;
    font-style: italic;
    color: #374151;
    line-height: 1.5;
}

.badge-deja-evalue {
    background: #ff9800;
    color: white;
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.btn-deja-evalue {
    background: #6b7280;
    color: white;
    border: none;
    padding: 12px 24px;
    border-radius: 8px;
    font-weight: 600;
    cursor: not-allowed;
    opacity: 0.7;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

/* Styles pour les évaluations que vous avez données */
.evaluation-votre-avis {
    background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
    border: 1px solid #2196f3;
    padding: 20px;
    border-radius: 10px;
    margin-top: 15px;
}

.badge-votre-avis {
    background: #2196f3;
    color: white;
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.votre-avis-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}

.votre-avis-titre {
    font-size: 16px;
    font-weight: 600;
    color: #1565c0;
    display: flex;
    align-items: center;
    gap: 8px;
}

.votre-avis-date {
    font-size: 12px;
    color: #1976d2;
    font-weight: 500;
}

/* Modal styles */
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

.btn-complete {
    background: #28a745;
    color: white;
}

.btn-complete:hover {
    background: #218838;
}
</style>

<div class="historique-container">
    <div class="stats-historique">
        <div class="stat-historique terminees">
            <div class="number"><%= nbTerminees %></div>
            <div class="label">Trajets Terminés</div>
        </div>
        <div class="stat-historique annulees">
            <div class="number"><%= nbAnnulees %></div>
            <div class="label">Trajets Annulés</div>
        </div>
    </div>

    <% if (reservations.isEmpty()) { %>
        <div class="empty-history">
            <div class="empty-icon">📜</div>
            <h3>Aucun trajet dans l'historique</h3>
            <p>Vos trajets terminés et annulés apparaîtront ici</p>
        </div>
    <% } else { %>
        <% for (Reservation reservation : reservations) { 
            Offre offre = reservation.getOffre();
            Boolean dejaEvalue = reservation.getEstEvalue() != null ? reservation.getEstEvalue() : false;
            Evaluation evaluationExistante = reservation.getEvaluation();
        %>
            <div class="reservation-card">
                <div class="reservation-header">
                    <div class="reservation-info">
                        <div class="reservation-title">
                            Trajet <%= offre.getVilleDepart() %> → <%= offre.getVilleArrivee() %>
                        </div>
                        <div class="reservation-route">
                            <span>📍 <%= offre.getVilleDepart() %></span>
                            <span style="color: #667eea;">→</span>
                            <span>📍 <%= offre.getVilleArrivee() %></span>
                        </div>
                        <div class="reservation-date">
                            Réservé le <%= dateFormat.format(reservation.getDateReservation()) %>
                        </div>
                    </div>
                    <div class="reservation-status <%= "TERMINEE".equals(reservation.getStatut()) ? "status-terminee" : "status-annulee" %>">
                        <%= "TERMINEE".equals(reservation.getStatut()) ? "Terminé" : "Annulé" %>
                    </div>
                </div>

                <div class="reservation-details">
                    <div class="detail-item">
                        <span class="detail-label">Date du trajet</span>
                        <span class="detail-value"><%= dateLongFormat.format(offre.getDateDepart()) %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Heure de départ</span>
                        <span class="detail-value"><%= timeFormat.format(offre.getHeureDepart()) %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Places réservées</span>
                        <span class="detail-value"><%= reservation.getNombrePlaces() %> place(s)</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Prix total</span>
                        <span class="detail-value"><%= String.format("%.0f", reservation.getPrixTotal()) %> DH</span>
                    </div>
                </div>

                <% if (offre.getConducteur() != null && "TERMINEE".equals(reservation.getStatut())) { %>
                    <div class="conducteur-info">
                        <div class="conducteur-name">
                            🚗 Conducteur : <%= offre.getConducteur().getPrenom() %> <%= offre.getConducteur().getNom() %>
                        </div>
                        <% if (offre.getConducteur().getTelephone() != null && !offre.getConducteur().getTelephone().isEmpty()) { %>
                            <div class="conducteur-contact">
                                📞 <%= offre.getConducteur().getTelephone() %>
                            </div>
                        <% } %>
                        <div class="conducteur-rating">
                            <span>⭐ Note moyenne : <%= String.format("%.1f", offre.getConducteur().getNoteMoyenne()) %>/5</span>
                        </div>
                        <% if (offre.getConducteur().getMarqueVehicule() != null && offre.getConducteur().getModeleVehicule() != null) { %>
                            <div class="conducteur-vehicule">
                                🚙 Véhicule : <%= offre.getConducteur().getMarqueVehicule() %> <%= offre.getConducteur().getModeleVehicule() %>
                                <% if (offre.getConducteur().getImmatriculation() != null) { %>
                                    (<%= offre.getConducteur().getImmatriculation() %>)
                                <% } %>
                            </div>
                        <% } %>
                    </div>

                    <div class="evaluation-section">
                        <% if (dejaEvalue && evaluationExistante != null) { 
                            int note = evaluationExistante.getNote() != null ? evaluationExistante.getNote() : 0;
                        %>
                            <!-- Afficher l'évaluation que vous avez donnée -->
                            <div class="evaluation-votre-avis">
                                <div class="votre-avis-header">
                                    <div class="votre-avis-titre">
                                        <span class="badge-votre-avis">
                                            <i class="fas fa-star"></i>
                                            Votre évaluation
                                        </span>
                                    </div>
                                    <% if (evaluationExistante.getDateEvaluation() != null) { %>
                                        <div class="votre-avis-date">
                                            Donnée le <%= dateFormat.format(evaluationExistante.getDateEvaluation()) %>
                                        </div>
                                    <% } %>
                                </div>
                                
                                <div class="rating-display">
                                    <div class="stars-display">
                                        <% for (int i = 1; i <= 5; i++) { %>
                                            <% if (i <= note) { %>
                                                <span style="color: #f59e0b;">★</span>
                                            <% } else { %>
                                                <span style="color: #d1d5db;">☆</span>
                                            <% } %>
                                        <% } %>
                                    </div>
                                    <div class="rating-value">
                                        Vous avez noté : <%= note %>/5
                                    </div>
                                </div>
                                
                                <% if (evaluationExistante.getCommentaire() != null && !evaluationExistante.getCommentaire().trim().isEmpty()) { %>
                                    <div class="commentaire-display">
                                        "<%= evaluationExistante.getCommentaire() %>"
                                    </div>
                                <% } else { %>
                                    <div style="color: #6b7280; font-style: italic; text-align: center; padding: 10px;">
                                        Aucun commentaire supplémentaire
                                    </div>
                                <% } %>
                            </div>
                        <% } else if (dejaEvalue) { %>
                            <!-- Cas où déjà évalué mais sans détails -->
                            <div class="evaluation-faite">
                                <div class="evaluation-header-faite">
                                    <div class="evaluation-titre">
                                        <span class="badge-deja-evalue">
                                            <i class="fas fa-check-circle"></i>
                                            Déjà évalué
                                        </span>
                                    </div>
                                </div>
                                <div style="text-align: center; color: #6b7280; padding: 20px;">
                                    <i class="fas fa-star" style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
                                    <p>Vous avez déjà évalué ce conducteur</p>
                                </div>
                            </div>
                        <% } else { %>
                            <!-- Bouton pour évaluer -->
                            <button class="btn-evaluer" 
                                    onclick="ouvrirEvaluation(<%= reservation.getIdReservation() %>, <%= offre.getConducteur().getIdUtilisateur() %>)">
                                <i class="fas fa-star"></i>
                                Évaluer le conducteur
                            </button>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
    <% } %>
</div>

<!-- Modal d'évaluation -->
<div id="evaluerModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Évaluer le Conducteur</h3>
            <button class="close-modal" onclick="closeEvaluerModal()">&times;</button>
        </div>
        <form method="POST" action="Passager" id="evaluationForm">
            <input type="hidden" name="action" value="evaluerConducteur">
            <input type="hidden" name="reservationId" id="evalReservationId">
            <input type="hidden" name="idConducteur" id="evalConducteurId">
            
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
                              placeholder="Partagez votre expérience avec ce conducteur..."></textarea>
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

function ouvrirEvaluation(reservationId, conducteurId) {
    document.getElementById('evalReservationId').value = reservationId;
    document.getElementById('evalConducteurId').value = conducteurId;
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
        ratingText.style.color = '#10b981';
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

// Initialisation au chargement de la page
document.addEventListener('DOMContentLoaded', function() {
    console.log('Page historique chargée avec succès');
});
</script>