package dao.impl;

import dao.NotificationDAO;
import models.Notification;
import models.Utilisateur;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl implements NotificationDAO {
    private Connection connection;
    
    public NotificationDAOImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public Long create(Notification notification) throws SQLException {
        String sql = "INSERT INTO notification (id_utilisateur, type_notification, titre, " +
                     "message, est_lu, date_creation) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, notification.getUtilisateur().getIdUtilisateur());
            stmt.setString(2, notification.getTypeNotification());
            stmt.setString(3, notification.getTitre());
            stmt.setString(4, notification.getMessage());
            stmt.setBoolean(5, notification.getEstLu());
            stmt.setTimestamp(6, new Timestamp(notification.getDateCreation().getTime()));
            
            stmt.executeUpdate();
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return null;
    }
    
    @Override
    public Notification findById(Long id) throws SQLException {
        String sql = "SELECT n.*, u.nom, u.prenom, u.email " +
                     "FROM notification n " +
                     "JOIN utilisateur u ON n.id_utilisateur = u.id_utilisateur " +
                     "WHERE n.id_notification = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToNotification(rs);
            }
        }
        return null;
    }
    
    @Override
    public List<Notification> findAll() throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, u.nom, u.prenom, u.email " +
                     "FROM notification n " +
                     "JOIN utilisateur u ON n.id_utilisateur = u.id_utilisateur " +
                     "ORDER BY n.date_creation DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        }
        return notifications;
    }
    
    @Override
    public List<Notification> findByUtilisateur(Long utilisateurId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, u.nom, u.prenom, u.email " +
                     "FROM notification n " +
                     "JOIN utilisateur u ON n.id_utilisateur = u.id_utilisateur " +
                     "WHERE n.id_utilisateur = ? " +
                     "ORDER BY n.date_creation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        }
        return notifications;
    }
    
    @Override
    public List<Notification> findNonLues(Long utilisateurId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, u.nom, u.prenom, u.email " +
                     "FROM notification n " +
                     "JOIN utilisateur u ON n.id_utilisateur = u.id_utilisateur " +
                     "WHERE n.id_utilisateur = ? AND n.est_lu = FALSE " +
                     "ORDER BY n.date_creation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        }
        return notifications;
    }
    
    @Override
    public boolean marquerCommeLue(Long notificationId) throws SQLException {
        String sql = "UPDATE notification SET est_lu = TRUE WHERE id_notification = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, notificationId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean marquerToutesCommeLues(Long utilisateurId) throws SQLException {
        String sql = "UPDATE notification SET est_lu = TRUE WHERE id_utilisateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            return stmt.executeUpdate() > 0;
        }
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
    public boolean deleteByUtilisateur(Long utilisateurId) throws SQLException {
        String sql = "DELETE FROM notification WHERE id_utilisateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public int countNonLues(Long utilisateurId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM notification WHERE id_utilisateur = ? AND est_lu = FALSE";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, utilisateurId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setIdNotification(rs.getLong("id_notification"));
        notification.setTypeNotification(rs.getString("type_notification"));
        notification.setTitre(rs.getString("titre"));
        notification.setMessage(rs.getString("message"));
        notification.setEstLu(rs.getBoolean("est_lu"));
        notification.setDateCreation(rs.getTimestamp("date_creation"));
        
        // Mapper l'utilisateur
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setIdUtilisateur(rs.getLong("id_utilisateur"));
        utilisateur.setNom(rs.getString("nom"));
        utilisateur.setPrenom(rs.getString("prenom"));
        utilisateur.setEmail(rs.getString("email"));
        notification.setUtilisateur(utilisateur);
        
        return notification;
    }
}