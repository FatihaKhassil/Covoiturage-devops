package dao.impl; // Assurez-vous que ce package correspond à votre structure

import dao.NotificationDAO;
import models.Notification;
import models.Utilisateur; // Supposons que vous ayez une classe Utilisateur dans models
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class NotificationDAOImpl implements NotificationDAO {
    private Connection connection;

    // Le constructeur doit prendre la connexion pour toutes les opérations
    public NotificationDAOImpl(Connection connection) {
        this.connection = connection;
    }

    // --- Méthode d'aide pour mapper le ResultSet à l'objet Notification ---
    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setIdNotification(rs.getLong("id_notification"));
        // Utilisation de .getLong("id_utilisateur") pour le champ Long dans le modèle
        notification.setIdUtilisateur(rs.getLong("id_utilisateur")); 
        notification.setMessage(rs.getString("message"));
        notification.setEstLue(rs.getBoolean("est_lue"));
        notification.setDateEnvoi(new Date(rs.getTimestamp("date_envoi").getTime()));

        // Vous n'avez pas besoin de mapper l'Utilisateur complet si le modèle Notification
        // n'utilise que l'ID (comme dans votre modèle fourni).

        return notification;
    }

    @Override
    public Long create(Notification notification) throws SQLException {
        String sql = "INSERT INTO notification (id_utilisateur, message, date_envoi, est_lue) " +
                     "VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, notification.getIdUtilisateur());
            stmt.setString(2, notification.getMessage());
            // Utilisez java.sql.Timestamp pour DATE/DATETIME en SQL
            stmt.setTimestamp(3, new Timestamp(notification.getDateEnvoi().getTime())); 
            stmt.setBoolean(4, notification.getEstLue());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("La création de la notification a échoué, aucune ligne affectée.");
            }

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        return null; // ou lancer une exception si non créé
    }

    @Override
    public Notification findById(Long id) throws SQLException {
        String sql = "SELECT * FROM notification WHERE id_notification = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToNotification(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Notification> findByUtilisateur(Long utilisateurId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE id_utilisateur = ? ORDER BY date_envoi DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
        }
        return notifications;
    }

    @Override
    public List<Notification> findNonLuesByUtilisateur(Long utilisateurId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE id_utilisateur = ? AND est_lue = FALSE ORDER BY date_envoi DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
        }
        return notifications;
    }

    @Override
    public boolean marquerCommeLue(Long notificationId) throws SQLException {
        String sql = "UPDATE notification SET est_lue = TRUE WHERE id_notification = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, notificationId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean marquerToutesCommeLues(Long utilisateurId) throws SQLException {
        String sql = "UPDATE notification SET est_lue = 1 WHERE id_utilisateur = ? AND est_lue = 0";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public int compterNonLues(Long utilisateurId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM notification WHERE id_utilisateur = ? AND est_lue = 0";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    @Override
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM notification WHERE id_notification = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public int deleteOldNotifications(int jours) throws SQLException {
        // Supprime les notifications plus anciennes que le nombre de jours spécifié
        // NOTE: La fonction pour calculer la date varie selon la BDD (MySQL: DATE_SUB, PostgreSQL: INTERVAL)
        String sql = "DELETE FROM notification WHERE date_envoi < DATE_SUB(NOW(), INTERVAL ? DAY)"; 
        
        // Si vous utilisez PostgreSQL:
        // String sql = "DELETE FROM notification WHERE date_envoi < (NOW() - INTERVAL '" + jours + " days')";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, jours);
            return stmt.executeUpdate();
        }
    }
}