package dao;

import models.*;
import java.sql.SQLException;
import java.util.List;
import java.util.Date;

//Interface AdministrateurDAO
public interface AdministrateurDAO {
 Long create(Administrateur administrateur) throws SQLException;
 Administrateur findById(Long id) throws SQLException;
 boolean delete(Long id) throws SQLException;
 List<Administrateur> findAll() throws SQLException;
}