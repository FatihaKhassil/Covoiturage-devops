<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Modal d'évaluation du conducteur -->
<div id="evaluerConducteurModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Évaluer le Conducteur</h3>
            <button class="close-modal" onclick="closeEvaluerConducteurModal()">&times;</button>
        </div>
        <form method="POST" action="Passager" id="evaluationConducteurForm">
            <input type="hidden" name="action" value="evaluerConducteur">
            <input type="hidden" name="reservationId" id="evalConducteurReservationId">
            <input type="hidden" name="idConducteur" id="evalConducteurId">
            
            <div class="modal-body">
                <div class="rating-container">
                    <span class="rating-label">Donnez une note de 1 à 5 étoiles</span>
                    <div class="rating-stars">
                        <button type="button" class="star" data-value="1" 
                                onmouseover="hoverStarConducteur(1)" 
                                onmouseout="resetStarsConducteur()" 
                                onclick="setNoteConducteur(1)">⭐</button>
                        <button type="button" class="star" data-value="2" 
                                onmouseover="hoverStarConducteur(2)" 
                                onmouseout="resetStarsConducteur()" 
                                onclick="setNoteConducteur(2)">⭐</button>
                        <button type="button" class="star" data-value="3" 
                                onmouseover="hoverStarConducteur(3)" 
                                onmouseout="resetStarsConducteur()" 
                                onclick="setNoteConducteur(3)">⭐</button>
                        <button type="button" class="star" data-value="4" 
                                onmouseover="hoverStarConducteur(4)" 
                                onmouseout="resetStarsConducteur()" 
                                onclick="setNoteConducteur(4)">⭐</button>
                        <button type="button" class="star" data-value="5" 
                                onmouseover="hoverStarConducteur(5)" 
                                onmouseout="resetStarsConducteur()" 
                                onclick="setNoteConducteur(5)">⭐</button>
                    </div>
                    <div class="rating-text" id="ratingConducteurText">Sélectionnez une note</div>
                    <input type="hidden" name="note" id="noteConducteurInput" required>
                </div>
                
                <div class="form-group">
                    <label for="commentaireConducteur">Commentaire (optionnel)</label>
                    <textarea name="commentaire" id="commentaireConducteur" rows="4" 
                              placeholder="Partagez votre expérience avec ce conducteur..."></textarea>
                </div>
            </div>
            
            <div class="modal-actions">
                <button type="button" class="btn btn-primary" onclick="closeEvaluerConducteurModal()">Annuler</button>
                <button type="submit" class="btn btn-complete" id="submitConducteurEvaluation" disabled>
                    Envoyer l'évaluation
                </button>
            </div>
        </form>
    </div>
</div>

<style>
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

<script>
    let currentNoteConducteur = 0;
    let currentHoverConducteur = 0;

    // Fonctions pour l'évaluation du conducteur
    function ouvrirEvaluationConducteur(reservationId, conducteurId) {
        document.getElementById('evalConducteurReservationId').value = reservationId;
        document.getElementById('evalConducteurId').value = conducteurId;
        document.getElementById('evaluerConducteurModal').classList.add('active');
        resetEvaluationConducteurForm();
    }
    
    function closeEvaluerConducteurModal() {
        document.getElementById('evaluerConducteurModal').classList.remove('active');
    }
    
    function resetEvaluationConducteurForm() {
        currentNoteConducteur = 0;
        currentHoverConducteur = 0;
        document.getElementById('noteConducteurInput').value = '';
        document.getElementById('commentaireConducteur').value = '';
        document.getElementById('submitConducteurEvaluation').disabled = true;
        resetStarsConducteur();
        updateRatingConducteurText();
    }
    
    function hoverStarConducteur(note) {
        currentHoverConducteur = note;
        updateStarsConducteurDisplay();
        updateRatingConducteurText();
    }
    
    function resetStarsConducteur() {
        currentHoverConducteur = 0;
        updateStarsConducteurDisplay();
        updateRatingConducteurText();
    }
    
    function setNoteConducteur(note) {
        currentNoteConducteur = note;
        document.getElementById('noteConducteurInput').value = note;
        document.getElementById('submitConducteurEvaluation').disabled = false;
        updateStarsConducteurDisplay();
        updateRatingConducteurText();
    }
    
    function updateStarsConducteurDisplay() {
        const stars = document.querySelectorAll('#evaluerConducteurModal .star');
        const displayNote = currentHoverConducteur || currentNoteConducteur;
        
        stars.forEach((star, index) => {
            const starValue = index + 1;
            if (starValue <= displayNote) {
                star.classList.add('active');
                if (currentHoverConducteur > 0 && currentNoteConducteur === 0) {
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
    
    function updateRatingConducteurText() {
        const ratingText = document.getElementById('ratingConducteurText');
        const displayNote = currentHoverConducteur || currentNoteConducteur;
        
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
        const modalEval = document.getElementById('evaluerConducteurModal');
        if (event.target == modalEval) {
            closeEvaluerConducteurModal();
        }
    }
    
    // Empêcher la soumission du formulaire si aucune note n'est sélectionnée
    document.getElementById('evaluationConducteurForm').addEventListener('submit', function(e) {
        if (currentNoteConducteur === 0) {
            e.preventDefault();
            alert('Veuillez sélectionner une note avant de soumettre l\'évaluation.');
        }
    });
</script>