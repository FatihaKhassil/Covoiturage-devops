package com.covoiturage.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;
import models.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests unitaires pour la classe Conducteur
 */
@DisplayName("Tests de la classe Conducteur")
class ConducteurTest {

    private Conducteur conducteur;

    @BeforeEach
    void setUp() {
        conducteur = new Conducteur(
            "El Fassi", 
            "Karim", 
            "karim@email.com", 
            "password123", 
            "0654321098",
            "Dacia",
            "Logan",
            "A-12345-B",
            4
        );
    }

    @Nested
    @DisplayName("Tests du constructeur")
    class ConstructeurTests {

        @Test
        @DisplayName("Le constructeur par défaut initialise correctement")
        void testConstructeurParDefaut() {
            Conducteur cond = new Conducteur();
            
            assertNotNull(cond);
            assertEquals(0.0, cond.getNoteMoyenne());
            assertTrue(cond.getEstActif());
        }

        @Test
        @DisplayName("Le constructeur avec paramètres sans ID initialise correctement")
        void testConstructeurSansId() {
            assertEquals("El Fassi", conducteur.getNom());
            assertEquals("Karim", conducteur.getPrenom());
            assertEquals("karim@email.com", conducteur.getEmail());
            assertEquals("0654321098", conducteur.getTelephone());
            assertEquals("Dacia", conducteur.getMarqueVehicule());
            assertEquals("Logan", conducteur.getModeleVehicule());
            assertEquals("A-12345-B", conducteur.getImmatriculation());
            assertEquals(4, conducteur.getNombrePlacesVehicule());
            assertEquals(0.0, conducteur.getNoteMoyenne());
        }

        @Test
        @DisplayName("Le constructeur complet avec ID initialise correctement")
        void testConstructeurComplet() {
            Conducteur cond = new Conducteur(
                100L, "Alami", "Sara", "sara@email.com", "pass", "0612345678",
                "Renault", "Clio", "B-98765-C", 3, 4.5
            );
            
            assertEquals(100L, cond.getIdConducteur());
            assertEquals("Alami", cond.getNom());
            assertEquals("Renault", cond.getMarqueVehicule());
            assertEquals(4.5, cond.getNoteMoyenne());
        }

        @Test
        @DisplayName("La note moyenne est 0.0 si null dans le constructeur complet")
        void testNoteMoyenneNullDansConstructeur() {
            Conducteur cond = new Conducteur(
                1L, "Test", "Test", "test@test.com", "pass", "0612345678",
                "Peugeot", "208", "C-11111-D", 4, null
            );
            
            assertEquals(0.0, cond.getNoteMoyenne());
        }
    }

    @Nested
    @DisplayName("Tests de getId")
    class GetIdTests {

        @Test
        @DisplayName("getId retourne idConducteur si défini")
        void testGetIdAvecIdConducteur() {
            conducteur.setIdConducteur(50L);
            assertEquals(50L, conducteur.getId());
        }

        @Test
        @DisplayName("getId retourne idUtilisateur si idConducteur est null")
        void testGetIdAvecIdUtilisateur() {
            conducteur.setIdUtilisateur(75L);
            assertEquals(75L, conducteur.getId());
        }

        @Test
        @DisplayName("getId privilégie idConducteur sur idUtilisateur")
        void testGetIdPrioriteConducteur() {
            conducteur.setIdConducteur(10L);
            conducteur.setIdUtilisateur(20L);
            
            // idConducteur doit être retourné en priorité
            assertEquals(10L, conducteur.getId());
        }
    }

    @Nested
    @DisplayName("Tests de setIdConducteur")
    class SetIdConducteurTests {

        @Test
        @DisplayName("setIdConducteur met à jour aussi idUtilisateur")
        void testSetIdConducteurMajIdUtilisateur() {
            conducteur.setIdConducteur(100L);
            
            assertEquals(100L, conducteur.getIdConducteur());
            assertEquals(100L, conducteur.getIdUtilisateur());
        }

