package dao;

import models.Evaluation;
import java.sql.SQLException;
import java.util.List;

/**
 * Interface DAO pour gérer les évaluations
 */
public interface EvaluationDAO {
    
    /**
     * Créer une nouvelle évaluation
     * @param evaluation L'évaluation à créer
     * @return L'ID de l'évaluation créée, ou null en cas d'erreur
     */
    Long create(Evaluation evaluation) throws SQLException;
    
    /**
     * Trouver une évaluation par son ID
     * @param id L'ID de l'évaluation
     * @return L'évaluation trouvée, ou null si non trouvée
     */
    Evaluation findById(Long id) throws SQLException;
    
    /**
     * Trouver toutes les évaluations faites par un évaluateur
     * @param evaluateurId L'ID de l'évaluateur
     * @return Liste des évaluations faites par cet utilisateur
     */
    List<Evaluation> findByEvaluateur(Long evaluateurId) throws SQLException;
    
    /**
     * Trouver toutes les évaluations reçues par un utilisateur
     * @param evalueId L'ID de l'utilisateur évalué
     * @return Liste des évaluations reçues par cet utilisateur
     */
    List<Evaluation> findByEvalue(Long evalueId) throws SQLException;
    
    /**
     * Mettre à jour une évaluation existante
     * @param evaluation L'évaluation à mettre à jour
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean update(Evaluation evaluation) throws SQLException;
    
    /**
     * Supprimer une évaluation
     * @param id L'ID de l'évaluation à supprimer
     * @return true si la suppression a réussi, false sinon
     */
    boolean delete(Long id) throws SQLException;
    
    /**
     * Calculer la note moyenne d'un utilisateur
     * @param evalueId L'ID de l'utilisateur
     * @return La note moyenne (entre 1 et 5), ou null si aucune évaluation
     */
    Double calculateNoteMoyenne(Long evalueId) throws SQLException;
    
    /**
     * Compter le nombre d'évaluations reçues par un utilisateur
     * @param evalueId L'ID de l'utilisateur
     * @return Le nombre total d'évaluations
     */
    int countEvaluationsByEvalue(Long evalueId) throws SQLException;
    
    /**
     * Vérifier si une évaluation existe déjà pour une réservation et un évaluateur
     * Empêche les doubles évaluations
     * @param reservationId L'ID de la réservation
     * @param evaluateurId L'ID de l'évaluateur
     * @return true si l'évaluation existe déjà, false sinon
     */
    boolean existeEvaluation(Long reservationId, Long evaluateurId) throws SQLException;
    
    /**
     * Trouver toutes les évaluations (optionnel, pour admin)
     * @return Liste de toutes les évaluations
     */
    List<Evaluation> findAll() throws SQLException;
}