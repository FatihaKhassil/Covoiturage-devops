package dao.impl;

import dao.OffreDAO;
import models.Offre;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;

public class OffreDAOImpl implements OffreDAO {
	private Connection connection;

	public OffreDAOImpl(Connection connection) {
	    this.connection = connection;
	}
    
    @Override
    public Long create(Offre offre) throws SQLException {
        String sql = "INSERT INTO offre (id_conducteur, ville_depart, ville_arrivee, " +
                     "date_depart, heure_depart, prix_par_place, places_disponibles, " +
                     "places_totales, statut, date_publication, commentaire, est_effectuee) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, offre.getIdConducteur());
            stmt.setString(2, offre.getVilleDepart());
            stmt.setString(3, offre.getVilleArrivee());
            stmt.setDate(4, new java.sql.Date(offre.getDateDepart().getTime()));
            stmt.setTime(5, offre.getHeureDepart());
            stmt.setDouble(6, offre.getPrixParPlace());
            stmt.setInt(7, offre.getPlacesDisponibles());
            stmt.setInt(8, offre.getPlacesTotales());
            stmt.setString(9, offre.getStatut());
            stmt.setDate(10, new java.sql.Date(offre.getDatePublication().getTime()));
            stmt.setString(11, offre.getCommentaire());
            stmt.setBoolean(12, offre.getEstEffectuee());
            
            stmt.executeUpdate();
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return null;
    }
    
    @Override
    public Offre findById(Long id) throws SQLException {
        String sql = "SELECT * FROM offre WHERE id_offre = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOffre(rs);
            }
        }
        return null;
    }
    
    @Override
    public List<Offre> findByConducteur(Long conducteurId) throws SQLException {
        List<Offre> offres = new ArrayList<>();
        String sql = "SELECT * FROM offre WHERE id_conducteur = ? ORDER BY date_depart DESC, heure_depart DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, conducteurId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                offres.add(mapResultSetToOffre(rs));
            }
        }
        return offres;
    }
    
    @Override
    public List<Offre> findEnAttente() throws SQLException {
        List<Offre> offres = new ArrayList<>();
        String sql = "SELECT * FROM offre WHERE statut = 'EN_ATTENTE' ORDER BY date_publication DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                offres.add(mapResultSetToOffre(rs));
            }
        }
        return offres;
    }
    
    @Override
    public boolean update(Offre offre) throws SQLException {
        String sql = "UPDATE offre SET ville_depart = ?, ville_arrivee = ?, " +
                     "date_depart = ?, heure_depart = ?, prix_par_place = ?, " +
                     "places_disponibles = ?, places_totales = ?, statut = ?, " +
                     "commentaire = ?, est_effectuee = ? WHERE id_offre = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, offre.getVilleDepart());
            stmt.setString(2, offre.getVilleArrivee());
            stmt.setDate(3, new java.sql.Date(offre.getDateDepart().getTime()));
            stmt.setTime(4, offre.getHeureDepart());
            stmt.setDouble(5, offre.getPrixParPlace());
            stmt.setInt(6, offre.getPlacesDisponibles());
            stmt.setInt(7, offre.getPlacesTotales());
            stmt.setString(8, offre.getStatut());
            stmt.setString(9, offre.getCommentaire());
            stmt.setBoolean(10, offre.getEstEffectuee());
            stmt.setLong(11, offre.getIdOffre());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean updateStatut(Long offreId, String statut) throws SQLException {
        String sql = "UPDATE offre SET statut = ? WHERE id_offre = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, statut);
            stmt.setLong(2, offreId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean updatePlacesDisponibles(Long offreId, Integer nbPlaces) throws SQLException {
        String sql = "UPDATE offre SET places_disponibles = ? WHERE id_offre = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, nbPlaces);
            stmt.setLong(2, offreId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM offre WHERE id_offre = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private Offre mapResultSetToOffre(ResultSet rs) throws SQLException {
        Offre offre = new Offre();
        offre.setIdOffre(rs.getLong("id_offre"));
        offre.setIdConducteur(rs.getLong("id_conducteur"));
        offre.setVilleDepart(rs.getString("ville_depart"));
        offre.setVilleArrivee(rs.getString("ville_arrivee"));
        offre.setDateDepart(rs.getDate("date_depart"));
        offre.setHeureDepart(rs.getTime("heure_depart"));
        offre.setPrixParPlace(rs.getDouble("prix_par_place"));
        offre.setPlacesDisponibles(rs.getInt("places_disponibles"));
        offre.setPlacesTotales(rs.getInt("places_totales"));
        offre.setStatut(rs.getString("statut"));
        offre.setDatePublication(rs.getDate("date_publication"));
        offre.setCommentaire(rs.getString("commentaire"));
        offre.setEstEffectuee(rs.getBoolean("est_effectuee"));
        
        return offre;
    }
}