        @Test
        @DisplayName("setIdConducteur avec null ne met pas à jour idUtilisateur")
        void testSetIdConducteurNull() {
            conducteur.setIdUtilisateur(50L);
            conducteur.setIdConducteur(null);
            
            assertNull(conducteur.getIdConducteur());
            // idUtilisateur devrait rester inchangé
            assertEquals(50L, conducteur.getIdUtilisateur());
        }
    }

    @Nested
    @DisplayName("Tests des getters et setters du véhicule")
    class GettersSettersVehiculeTests {

        @Test
        @DisplayName("setMarqueVehicule et getMarqueVehicule fonctionnent correctement")
        void testMarqueVehicule() {
            conducteur.setMarqueVehicule("Toyota");
            assertEquals("Toyota", conducteur.getMarqueVehicule());
        }

        @Test
        @DisplayName("setModeleVehicule et getModeleVehicule fonctionnent correctement")
        void testModeleVehicule() {
            conducteur.setModeleVehicule("Corolla");
            assertEquals("Corolla", conducteur.getModeleVehicule());
        }

        @Test
        @DisplayName("setImmatriculation et getImmatriculation fonctionnent correctement")
        void testImmatriculation() {
            conducteur.setImmatriculation("D-55555-E");
            assertEquals("D-55555-E", conducteur.getImmatriculation());
        }

        @Test
        @DisplayName("setNombrePlacesVehicule et getNombrePlacesVehicule fonctionnent correctement")
        void testNombrePlacesVehicule() {
            conducteur.setNombrePlacesVehicule(5);
            assertEquals(5, conducteur.getNombrePlacesVehicule());
        }
    }

    @Nested
    @DisplayName("Tests de la note moyenne")
    class NoteMoyenneTests {

        @Test
        @DisplayName("setNoteMoyenne et getNoteMoyenne fonctionnent correctement")
        void testSetGetNoteMoyenne() {
            conducteur.setNoteMoyenne(4.7);
            assertEquals(4.7, conducteur.getNoteMoyenne());
        }

        @Test
        @DisplayName("calculerNoteMoyenne retourne la note moyenne actuelle")
        void testCalculerNoteMoyenne() {
            conducteur.setNoteMoyenne(3.8);
            assertEquals(3.8, conducteur.calculerNoteMoyenne());
        }

        @Test
        @DisplayName("La note moyenne initiale est 0.0")
        void testNoteMoyenneInitiale() {
            Conducteur nouveauCond = new Conducteur();
            assertEquals(0.0, nouveauCond.getNoteMoyenne());
        }

        @Test
        @DisplayName("La note moyenne peut être 5.0")
        void testNoteMoyenneMaximale() {
            conducteur.setNoteMoyenne(5.0);
            assertEquals(5.0, conducteur.getNoteMoyenne());
        }
    }

    @Nested
    @DisplayName("Tests des méthodes métier")
    class MethodesMetierTests {

        @Test
        @DisplayName("publierOffre retourne l'offre passée en paramètre")
        void testPublierOffre() {
            Offre offre = new Offre();
            offre.setIdOffre(1L);
            
            Offre resultat = conducteur.publierOffre(offre);
            
            assertNotNull(resultat);
            assertEquals(offre, resultat);
            assertEquals(1L, resultat.getIdOffre());
        }

        @Test
        @DisplayName("annulerOffre retourne true")
        void testAnnulerOffre() {
            Boolean resultat = conducteur.annulerOffre(1L);
            assertTrue(resultat);
        }

        @Test
        @DisplayName("consulterReservations retourne null (non implémenté)")
        void testConsulterReservations() {
            // Note: Cette méthode devrait être implémentée avec un DAO
            assertNull(conducteur.consulterReservations());
        }

