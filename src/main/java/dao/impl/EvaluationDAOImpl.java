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
    public Long create(Evaluation evaluation) {
        String sql = "INSERT INTO evaluation (id_offre, id_evaluateur, id_evalue, note, commentaire, date_evaluation, type_evaluateur) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, evaluation.getIdOffre());
            stmt.setLong(2, evaluation.getIdEvaluateur());
            stmt.setLong(3, evaluation.getIdEvalue());
            stmt.setInt(4, evaluation.getNote());
            stmt.setString(5, evaluation.getCommentaire());
            stmt.setTimestamp(6, new Timestamp(evaluation.getDateEvaluation().getTime()));
            stmt.setString(7, evaluation.getTypeEvaluateur());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void debugEvaluationsForPassager(Long passagerId) throws SQLException {
        String sql = "SELECT * FROM evaluation WHERE id_evalue = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, passagerId);
            try (ResultSet rs = stmt.executeQuery()) {
                System.out.println("=== DEBUG ÉVALUATIONS POUR PASSAGER " + passagerId + " ===");
                int count = 0;
                while (rs.next()) {
                    count++;
                    System.out.println("Évaluation " + count + ":");
                    System.out.println("  ID: " + rs.getLong("id_evaluation"));
                    System.out.println("  Note: " + rs.getInt("note"));
                    System.out.println("  Commentaire: " + rs.getString("commentaire"));
                    System.out.println("  Type: " + rs.getString("type_evaluateur"));
                    System.out.println("  Date: " + rs.getDate("date_evaluation"));
                }
                System.out.println("Total: " + count + " évaluation(s) trouvée(s)");
            }
        }
    }
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
        String sql = "SELECT e.*, " +
                    "u.nom as evaluateur_nom, u.prenom as evaluateur_prenom, " +
                    "o.ville_depart, o.ville_arrivee, o.date_depart " +
                    "FROM evaluation e " +
                    "JOIN utilisateur u ON e.id_evaluateur = u.id_utilisateur " +
                    "JOIN offre o ON e.id_offre = o.id_offre " +
                    "WHERE e.id_evalue = ? " +
                    "ORDER BY e.date_evaluation DESC";

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

    @Override
    public boolean existsForOffre(Long idOffre, Long idEvaluateur, Long idEvalue) {
        // ✅ Vérifier sans type_evaluateur pour plus de simplicité
        String sql = "SELECT COUNT(*) FROM evaluation " +
                     "WHERE id_offre = ? AND id_evaluateur = ? AND id_evalue = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, idOffre);
            stmt.setLong(2, idEvaluateur);
            stmt.setLong(3, idEvalue);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("DEBUG existsForOffre - Count: " + count + 
                                 " (Offre:" + idOffre + ", Eval:" + idEvaluateur + ", Evalue:" + idEvalue + ")");
                return count > 0;
            }
        } catch (SQLException e) {
            System.err.println("❌ ERREUR existsForOffre: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    @Override
    public Evaluation findByReservationAndEvaluateur(Long reservationId, Long evaluateurId, String typeEvaluateur) {
        String sql = "SELECT e.* FROM evaluations e " +
                    "JOIN reservations r ON e.id_offre = r.offre_id " +
                    "WHERE r.id_reservation = ? AND e.evaluateur_id = ? AND e.type_evaluateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, reservationId);
            stmt.setLong(2, evaluateurId);
            stmt.setString(3, typeEvaluateur);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToEvaluation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public boolean evaluationExistsForReservation(Long reservationId, Long evaluateurId, String typeEvaluateur) {
        String sql = "SELECT COUNT(*) FROM evaluations e " +
                    "JOIN reservations r ON e.id_offre = r.offre_id " +
                    "WHERE r.id_reservation = ? AND e.evaluateur_id = ? AND e.type_evaluateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, reservationId);
            stmt.setLong(2, evaluateurId);
            stmt.setString(3, typeEvaluateur);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
        evaluation.setDateEvaluation(rs.getTimestamp("date_evaluation"));
        evaluation.setTypeEvaluateur(rs.getString("type_evaluateur"));
       
        try {
            evaluation.setEvaluateurNom(rs.getString("evaluateur_nom"));
            evaluation.setEvaluateurPrenom(rs.getString("evaluateur_prenom"));
            evaluation.setVilleDepart(rs.getString("ville_depart"));
            evaluation.setVilleArrivee(rs.getString("ville_arrivee"));
            evaluation.setDateDepart(rs.getDate("date_depart"));
        } catch (SQLException e) {
          
        }
        
        return evaluation;
    }

    @Override
    public Evaluation findByOffreAndEvaluateur(Long idOffre, Long idEvaluateur) {
        String sql = "SELECT e.*, " +
                    "u.nom as evaluateur_nom, u.prenom as evaluateur_prenom, " +
                    "o.ville_depart, o.ville_arrivee, o.date_depart " +
                    "FROM evaluation e " +
                    "JOIN utilisateur u ON e.id_evaluateur = u.id_utilisateur " +
                    "JOIN offre o ON e.id_offre = o.id_offre " +
                    "WHERE e.id_offre = ? AND e.id_evaluateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, idOffre);
            stmt.setLong(2, idEvaluateur);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToEvaluation(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ ERREUR findByOffreAndEvaluateur: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

}