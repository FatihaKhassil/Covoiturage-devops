package dao.impl;

import dao.EvaluationDAO;
import models.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implémentation complète du DAO pour les évaluations
 * Toutes les méthodes de l'interface EvaluationDAO sont implémentées
 */
public class EvaluationDAOImpl implements EvaluationDAO {
    
    private Connection connection;
    
    public EvaluationDAOImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public Long create(Evaluation evaluation) throws SQLException {
        String sql = "INSERT INTO evaluation (id_reservation, id_evaluateur, id_evalue, " +
                     "note, commentaire, date_evaluation) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, evaluation.getIdReservation());
            stmt.setLong(2, evaluation.getIdEvaluateur());
            stmt.setLong(3, evaluation.getIdEvalue());
            stmt.setInt(4, evaluation.getNote());
            stmt.setString(5, evaluation.getCommentaire());
            stmt.setTimestamp(6, new Timestamp(evaluation.getDateEvaluation().getTime()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    Long id = rs.getLong(1);
                    evaluation.setIdEvaluation(id);
                    System.out.println("✅ Évaluation créée avec succès - ID: " + id);
                    return id;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ ERREUR lors de la création de l'évaluation: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return null;
    }
    
    @Override
    public Evaluation findById(Long id) throws SQLException {
        String sql = "SELECT e.*, " +
                     "eval_u.nom as eval_nom, eval_u.prenom as eval_prenom, " +
                     "eval_u.email as eval_email, eval_u.telephone as eval_telephone, " +
                     "evalu_u.nom as evalu_nom, evalu_u.prenom as evalu_prenom, " +
                     "evalu_u.email as evalu_email, evalu_u.telephone as evalu_telephone " +
                     "FROM evaluation e " +
                     "JOIN utilisateur eval_u ON e.id_evaluateur = eval_u.id_utilisateur " +
                     "JOIN utilisateur evalu_u ON e.id_evalue = evalu_u.id_utilisateur " +
                     "WHERE e.id_evaluation = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToEvaluation(rs);
            }
        } catch (SQLException e) {
            System.err.println("Erreur dans findById: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return null;
    }
    
    @Override
    public List<Evaluation> findByEvaluateur(Long evaluateurId) throws SQLException {
        List<Evaluation> evaluations = new ArrayList<>();
        
        String sql = "SELECT e.*, " +
                     "eval_u.nom as eval_nom, eval_u.prenom as eval_prenom, " +
                     "eval_u.email as eval_email, eval_u.telephone as eval_telephone, " +
                     "evalu_u.nom as evalu_nom, evalu_u.prenom as evalu_prenom, " +
                     "evalu_u.email as evalu_email, evalu_u.telephone as evalu_telephone " +
                     "FROM evaluation e " +
                     "JOIN utilisateur eval_u ON e.id_evaluateur = eval_u.id_utilisateur " +
                     "JOIN utilisateur evalu_u ON e.id_evalue = evalu_u.id_utilisateur " +
                     "WHERE e.id_evaluateur = ? " +
                     "ORDER BY e.date_evaluation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, evaluateurId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                evaluations.add(mapResultSetToEvaluation(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur dans findByEvaluateur: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        System.out.println("Trouvé " + evaluations.size() + " évaluation(s) faite(s) par l'utilisateur " + evaluateurId);
        return evaluations;
    }
    
    @Override
    public List<Evaluation> findByEvalue(Long evalueId) throws SQLException {
        List<Evaluation> evaluations = new ArrayList<>();
        
        String sql = "SELECT e.*, " +
                     "eval_u.nom as eval_nom, eval_u.prenom as eval_prenom, " +
                     "eval_u.email as eval_email, eval_u.telephone as eval_telephone, " +
                     "evalu_u.nom as evalu_nom, evalu_u.prenom as evalu_prenom, " +
                     "evalu_u.email as evalu_email, evalu_u.telephone as evalu_telephone " +
                     "FROM evaluation e " +
                     "JOIN utilisateur eval_u ON e.id_evaluateur = eval_u.id_utilisateur " +
                     "JOIN utilisateur evalu_u ON e.id_evalue = evalu_u.id_utilisateur " +
                     "WHERE e.id_evalue = ? " +
                     "ORDER BY e.date_evaluation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, evalueId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                evaluations.add(mapResultSetToEvaluation(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur dans findByEvalue: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        System.out.println("Trouvé " + evaluations.size() + " évaluation(s) reçue(s) par l'utilisateur " + evalueId);
        return evaluations;
    }
    
    @Override
    public List<Evaluation> findAll() throws SQLException {
        List<Evaluation> evaluations = new ArrayList<>();
        
        String sql = "SELECT e.*, " +
                     "eval_u.nom as eval_nom, eval_u.prenom as eval_prenom, " +
                     "eval_u.email as eval_email, eval_u.telephone as eval_telephone, " +
                     "evalu_u.nom as evalu_nom, evalu_u.prenom as evalu_prenom, " +
                     "evalu_u.email as evalu_email, evalu_u.telephone as evalu_telephone " +
                     "FROM evaluation e " +
                     "JOIN utilisateur eval_u ON e.id_evaluateur = eval_u.id_utilisateur " +
                     "JOIN utilisateur evalu_u ON e.id_evalue = evalu_u.id_utilisateur " +
                     "ORDER BY e.date_evaluation DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                evaluations.add(mapResultSetToEvaluation(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération de toutes les évaluations: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        System.out.println("Trouvé " + evaluations.size() + " évaluation(s) au total");
        return evaluations;
    }
    
    @Override
    public boolean update(Evaluation evaluation) throws SQLException {
        String sql = "UPDATE evaluation SET note = ?, commentaire = ? " +
                     "WHERE id_evaluation = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, evaluation.getNote());
            stmt.setString(2, evaluation.getCommentaire());
            stmt.setLong(3, evaluation.getIdEvaluation());
            
            int rowsUpdated = stmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                System.out.println("✅ Évaluation mise à jour - ID: " + evaluation.getIdEvaluation());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Erreur dans update: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return false;
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM evaluation WHERE id_evaluation = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            int rowsDeleted = stmt.executeUpdate();
            
            if (rowsDeleted > 0) {
                System.out.println("✅ Évaluation supprimée - ID: " + id);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Erreur dans delete: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return false;
    }
    
    @Override
    public Double calculateNoteMoyenne(Long evalueId) throws SQLException {
        String sql = "SELECT AVG(note) as moyenne FROM evaluation WHERE id_evalue = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, evalueId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                double moyenne = rs.getDouble("moyenne");
                if (!rs.wasNull()) {
                    System.out.println("📊 Note moyenne calculée pour utilisateur " + evalueId + ": " + String.format("%.2f", moyenne));
                    return moyenne;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors du calcul de la note moyenne: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return null;
    }
    
    @Override
    public int countEvaluationsByEvalue(Long evalueId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM evaluation WHERE id_evalue = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, evalueId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int total = rs.getInt("total");
                System.out.println("📊 Nombre d'évaluations pour utilisateur " + evalueId + ": " + total);
                return total;
            }
        } catch (SQLException e) {
            System.err.println("Erreur dans countEvaluationsByEvalue: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return 0;
    }
    
    @Override
    public boolean existeEvaluation(Long reservationId, Long evaluateurId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM evaluation " +
                     "WHERE id_reservation = ? AND id_evaluateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, reservationId);
            stmt.setLong(2, evaluateurId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                boolean existe = rs.getInt("count") > 0;
                System.out.println("🔍 Vérification évaluation - Réservation: " + reservationId + 
                                 ", Évaluateur: " + evaluateurId + ", Existe: " + existe);
                return existe;
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la vérification de l'évaluation: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return false;
    }
    
    /**
     * Mapper un ResultSet vers un objet Evaluation
     * Méthode privée utilisée par toutes les méthodes find*
     */
    private Evaluation mapResultSetToEvaluation(ResultSet rs) throws SQLException {
        Evaluation evaluation = new Evaluation();
        
        // Mapper les champs de base
        evaluation.setIdEvaluation(rs.getLong("id_evaluation"));
        evaluation.setIdReservation(rs.getLong("id_reservation"));
        evaluation.setIdEvaluateur(rs.getLong("id_evaluateur"));
        evaluation.setIdEvalue(rs.getLong("id_evalue"));
        evaluation.setNote(rs.getInt("note"));
        
        String commentaire = rs.getString("commentaire");
        evaluation.setCommentaire(commentaire != null ? commentaire : "");
        
        evaluation.setDateEvaluation(rs.getTimestamp("date_evaluation"));
        
        // Mapper l'évaluateur (objet Utilisateur simplifié)
        Utilisateur evaluateur = new Utilisateur();
        evaluateur.setIdUtilisateur(rs.getLong("id_evaluateur"));
        evaluateur.setNom(rs.getString("eval_nom"));
        evaluateur.setPrenom(rs.getString("eval_prenom"));
        evaluateur.setEmail(rs.getString("eval_email"));
        evaluateur.setTelephone(rs.getString("eval_telephone"));
        evaluation.setEvaluateur(evaluateur);
        
        // Mapper l'évalué (objet Utilisateur simplifié)
        Utilisateur evalue = new Utilisateur();
        evalue.setIdUtilisateur(rs.getLong("id_evalue"));
        evalue.setNom(rs.getString("evalu_nom"));
        evalue.setPrenom(rs.getString("evalu_prenom"));
        evalue.setEmail(rs.getString("evalu_email"));
        evalue.setTelephone(rs.getString("evalu_telephone"));
        evaluation.setEvalue(evalue);
        
        return evaluation;
    }
}