        @Test
        @DisplayName("getEvaluations retourne null (non implémenté)")
        void testGetEvaluations() {
            // Note: Cette méthode devrait être implémentée avec un DAO
            assertNull(conducteur.getEvaluations());
        }

        @Test
        @DisplayName("validerTrajet ne lève pas d'exception")
        void testValiderTrajet() {
            // Ne devrait pas lever d'exception
            assertDoesNotThrow(() -> conducteur.validerTrajet(1L));
        }
    }

    @Nested
    @DisplayName("Tests de equals et hashCode")
    class EqualsHashCodeTests {

        @Test
        @DisplayName("Deux conducteurs avec le même ID sont égaux")
        void testEqualsMemeId() {
            Conducteur cond1 = new Conducteur();
            cond1.setIdConducteur(1L);
            
            Conducteur cond2 = new Conducteur();
            cond2.setIdConducteur(1L);
            
            assertEquals(cond1, cond2);
        }

        @Test
        @DisplayName("Deux conducteurs avec des IDs différents ne sont pas égaux")
        void testEqualsIdsDifferents() {
            Conducteur cond1 = new Conducteur();
            cond1.setIdConducteur(1L);
            
            Conducteur cond2 = new Conducteur();
            cond2.setIdConducteur(2L);
            
            assertNotEquals(cond1, cond2);
        }

        @Test
        @DisplayName("Un conducteur est égal à lui-même")
        void testEqualsLuiMeme() {
            assertEquals(conducteur, conducteur);
        }

        @Test
        @DisplayName("Un conducteur n'est pas égal à null")
        void testEqualsNull() {
            assertNotEquals(conducteur, null);
        }

        @Test
        @DisplayName("Un conducteur n'est pas égal à un objet d'un autre type")
        void testEqualsAutreType() {
            assertNotEquals(conducteur, "une chaîne");
        }

        @Test
        @DisplayName("hashCode est cohérent avec equals")
        void testHashCodeCoherent() {
            Conducteur cond1 = new Conducteur();
            cond1.setIdConducteur(1L);
            
            Conducteur cond2 = new Conducteur();
            cond2.setIdConducteur(1L);
            
            assertEquals(cond1.hashCode(), cond2.hashCode());
        }

        @Test
        @DisplayName("hashCode retourne 0 si ID est null")
        void testHashCodeIdNull() {
            Conducteur cond = new Conducteur();
            assertEquals(0, cond.hashCode());
        }
    }

    @Nested
    @DisplayName("Tests de toString")
    class ToStringTests {

        @Test
        @DisplayName("toString contient les informations principales")
        void testToStringComplet() {
            conducteur.setIdConducteur(10L);
            String result = conducteur.toString();
            
            assertTrue(result.contains("idConducteur=10"));
            assertTrue(result.contains("El Fassi"));
            assertTrue(result.contains("Karim"));
            assertTrue(result.contains("Dacia"));
            assertTrue(result.contains("Logan"));
            assertTrue(result.contains("A-12345-B"));
        }

        @Test
        @DisplayName("toString ne lève pas d'exception avec des valeurs null")
        void testToStringAvecNull() {
            Conducteur cond = new Conducteur();
            assertDoesNotThrow(() -> cond.toString());
        }
    }

    @Nested
    @DisplayName("Tests de cas limites")
    class CasLimitesTests {

        @Test
        @DisplayName("Peut avoir 1 seule place dans le véhicule")
        void testUneSeulePlace() {
            conducteur.setNombrePlacesVehicule(1);
            assertEquals(1, conducteur.getNombrePlacesVehicule());
        }

        @Test
        @DisplayName("Peut avoir un grand nombre de places (minibus)")
        void testNombreusesPlaces() {
            conducteur.setNombrePlacesVehicule(15);
            assertEquals(15, conducteur.getNombrePlacesVehicule());
        }

