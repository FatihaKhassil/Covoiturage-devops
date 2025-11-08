package dao.impl;

import dao.UtilisateurDAO;
import models.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAOImpl implements UtilisateurDAO {
    private Connection connection;
    
    public UtilisateurDAOImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public Long create(Utilisateur utilisateur) throws SQLException {
        String sql = "INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, telephone, " +
                     "date_inscription, est_actif) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, utilisateur.getNom());
            stmt.setString(2, utilisateur.getPrenom());
            stmt.setString(3, utilisateur.getEmail());
            stmt.setString(4, utilisateur.getMotDePasse());
            stmt.setString(5, utilisateur.getTelephone());
            stmt.setDate(6, new java.sql.Date(utilisateur.getDateInscription().getTime()));
            stmt.setBoolean(7, utilisateur.getEstActif());
            
            stmt.executeUpdate();
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return null;
    }
    
    @Override
    public Utilisateur findById(Long id) throws SQLException {
        String sql = "SELECT * FROM utilisateur WHERE id_utilisateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUtilisateur(rs);
            }
        }
        return null;
    }
    
    @Override
    public Utilisateur findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM utilisateur WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUtilisateur(rs);
            }
        }
        return null;
    }
    
    @Override
    public Utilisateur authenticate(String email, String motDePasse) throws SQLException {
        String sql = "SELECT * FROM utilisateur WHERE email = ? AND mot_de_passe = ? AND est_actif = TRUE";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, motDePasse);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUtilisateur(rs);
            }
        }
        return null;
    }
    
    @Override
    public boolean update(Utilisateur utilisateur) throws SQLException {
        String sql = "UPDATE utilisateur SET nom = ?, prenom = ?, email = ?, telephone = ?, " +
                     "est_actif = ? WHERE id_utilisateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, utilisateur.getNom());
            stmt.setString(2, utilisateur.getPrenom());
            stmt.setString(3, utilisateur.getEmail());
            stmt.setString(4, utilisateur.getTelephone());
            stmt.setBoolean(5, utilisateur.getEstActif());
            stmt.setLong(6, utilisateur.getIdUtilisateur());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM utilisateur WHERE id_utilisateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public List<Utilisateur> findAll() throws SQLException {
        List<Utilisateur> utilisateurs = new ArrayList<>();
        String sql = "SELECT * FROM utilisateur";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                utilisateurs.add(mapResultSetToUtilisateur(rs));
            }
        }
        return utilisateurs;
    }
    
    private Utilisateur mapResultSetToUtilisateur(ResultSet rs) throws SQLException {
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setIdUtilisateur(rs.getLong("id_utilisateur"));
        utilisateur.setNom(rs.getString("nom"));
        utilisateur.setPrenom(rs.getString("prenom"));
        utilisateur.setEmail(rs.getString("email"));
        utilisateur.setMotDePasse(rs.getString("mot_de_passe"));
        utilisateur.setTelephone(rs.getString("telephone"));
        utilisateur.setDateInscription(rs.getDate("date_inscription"));
        utilisateur.setEstActif(rs.getBoolean("est_actif"));
        
        return utilisateur;
    }
}