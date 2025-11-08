package dao;

import models.*;
import java.sql.SQLException;
import java.util.List;
import java.util.Date;

//Interface NotificationDAO
interface NotificationDAO {
 Long create(Notification notification) throws SQLException;
 Notification findById(Long id) throws SQLException;
 List<Notification> findByUtilisateur(Long utilisateurId) throws SQLException;
 List<Notification> findNonLuesByUtilisateur(Long utilisateurId) throws SQLException;
 boolean marquerCommeLue(Long notificationId) throws SQLException;
 boolean marquerToutesCommeLues(Long utilisateurId) throws SQLException;
 int compterNonLues(Long utilisateurId) throws SQLException;
 boolean delete(Long id) throws SQLException;
 int deleteOldNotifications(int jours) throws SQLException;
}