        @Test
        @DisplayName("Immatriculation peut contenir différents formats")
        void testFormatsImmatriculation() {
            conducteur.setImmatriculation("12345-A-67");
            assertEquals("12345-A-67", conducteur.getImmatriculation());
            
            conducteur.setImmatriculation("WW-123456");
            assertEquals("WW-123456", conducteur.getImmatriculation());
        }

        @Test
        @DisplayName("Note moyenne peut être un décimal")
        void testNoteMoyenneDecimale() {
            conducteur.setNoteMoyenne(4.567);
            assertEquals(4.567, conducteur.getNoteMoyenne(), 0.001);
        }
    }

    @Nested
    @DisplayName("Tests d'héritage")
    class HeritageTests {

        @Test
        @DisplayName("Conducteur hérite correctement des propriétés d'Utilisateur")
        void testHeritageUtilisateur() {
            // Test des méthodes héritées
            assertEquals("El Fassi", conducteur.getNom());
            assertEquals("Karim", conducteur.getPrenom());
            assertEquals("karim@email.com", conducteur.getEmail());
            assertTrue(conducteur.getEstActif());
            assertNotNull(conducteur.getDateInscription());
        }

        @Test
        @DisplayName("seConnecter fonctionne pour un Conducteur")
        void testConnexionConducteur() {
            assertTrue(conducteur.seConnecter("karim@email.com", "password123"));
            assertFalse(conducteur.seConnecter("karim@email.com", "mauvais"));
        }

        @Test
        @DisplayName("Les méthodes d'Utilisateur sont accessibles")
        void testMethodesUtilisateurAccessibles() {
            conducteur.setPhotoProfil("images/karim.jpg");
            assertEquals("images/karim.jpg", conducteur.getPhotoProfil());
            
            String initiales = conducteur.getInitiales();
            assertEquals("KE", initiales);
        }
    }

    @Nested
    @DisplayName("Tests de scénarios réels")
    class ScenariosReelsTests {

        @Test
        @DisplayName("Scénario complet : inscription → publication d'offre → évaluation")
        void testScenarioComplet() {
            // 1. Nouveau conducteur s'inscrit
            Conducteur nouveauCond = new Conducteur(
                "Ziani", "Youssef", "youssef@email.com", "pass", "0661122334",
                "Hyundai", "i20", "E-77777-F", 3
            );
            
            assertEquals(0.0, nouveauCond.getNoteMoyenne());
            assertTrue(nouveauCond.getEstActif());
            
            // 2. Le conducteur est enregistré avec un ID
            nouveauCond.setIdConducteur(25L);
            assertEquals(25L, nouveauCond.getId());
            
            // 3. Il publie une offre
            Offre offre = new Offre();
            offre.setIdConducteur(25L);
            Offre offrePubliee = nouveauCond.publierOffre(offre);
            assertNotNull(offrePubliee);
            
            // 4. Après quelques trajets, il reçoit des évaluations
            nouveauCond.setNoteMoyenne(4.3);
            assertEquals(4.3, nouveauCond.getNoteMoyenne());
        }

        @Test
        @DisplayName("Scénario de modification du véhicule")
        void testChangementVehicule() {
            // Véhicule initial
            assertEquals("Dacia", conducteur.getMarqueVehicule());
            assertEquals("Logan", conducteur.getModeleVehicule());
            assertEquals(4, conducteur.getNombrePlacesVehicule());
            
            // Changement de véhicule
            conducteur.setMarqueVehicule("Volkswagen");
            conducteur.setModeleVehicule("Golf");
            conducteur.setImmatriculation("F-99999-G");
            conducteur.setNombrePlacesVehicule(5);
            
            assertEquals("Volkswagen", conducteur.getMarqueVehicule());
            assertEquals("Golf", conducteur.getModeleVehicule());
            assertEquals("F-99999-G", conducteur.getImmatriculation());
            assertEquals(5, conducteur.getNombrePlacesVehicule());
        }
    }
}
