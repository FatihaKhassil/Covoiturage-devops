
package dao.impl;

import dao.ConducteurDAO;
import models.Conducteur;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConducteurDAOImpl implements ConducteurDAO {
    private Connection connection;
    private UtilisateurDAOImpl utilisateurDAO;
    
    public ConducteurDAOImpl(Connection connection) {
        this.connection = connection;
        this.utilisateurDAO = new UtilisateurDAOImpl(connection);
    }
    
    @Override
    public Long create(Conducteur conducteur) throws SQLException {
        // D'abord créer l'utilisateur
        Long userId = utilisateurDAO.create(conducteur);
        
        if (userId != null) {
            // Ensuite créer le conducteur
            String sql = "INSERT INTO conducteur (id_conducteur, marque_vehicule, modele_vehicule, " +
                         "immatriculation, nombre_places_vehicule, note_moyenne) VALUES (?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setLong(1, userId);
                stmt.setString(2, conducteur.getMarqueVehicule());
                stmt.setString(3, conducteur.getModeleVehicule());
                stmt.setString(4, conducteur.getImmatriculation());
                stmt.setInt(5, conducteur.getNombrePlacesVehicule());
                stmt.setDouble(6, conducteur.getNoteMoyenne());
                
                stmt.executeUpdate();
                conducteur.setIdUtilisateur(userId);
                return userId;
            }
        }
        return null;
    }
    
    @Override
    public Conducteur findById(Long id) throws SQLException {
        String sql = "SELECT u.*, c.marque_vehicule, c.modele_vehicule, c.immatriculation, " +
                     "c.nombre_places_vehicule, c.note_moyenne " +
                     "FROM utilisateur u JOIN conducteur c ON u.id_utilisateur = c.id_conducteur " +
                     "WHERE u.id_utilisateur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToConducteur(rs);
            }
        }
        return null;
    }
    
    @Override
    public boolean update(Conducteur conducteur) throws SQLException {
        // Mettre à jour l'utilisateur
        utilisateurDAO.update(conducteur);
        
        // Mettre à jour le conducteur
        String sql = "UPDATE conducteur SET marque_vehicule = ?, modele_vehicule = ?, " +
                     "immatriculation = ?, nombre_places_vehicule = ?, note_moyenne = ? " +
                     "WHERE id_conducteur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, conducteur.getMarqueVehicule());
            stmt.setString(2, conducteur.getModeleVehicule());
            stmt.setString(3, conducteur.getImmatriculation());
            stmt.setInt(4, conducteur.getNombrePlacesVehicule());
            stmt.setDouble(5, conducteur.getNoteMoyenne());
            stmt.setLong(6, conducteur.getIdUtilisateur());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean updateNoteMoyenne(Long conducteurId, Double noteMoyenne) throws SQLException {
        String sql = "UPDATE conducteur SET note_moyenne = ? WHERE id_conducteur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDouble(1, noteMoyenne);
            stmt.setLong(2, conducteurId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        // La suppression en cascade s'occupe de supprimer le conducteur
        return utilisateurDAO.delete(id);
    }
    
    @Override
    public List<Conducteur> findAll() throws SQLException {
        List<Conducteur> conducteurs = new ArrayList<>();
        String sql = "SELECT u.*, c.marque_vehicule, c.modele_vehicule, c.immatriculation, " +
                     "c.nombre_places_vehicule, c.note_moyenne " +
                     "FROM utilisateur u JOIN conducteur c ON u.id_utilisateur = c.id_conducteur";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                conducteurs.add(mapResultSetToConducteur(rs));
            }
        }
        return conducteurs;
    }
    
    private Conducteur mapResultSetToConducteur(ResultSet rs) throws SQLException {
        Conducteur conducteur = new Conducteur();
        conducteur.setIdUtilisateur(rs.getLong("id_utilisateur"));
        conducteur.setNom(rs.getString("nom"));
        conducteur.setPrenom(rs.getString("prenom"));
        conducteur.setEmail(rs.getString("email"));
        conducteur.setMotDePasse(rs.getString("mot_de_passe"));
        conducteur.setTelephone(rs.getString("telephone"));
        conducteur.setDateInscription(rs.getDate("date_inscription"));
        conducteur.setEstActif(rs.getBoolean("est_actif"));
        conducteur.setMarqueVehicule(rs.getString("marque_vehicule"));
        conducteur.setModeleVehicule(rs.getString("modele_vehicule"));
        conducteur.setImmatriculation(rs.getString("immatriculation"));
        conducteur.setNombrePlacesVehicule(rs.getInt("nombre_places_vehicule"));
        conducteur.setNoteMoyenne(rs.getDouble("note_moyenne"));
        
        return conducteur;
    }
}
