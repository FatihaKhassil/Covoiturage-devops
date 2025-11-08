package dao;
import models.*;
import java.sql.SQLException;
import java.util.List;
import java.util.Date;

//Interface ReservationDAO
public interface ReservationDAO {
 Long create(Reservation reservation) throws SQLException;
 Reservation findById(Long id) throws SQLException;
 List<Reservation> findByPassager(Long passagerId) throws SQLException;
 List<Reservation> findByOffre(Long offreId) throws SQLException;
 boolean update(Reservation reservation) throws SQLException;
 boolean updateStatut(Long reservationId, String statut) throws SQLException;
 boolean delete(Long id) throws SQLException;
}