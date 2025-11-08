package dao;

import models.*;
import java.sql.SQLException;
import java.util.List;
import java.util.Date;

//Interface PassagerDAO
public interface PassagerDAO {
 Long create(Passager passager) throws SQLException;
 Passager findById(Long id) throws SQLException;
 boolean update(Passager passager) throws SQLException;
 boolean updateNoteMoyenne(Long passagerId, Double noteMoyenne) throws SQLException;
 boolean delete(Long id) throws SQLException;
 List<Passager> findAll() throws SQLException;
}