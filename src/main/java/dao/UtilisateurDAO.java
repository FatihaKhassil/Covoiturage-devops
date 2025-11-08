package dao;

import models.*;
import java.sql.SQLException;
import java.util.List;
import java.util.Date;

// Interface UtilisateurDAO
public interface UtilisateurDAO {
    Long create(Utilisateur utilisateur) throws SQLException;
    Utilisateur findById(Long id) throws SQLException;
    Utilisateur findByEmail(String email) throws SQLException;
    Utilisateur authenticate(String email, String motDePasse) throws SQLException;
    boolean update(Utilisateur utilisateur) throws SQLException;
    boolean delete(Long id) throws SQLException;
    List<Utilisateur> findAll() throws SQLException;
}
