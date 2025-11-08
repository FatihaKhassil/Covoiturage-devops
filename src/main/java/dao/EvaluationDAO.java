package dao;

import models.*;
import java.sql.SQLException;
import java.util.List;
import java.util.Date;

//Interface EvaluationDAO
interface EvaluationDAO {
 Long create(Evaluation evaluation) throws SQLException;
 Evaluation findById(Long id) throws SQLException;
 List<Evaluation> findByEvalue(Long evalueId) throws SQLException;
 List<Evaluation> findByEvaluateur(Long evaluateurId) throws SQLException;
 boolean exists(Long offreId, Long evaluateurId, Long evalueId) throws SQLException;
 Double calculateNoteMoyenne(Long userId) throws SQLException;
 boolean update(Evaluation evaluation) throws SQLException;
 boolean delete(Long id) throws SQLException;
}