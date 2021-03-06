package DAOs;

import model.CarDetail;
import model.Transportador;
import play.api.db.Database;

import javax.xml.crypto.dsig.TransformService;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PersonasDAO {

    private Database db;
    private Connection conn;

    public PersonasDAO(Database db, Connection conn) throws SQLException {
        this.db = db;
        this.conn = conn;
    }

    public int getPersonaIdByUsername (String username) throws SQLException{

        int id=-1;
        PreparedStatement preparedStatementId;
        String idStatement = "select ID_PERSONA from PERSONAS where EMAIL=?";

        try {
            preparedStatementId = conn.prepareStatement(idStatement);
            preparedStatementId.setString(1, username);

            ResultSet result = preparedStatementId.executeQuery();

            while (result.next()){
               id = result.getInt("ID_PERSONA");
            }

        } catch (SQLException e) {
            return -1;
        }

        return id;
    }

    public List<Transportador> getAllTransportadores() throws SQLException{
        List<Transportador> transportadores = new ArrayList<>();
        PreparedStatement preparedStatement;
        String statement = "select p.ID_PERSONA, p.nombre, p.apellido, p.calificacion, t.ESTADO, l.LATITUD, l.LONGITUD,l.FECHA_ACTUALIZACION, v.MARCA,v.REFERENCIA, v.MODELO, v.PLACA, vt.NOMBRE as tipo \n" +
                "from personas p \n" +
                "INNER JOIN Localizaciones l on p.ID_PERSONA = l.ID_LOCALIZACION\n" +
                "INNER JOIN TRANSPORTADORES t on p.ID_PERSONA = t.ID_TRANSPORTADOR \n" +
                "INNER JOIN TRANSP_VEHICULOS tv on t.ID_TRANSPORTADOR=tv.ID_TRANSP \n" +
                "INNER JOIN vehiculos v on tv.ID_VEHICULO=v.ID_VEHICULO\n" +
                "INNER JOIN TIPOS_VEHICULO vt on v.TIPO=vt.ID_TIPO";

        try {
            preparedStatement = conn.prepareStatement(statement);
            ResultSet result = preparedStatement.executeQuery();
            transportadores = generateTransp(result);
        } catch (SQLException e) {
            throw new SQLException(e.getMessage(), e);
        }

        return transportadores;
    }

    public Transportador getTransportadorById (int idTransporter) throws SQLException {
        List<Transportador> trans = getAllTransportadores();
        for (Transportador t: trans ) {
            if (t.id == idTransporter){
                return t;
            }
        }
        return new Transportador();
    }

    public List<Transportador> getAllTransportadoresByState(String estado) throws SQLException{
        List<Transportador> transportadores = new ArrayList<>();
        PreparedStatement preparedStatement;
        String statement = "select p.ID_PERSONA, p.nombre, p.apellido, p.calificacion, t.ESTADO, l.LATITUD, l.LONGITUD,l.FECHA_ACTUALIZACION, v.MARCA,v.REFERENCIA, v.MODELO, v.PLACA, vt.NOMBRE as tipo \n" +
                    "from personas p \n" +
                    "INNER JOIN Localizaciones l on p.ID_PERSONA = l.ID_LOCALIZACION\n" +
                    "INNER JOIN TRANSPORTADORES t on p.ID_PERSONA = t.ID_TRANSPORTADOR \n" +
                    "INNER JOIN TRANSP_VEHICULOS tv on t.ID_TRANSPORTADOR=tv.ID_TRANSP \n" +
                    "INNER JOIN vehiculos v on tv.ID_VEHICULO=v.ID_VEHICULO\n" +
                    "INNER JOIN TIPOS_VEHICULO vt on v.TIPO=vt.ID_TIPO \n" +
                    "WHERE t.ESTADO = ? ";


        try {
            preparedStatement = conn.prepareStatement(statement);
            preparedStatement.setString(1, estado);
            ResultSet result = preparedStatement.executeQuery();

            transportadores = generateTransp(result);

        } catch (SQLException e) {
            throw new SQLException(e.getMessage(), e);
        }

        return transportadores;
    }
	
    // Función para añadir un vehiculo a un username en la BD
    public boolean addNewVehicle(CarDetail carDetail, int id_user){

        return true;
    }

    public List<Transportador> generateTransp(ResultSet result) throws SQLException{
        List<Transportador> transportadores = new ArrayList<>();
        while (result.next()){
            Transportador trans = new Transportador();
            trans.id = result.getInt("ID_PERSONA");
            trans.name = result.getString("NOMBRE") + " " + result.getString("APELLIDO");
            trans.estado = result.getString("ESTADO");
            trans.calificacion = result.getDouble("CALIFICACION");
            trans.pos.lat = result.getDouble("LATITUD");
            trans.pos.lng = result.getDouble("LONGITUD");
            trans.carDetail.typeDesc = result.getString("TIPO");
            trans.carDetail.placa = result.getString("PLACA");
            trans.carDetail.model = result.getInt("MODELO");
            trans.carDetail.reference = result.getString("REFERENCIA");
            trans.carDetail.marca = result.getString("MARCA");

            transportadores.add(trans);
        }
        return transportadores;
    }

    public List<CarDetail> getVehiclesByTransporter(int id_transporter) throws SQLException {
        List<CarDetail> vehicles = new ArrayList<>();
        PreparedStatement preparedStatement;
        String statement = "SELECT v.ID_VEHICULO, v.TIPO, v.MODELO,v.MARCA, v.PLACA, v.REFERENCIA  FROM VEHICULOS v RIGHT OUTER JOIN TRANSP_VEHICULOS tv ON tv.ID_TRANSP = ?";

        try {
            preparedStatement = conn.prepareStatement(statement);
            preparedStatement.setInt(1,id_transporter);
            ResultSet result = preparedStatement.executeQuery();
            while(result.next()){
                CarDetail carDetail = new CarDetail();
                carDetail.placa = result.getString("PLACA");
                carDetail.reference = result.getString("REFERENCIA");
                carDetail.typeDesc = result.getString("TIPO");
                carDetail.model = result.getInt("MODELO");
                carDetail.marca = result.getString("MARCA");
                vehicles.add(carDetail);
            }

        } catch(SQLException e){
            throw new SQLException(e.getMessage(), e);
        }

        return vehicles;
    }
}
