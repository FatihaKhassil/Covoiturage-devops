
package dao.impl;

import dao.AdministrateurDAO;
import models.Administrateur;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdministrateurDAOImpl implements AdministrateurDAO {
    private Connection connection;
    private UtilisateurDAOImpl utilisateurDAO;
    
    public AdministrateurDAOImpl(Connection connection) {
        this.connection = connection;
        this.utilisateurDAO = new UtilisateurDAOImpl(connection);
    }
    
    @Override
    public Long create(Administrateur administrateur) throws SQLException {
        // D'abord créer l'utilisateur
        Long userId = utilisateurDAO.create(administrateur);
        
        if (userId != null) {
            // Ensuite créer l'administrateur
            String sql = "INSERT INTO administrateur (id_administrateur) VALUES (?)";
            
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setLong(1, userId);
                stmt.executeUpdate();
                administrateur.setIdUtilisateur(userId);
                return userId;
            }
        }
        return null;
    }
    
    @Override
    public Administrateur findById(Long id) throws SQLException {
        String sql = "SELECT u.* FROM utilisateur u " +
                     "JOIN administrateur a ON u.id_utilisateur = a.id_administrateur " +
                     "WHERE u.id_utilisateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAdministrateur(rs);
            }
        }
        return null;
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        // La suppression en cascade s'occupe de supprimer l'administrateur
        return utilisateurDAO.delete(id);
    }
    
    @Override
    public List<Administrateur> findAll() throws SQLException {
        List<Administrateur> administrateurs = new ArrayList<>();
        String sql = "SELECT u.* FROM utilisateur u " +
                     "JOIN administrateur a ON u.id_utilisateur = a.id_administrateur";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                administrateurs.add(mapResultSetToAdministrateur(rs));
            }
        }
        return administrateurs;
    }
    public Administrateur findByEmail(String email) throws SQLException {
        String sql = "SELECT u.* FROM utilisateur u " +
                     "JOIN administrateur a ON u.id_utilisateur = a.id_administrateur " +
                     "WHERE u.email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAdministrateur(rs);
            }
        }
        return null;
    }
    private Administrateur mapResultSetToAdministrateur(ResultSet rs) throws SQLException {
        Administrateur admin = new Administrateur();
        admin.setIdUtilisateur(rs.getLong("id_utilisateur"));
        admin.setNom(rs.getString("nom"));
        admin.setPrenom(rs.getString("prenom"));
        admin.setEmail(rs.getString("email"));
        admin.setMotDePasse(rs.getString("mot_de_passe"));
        admin.setTelephone(rs.getString("telephone"));
        admin.setDateInscription(rs.getDate("date_inscription"));
        admin.setEstActif(rs.getBoolean("est_actif"));
        
        return admin;
    }
}
