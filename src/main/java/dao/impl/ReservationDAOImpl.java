package dao.impl;

import dao.ReservationDAO;
import dao.EvaluationDAO;
import models.Reservation;
import models.Offre;
import models.Passager;
import models.Conducteur;
import models.Evaluation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAOImpl implements ReservationDAO {
    private Connection connection;
    private EvaluationDAO evaluationDAO;
    
    public ReservationDAOImpl(Connection connection) {
        this.connection = connection;
        this.evaluationDAO = new EvaluationDAOImpl(connection); // Initialiser EvaluationDAO
    }
    
    @Override
    public Long create(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO reservation (id_offre, id_passager, nombre_places, " +
                     "prix_total, statut, date_reservation, message_passager) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, reservation.getOffre().getIdOffre());
            stmt.setLong(2, reservation.getPassager().getIdUtilisateur());
            stmt.setInt(3, reservation.getNombrePlaces());
            stmt.setDouble(4, reservation.getPrixTotal());
            stmt.setString(5, reservation.getStatut());
            stmt.setTimestamp(6, new Timestamp(reservation.getDateReservation().getTime()));
            stmt.setString(7, reservation.getMessagePassager());
            
            stmt.executeUpdate();
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return null;
    }
    
    @Override
    public Reservation findById(Long id) throws SQLException {
        String sql = "SELECT r.*, " +
                     "o.id_conducteur, o.ville_depart, o.ville_arrivee, " +
                     "o.date_depart, o.heure_depart, o.prix_par_place, " +
                     "o.places_disponibles, o.places_totales, " +
                     "o.statut as offre_statut, o.date_publication, o.commentaire, " +
                     "p.note_moyenne as passager_note, " +
                     "up.nom as passager_nom, up.prenom as passager_prenom, up.email as passager_email, " +
                     "up.telephone as passager_telephone, up.date_inscription as passager_date_inscription, " +
                     "c.marque_vehicule, c.modele_vehicule, c.immatriculation, c.nombre_places_vehicule, " +
                     "c.note_moyenne as conducteur_note, " +
                     "uc.nom as conducteur_nom, uc.prenom as conducteur_prenom, uc.email as conducteur_email, " +
                     "uc.telephone as conducteur_telephone, uc.date_inscription as conducteur_date_inscription " +
                     "FROM reservation r " +
                     "JOIN offre o ON r.id_offre = o.id_offre " +
                     "JOIN passager p ON r.id_passager = p.id_passager " +
                     "JOIN utilisateur up ON p.id_passager = up.id_utilisateur " +
                     "JOIN conducteur c ON o.id_conducteur = c.id_conducteur " +
                     "JOIN utilisateur uc ON c.id_conducteur = uc.id_utilisateur " +
                     "WHERE r.id_reservation = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Reservation res = mapResultSetToReservation(rs);
                
                // ✅ VÉRIFIER SI DÉJÀ ÉVALUÉE
                if ("TERMINEE".equals(res.getStatut())) {
                    boolean dejaEvalue = evaluationDAO.existsForOffre(
                        res.getOffre().getIdOffre(), 
                        res.getPassager().getIdUtilisateur(), 
                        res.getOffre().getConducteur().getIdUtilisateur()
                    );
                    res.setEstEvalue(dejaEvalue);
                    
                    if (dejaEvalue) {
                        Evaluation evaluation = evaluationDAO.findByOffreAndEvaluateur(
                            res.getOffre().getIdOffre(), 
                            res.getPassager().getIdUtilisateur()
                        );
                        res.setEvaluation(evaluation);
                    }
                }
                
                return res;
            }
        }
        return null;
    }
    
    @Override
    public List<Reservation> findByConducteur(Long conducteurId) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        
        String sql = "SELECT r.*, " +
                     "o.id_offre, o.id_conducteur, o.ville_depart, o.ville_arrivee, " +
                     "o.date_depart, o.heure_depart, o.prix_par_place, " +
                     "o.places_disponibles, o.places_totales, " +
                     "o.statut as offre_statut, o.date_publication, o.commentaire, " +
                     "p.note_moyenne as passager_note, " +
                     "up.nom as passager_nom, up.prenom as passager_prenom, " +
                     "up.email as passager_email, up.telephone as passager_telephone, " +
                     "up.date_inscription as passager_date_inscription, " +
                     "c.marque_vehicule, c.modele_vehicule, c.immatriculation, " +
                     "c.nombre_places_vehicule, c.note_moyenne as conducteur_note, " +
                     "uc.nom as conducteur_nom, uc.prenom as conducteur_prenom, " +
                     "uc.email as conducteur_email, uc.telephone as conducteur_telephone, " +
                     "uc.date_inscription as conducteur_date_inscription " +
                     "FROM reservation r " +
                     "JOIN offre o ON r.id_offre = o.id_offre " +
                     "JOIN passager p ON r.id_passager = p.id_passager " +
                     "JOIN utilisateur up ON p.id_passager = up.id_utilisateur " +
                     "JOIN conducteur c ON o.id_conducteur = c.id_conducteur " +
                     "JOIN utilisateur uc ON c.id_conducteur = uc.id_utilisateur " +
                     "WHERE o.id_conducteur = ? " +
                     "ORDER BY r.date_reservation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, conducteurId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Reservation res = mapResultSetToReservation(rs);
                reservations.add(res);
            }
        }
        return reservations;
    }
    
    @Override
    public List<Reservation> findByPassager(Long passagerId) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        
        String sql = "SELECT r.*, " +
                     "o.id_offre, o.id_conducteur, o.ville_depart, o.ville_arrivee, " +
                     "o.date_depart, o.heure_depart, o.prix_par_place, " +
                     "o.places_disponibles, o.places_totales, " +
                     "o.statut as offre_statut, o.date_publication, o.commentaire, " +
                     "p.note_moyenne as passager_note, " +
                     "up.nom as passager_nom, up.prenom as passager_prenom, " +
                     "up.email as passager_email, up.telephone as passager_telephone, " +
                     "up.date_inscription as passager_date_inscription, " +
                     "c.marque_vehicule, c.modele_vehicule, c.immatriculation, " +
                     "c.nombre_places_vehicule, c.note_moyenne as conducteur_note, " +
                     "uc.nom as conducteur_nom, uc.prenom as conducteur_prenom, " +
                     "uc.email as conducteur_email, uc.telephone as conducteur_telephone, " +
                     "uc.date_inscription as conducteur_date_inscription " +
                     "FROM reservation r " +
                     "JOIN offre o ON r.id_offre = o.id_offre " +
                     "JOIN passager p ON r.id_passager = p.id_passager " +
                     "JOIN utilisateur up ON p.id_passager = up.id_utilisateur " +
                     "JOIN conducteur c ON o.id_conducteur = c.id_conducteur " +
                     "JOIN utilisateur uc ON c.id_conducteur = uc.id_utilisateur " +
                     "WHERE r.id_passager = ? " +
                     "ORDER BY r.date_reservation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, passagerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Reservation res = mapResultSetToReservation(rs);
                
                // ✅ VÉRIFIER SI DÉJÀ ÉVALUÉE (seulement pour les trajets terminés)
                if ("TERMINEE".equals(res.getStatut())) {
                    boolean dejaEvalue = evaluationDAO.existsForOffre(
                        res.getOffre().getIdOffre(), 
                        passagerId, 
                        res.getOffre().getConducteur().getIdUtilisateur()
                    );
                    res.setEstEvalue(dejaEvalue);
                    
                    if (dejaEvalue) {
                        Evaluation evaluation = evaluationDAO.findByOffreAndEvaluateur(
                            res.getOffre().getIdOffre(), 
                            passagerId
                        );
                        res.setEvaluation(evaluation);
                    }
                } else {
                    res.setEstEvalue(false); // Pas évaluable si pas terminé
                }
                
                reservations.add(res);
            }
        }
        return reservations;
    }
    
    @Override
    public List<Reservation> findByOffre(Long offreId) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        
        String sql = "SELECT r.*, " +
                     "o.id_conducteur, o.ville_depart, o.ville_arrivee, " +
                     "o.date_depart, o.heure_depart, o.prix_par_place, " +
                     "o.places_disponibles, o.places_totales, " +
                     "o.statut as offre_statut, o.date_publication, o.commentaire, " +
                     "p.note_moyenne as passager_note, " +
                     "up.nom as passager_nom, up.prenom as passager_prenom, up.email as passager_email, " +
                     "up.telephone as passager_telephone, up.date_inscription as passager_date_inscription, " +
                     "c.marque_vehicule, c.modele_vehicule, c.immatriculation, c.nombre_places_vehicule, " +
                     "c.note_moyenne as conducteur_note, " +
                     "uc.nom as conducteur_nom, uc.prenom as conducteur_prenom, uc.email as conducteur_email, " +
                     "uc.telephone as conducteur_telephone, uc.date_inscription as conducteur_date_inscription " +
                     "FROM reservation r " +
                     "JOIN offre o ON r.id_offre = o.id_offre " +
                     "JOIN passager p ON r.id_passager = p.id_passager " +
                     "JOIN utilisateur up ON p.id_passager = up.id_utilisateur " +
                     "JOIN conducteur c ON o.id_conducteur = c.id_conducteur " +
                     "JOIN utilisateur uc ON c.id_conducteur = uc.id_utilisateur " +
                     "WHERE r.id_offre = ? " +
                     "ORDER BY r.date_reservation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, offreId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        }
        return reservations;
    }
    
    public List<Reservation> findAll() throws SQLException {
        return new ArrayList<>();
    }
    
    @Override
    public boolean update(Reservation reservation) throws SQLException {
        String sql = "UPDATE reservation SET nombre_places = ?, prix_total = ?, statut = ?, " +
                     "message_passager = ? WHERE id_reservation = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reservation.getNombrePlaces());
            stmt.setDouble(2, reservation.getPrixTotal());
            stmt.setString(3, reservation.getStatut());
            stmt.setString(4, reservation.getMessagePassager());
            stmt.setLong(5, reservation.getIdReservation());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean updateStatut(Long reservationId, String statut) throws SQLException {
        String sql = "UPDATE reservation SET statut = ? WHERE id_reservation = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, statut);
            stmt.setLong(2, reservationId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM reservation WHERE id_reservation = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setIdReservation(rs.getLong("id_reservation"));
        reservation.setNombrePlaces(rs.getInt("nombre_places"));
        reservation.setPrixTotal(rs.getDouble("prix_total"));
        reservation.setStatut(rs.getString("statut"));
        reservation.setDateReservation(rs.getTimestamp("date_reservation"));
        
        try {
            reservation.setMessagePassager(rs.getString("message_passager"));
        } catch (SQLException e) {
            reservation.setMessagePassager("");
        }
        
        // Mapper le passager
        Passager passager = new Passager();
        passager.setIdUtilisateur(rs.getLong("id_passager"));
        passager.setNom(rs.getString("passager_nom"));
        passager.setPrenom(rs.getString("passager_prenom"));
        passager.setEmail(rs.getString("passager_email"));
        passager.setTelephone(rs.getString("passager_telephone"));
        passager.setDateInscription(rs.getDate("passager_date_inscription"));
        try {
            passager.setNoteMoyenne(rs.getDouble("passager_note"));
        } catch (SQLException e) {
            passager.setNoteMoyenne(0.0);
        }
        reservation.setPassager(passager);

        // Mapper le conducteur
        Conducteur conducteur = new Conducteur();
        conducteur.setIdUtilisateur(rs.getLong("id_conducteur"));
        conducteur.setNom(rs.getString("conducteur_nom"));
        conducteur.setPrenom(rs.getString("conducteur_prenom"));
        conducteur.setEmail(rs.getString("conducteur_email"));
        conducteur.setTelephone(rs.getString("conducteur_telephone"));
        conducteur.setDateInscription(rs.getDate("conducteur_date_inscription"));
        conducteur.setMarqueVehicule(rs.getString("marque_vehicule"));
        conducteur.setModeleVehicule(rs.getString("modele_vehicule"));
        conducteur.setImmatriculation(rs.getString("immatriculation"));
        conducteur.setNombrePlacesVehicule(rs.getInt("nombre_places_vehicule"));
        try {
            conducteur.setNoteMoyenne(rs.getDouble("conducteur_note"));
        } catch (SQLException e) {
            conducteur.setNoteMoyenne(0.0);
        }

        // Mapper l'offre
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
        offre.setStatut(rs.getString("offre_statut"));
        offre.setDatePublication(rs.getDate("date_publication"));
        try {
            offre.setCommentaire(rs.getString("commentaire"));
        } catch (SQLException e) {
            offre.setCommentaire("");
        }
        
        // Associer le conducteur à l'offre
        offre.setConducteur(conducteur);
        reservation.setOffre(offre);

        return reservation;
    }
    
    public int countReservationsByPassager(Long passagerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservation WHERE id_passager = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, passagerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int countReservationsByConducteur(Long conducteurId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservation r " +
                     "JOIN offre o ON r.id_offre = o.id_offre " +
                     "WHERE o.id_conducteur = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, conducteurId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

	@Override
	public List<Reservation> findByConducteurAndStatut(Long id, String string) {
		// TODO Auto-generated method stub
		return null;
	}
}