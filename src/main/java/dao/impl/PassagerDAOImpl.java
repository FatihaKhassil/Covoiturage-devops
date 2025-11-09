package dao.impl;

import dao.PassagerDAO;
import models.Passager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PassagerDAOImpl implements PassagerDAO {
    private Connection connection;
    private UtilisateurDAOImpl utilisateurDAO;
    
    public PassagerDAOImpl(Connection connection) {
        this.connection = connection;
        this.utilisateurDAO = new UtilisateurDAOImpl(connection);
    }
    
    @Override
    public Long create(Passager passager) throws SQLException {
        // D'abord créer l'utilisateur
        Long userId = utilisateurDAO.create(passager);
        
        if (userId != null) {
            // Ensuite créer le passager
            String sql = "INSERT INTO passager (id_passager, note_moyenne) VALUES (?, ?)";
            
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setLong(1, userId);
                stmt.setDouble(2, passager.getNoteMoyenne());
                
                stmt.executeUpdate();
                passager.setIdUtilisateur(userId);
                return userId;
            }
        }
        return null;
    }
    
    @Override
    public Passager findById(Long id) throws SQLException {
        String sql = "SELECT u.*, p.note_moyenne " +
                     "FROM utilisateur u JOIN passager p ON u.id_utilisateur = p.id_passager " +
                     "WHERE u.id_utilisateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPassager(rs);
            }
        }
        return null;
    }
    
    @Override
    public boolean update(Passager passager) throws SQLException {
        // Mettre à jour l'utilisateur
        utilisateurDAO.update(passager);
        
        // Mettre à jour le passager
        String sql = "UPDATE passager SET note_moyenne = ? WHERE id_passager = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDouble(1, passager.getNoteMoyenne());
            stmt.setLong(2, passager.getIdUtilisateur());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean updateNoteMoyenne(Long passagerId, Double noteMoyenne) throws SQLException {
        String sql = "UPDATE passager SET note_moyenne = ? WHERE id_passager = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDouble(1, noteMoyenne);
            stmt.setLong(2, passagerId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        // La suppression en cascade s'occupe de supprimer le passager
        return utilisateurDAO.delete(id);
    }
    
    @Override
    public List<Passager> findAll() throws SQLException {
        List<Passager> passagers = new ArrayList<>();
        String sql = "SELECT u.*, p.note_moyenne " +
                     "FROM utilisateur u JOIN passager p ON u.id_utilisateur = p.id_passager";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                passagers.add(mapResultSetToPassager(rs));
            }
        }
        return passagers;
    }
    public Passager findByEmail(String email) throws SQLException {
        String sql = "SELECT u.*, p.note_moyenne " +
                     "FROM utilisateur u JOIN passager p ON u.id_utilisateur = p.id_passager " +
                     "WHERE u.email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPassager(rs);
            }
        }
        return null;
    }
    
    private Passager mapResultSetToPassager(ResultSet rs) throws SQLException {
        Passager passager = new Passager();
        passager.setIdUtilisateur(rs.getLong("id_utilisateur"));
        passager.setNom(rs.getString("nom"));
        passager.setPrenom(rs.getString("prenom"));
        passager.setEmail(rs.getString("email"));
        passager.setMotDePasse(rs.getString("mot_de_passe"));
        passager.setTelephone(rs.getString("telephone"));
        passager.setDateInscription(rs.getDate("date_inscription"));
        passager.setEstActif(rs.getBoolean("est_actif"));
        passager.setNoteMoyenne(rs.getDouble("note_moyenne"));
        
        return passager;
    }
}
