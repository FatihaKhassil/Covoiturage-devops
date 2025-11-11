package dao.impl;

import dao.EvaluationDAO;
import models.Evaluation;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvaluationDAOImpl implements EvaluationDAO {

    private final Connection connection;

    public EvaluationDAOImpl(Connection connection) {
        this.connection = connection;
    }

    // ✅ Ajouter une évaluation
    @Override
    public Long create(Evaluation evaluation) throws SQLException {
        String sql = "INSERT INTO evaluation (id_offre, id_evaluateur, id_evalue, note, commentaire, date_evaluation) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, evaluation.getIdOffre());
            stmt.setLong(2, evaluation.getIdEvaluateur());
            stmt.setLong(3, evaluation.getIdEvalue());
            stmt.setInt(4, evaluation.getNote());
            stmt.setString(5, evaluation.getCommentaire());
            stmt.setDate(6, new java.sql.Date(evaluation.getDateEvaluation().getTime()));

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        return null;
    }

    // ✅ Trouver une évaluation par ID
    @Override
    public Evaluation findById(Long id) throws SQLException {
        String sql = "SELECT * FROM evaluation WHERE id_evaluation = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEvaluation(rs);
                }
            }
        }
        return null;
    }

    // ✅ Lister toutes les évaluations
    @Override
    public List<Evaluation> findAll() throws SQLException {
        List<Evaluation> evaluations = new ArrayList<>();
        String sql = "SELECT * FROM evaluation ORDER BY date_evaluation DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                evaluations.add(mapResultSetToEvaluation(rs));
            }
        }
        return evaluations;
    }

    // ✅ Lister les évaluations reçues par un utilisateur
    @Override
    public List<Evaluation> findByEvalue(Long evalueId) throws SQLException {
        List<Evaluation> evaluations = new ArrayList<>();
        String sql = "SELECT * FROM evaluation WHERE id_evalue = ? ORDER BY date_evaluation DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, evalueId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    evaluations.add(mapResultSetToEvaluation(rs));
                }
            }
        }
        return evaluations;
    }

    // ✅ Lister les évaluations faites par un utilisateur
    @Override
    public List<Evaluation> findByEvaluateur(Long evaluateurId) throws SQLException {
        List<Evaluation> evaluations = new ArrayList<>();
        String sql = "SELECT * FROM evaluation WHERE id_evaluateur = ? ORDER BY date_evaluation DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, evaluateurId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    evaluations.add(mapResultSetToEvaluation(rs));
                }
            }
        }
        return evaluations;
    }

    // ✅ Mettre à jour une évaluation
    @Override
    public boolean update(Evaluation evaluation) throws SQLException {
        String sql = "UPDATE evaluation SET note = ?, commentaire = ? WHERE id_evaluation = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, evaluation.getNote());
            stmt.setString(2, evaluation.getCommentaire());
            stmt.setLong(3, evaluation.getIdEvaluation());
            return stmt.executeUpdate() > 0;
        }
    }

    // ✅ Supprimer une évaluation
    @Override
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM evaluation WHERE id_evaluation = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // ✅ Calculer la note moyenne d’un utilisateur
    @Override
    public Double calculateNoteMoyenne(Long evalueId) throws SQLException {
        String sql = "SELECT ROUND(AVG(note), 2) AS moyenne FROM evaluation WHERE id_evalue = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, evalueId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double moyenne = rs.getDouble("moyenne");
                    return rs.wasNull() ? 0.0 : moyenne;
                }
            }
        }
        return 0.0;
    }

    // ✅ Compter le nombre d’évaluations reçues
    @Override
    public int countEvaluationsByEvalue(Long evalueId) throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM evaluation WHERE id_evalue = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, evalueId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    // ✅ Vérifier si une évaluation existe déjà pour une offre donnée
    @Override
    public boolean existsForOffre(Long idOffre, Long idEvaluateur, Long idEvalue) throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM evaluation WHERE id_offre = ? AND id_evaluateur = ? AND id_evalue = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, idOffre);
            stmt.setLong(2, idEvaluateur);
            stmt.setLong(3, idEvalue);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total") > 0;
                }
            }
        }
        return false;
    }

    // ✅ Mapping ResultSet → Objet Evaluation
    private Evaluation mapResultSetToEvaluation(ResultSet rs) throws SQLException {
        Evaluation evaluation = new Evaluation();
        evaluation.setIdEvaluation(rs.getLong("id_evaluation"));
        evaluation.setIdOffre(rs.getLong("id_offre"));
        evaluation.setIdEvaluateur(rs.getLong("id_evaluateur"));
        evaluation.setIdEvalue(rs.getLong("id_evalue"));
        evaluation.setNote(rs.getInt("note"));
        evaluation.setCommentaire(rs.getString("commentaire"));
        evaluation.setDateEvaluation(rs.getDate("date_evaluation"));
        return evaluation;
    }
}
