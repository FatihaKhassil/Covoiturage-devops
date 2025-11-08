package dao;

import models.*;
import java.sql.SQLException;
import java.util.List;
import java.util.Date;


// Interface ConducteurDAO
interface ConducteurDAO {
    Long create(Conducteur conducteur) throws SQLException;
    Conducteur findById(Long id) throws SQLException;
    boolean update(Conducteur conducteur) throws SQLException;
    boolean updateNoteMoyenne(Long conducteurId, Double noteMoyenne) throws SQLException;
    boolean delete(Long id) throws SQLException;
    List<Conducteur> findAll() throws SQLException;
}
