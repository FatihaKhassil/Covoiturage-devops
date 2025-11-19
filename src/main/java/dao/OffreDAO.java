package dao;

import models.Offre;
import java.sql.SQLException;
import java.util.List;

import com.sun.jdi.connect.spi.Connection;

import java.util.Date;

public interface OffreDAO {
    Long create(Offre offre) throws SQLException;
    Offre findById(Long id) throws SQLException;
    List<Offre> findByConducteur(Long conducteurId) throws SQLException;
    List<Offre> findEnAttente() throws SQLException;
    List<Offre> findValidee() throws SQLException;
    boolean update(Offre offre) throws SQLException;
    boolean updateStatut(Long offreId, String statut) throws SQLException;
    boolean updatePlacesDisponibles(Long offreId, Integer nbPlaces) throws SQLException;
    boolean delete(Long id) throws SQLException;
	List<Offre> findAll() throws SQLException;
    Connection getConnection() throws SQLException;

}