package dao;

import models.Evaluation;
import java.sql.SQLException;
import java.util.List;

public interface EvaluationDAO {
    Long create(Evaluation evaluation) throws SQLException;
    Evaluation findById(Long id) throws SQLException;
    List<Evaluation> findAll() throws SQLException;
    List<Evaluation> findByEvalue(Long evalueId) throws SQLException;
    List<Evaluation> findByEvaluateur(Long evaluateurId) throws SQLException;
    boolean update(Evaluation evaluation) throws SQLException;
    boolean delete(Long id) throws SQLException;
    Double calculateNoteMoyenne(Long evalueId) throws SQLException;
    int countEvaluationsByEvalue(Long evalueId) throws SQLException;
	   Evaluation findByReservationAndEvaluateur(Long reservationId, Long evaluateurId, String typeEvaluateur);
	    boolean evaluationExistsForReservation(Long reservationId, Long evaluateurId, String typeEvaluateur);
	    boolean existsForOffre(Long idOffre, Long idEvaluateur, Long idEvalue);
		Evaluation findByOffreAndEvaluateur(Long idOffre, Long idUtilisateur);
	    
}