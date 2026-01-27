package com.covoiturage.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import static org.junit.jupiter.api.Assertions.*;
import models.*;
/**
 * Tests unitaires pour la classe Passager
 */
@DisplayName("Tests de la classe Passager")
class PassagerTest {

    private Passager passager;

    @BeforeEach
    void setUp() {
        passager = new Passager("Bennani", "Fatima", "fatima@email.com", "password123", "0623456789");
    }

    @Nested
    @DisplayName("Tests du constructeur")
    class ConstructeurTests {

        @Test
        @DisplayName("Le constructeur par défaut initialise correctement")
        void testConstructeurParDefaut() {
            Passager pass = new Passager();
            
            assertNotNull(pass);
            assertEquals(0.0, pass.getNoteMoyenne());
            assertTrue(pass.getEstActif());
        }

        @Test
        @DisplayName("Le constructeur avec paramètres initialise correctement")
        void testConstructeurAvecParametres() {
            assertEquals("Bennani", passager.getNom());
            assertEquals("Fatima", passager.getPrenom());
            assertEquals("fatima@email.com", passager.getEmail());
            assertEquals("password123", passager.getMotDePasse());
            assertEquals("0623456789", passager.getTelephone());
            assertEquals(0.0, passager.getNoteMoyenne());
        }

        @Test
        @DisplayName("La note moyenne initiale est 0.0")
        void testNoteMoyenneInitiale() {
            assertEquals(0.0, passager.getNoteMoyenne());
        }
    }

    @Nested
    @DisplayName("Tests de getId")
    class GetIdTests {

        @Test
        @DisplayName("getId retourne idPassager si défini")
        void testGetIdAvecIdPassager() {
            passager.setIdPassager(10L);
            assertEquals(10L, passager.getId());
        }

        @Test
        @DisplayName("getId retourne idUtilisateur si idPassager est null")
        void testGetIdAvecIdUtilisateur() {
            passager.setIdUtilisateur(20L);
            assertEquals(20L, passager.getId());
        }

        @Test
        @DisplayName("getId privilégie idPassager sur idUtilisateur")
        void testGetIdPrioritePassager() {
            passager.setIdPassager(5L);
            passager.setIdUtilisateur(15L);
            
            // idPassager doit être retourné en priorité
            assertEquals(5L, passager.getId());
        }
    }

    @Nested
    @DisplayName("Tests de setIdPassager")
    class SetIdPassagerTests {

        @Test
        @DisplayName("setIdPassager met à jour aussi idUtilisateur")
        void testSetIdPassagerMajIdUtilisateur() {
            passager.setIdPassager(50L);
            
            assertEquals(50L, passager.getIdPassager());
            assertEquals(50L, passager.getIdUtilisateur());
        }

        @Test
        @DisplayName("setIdPassager avec null ne met pas à jour idUtilisateur")
        void testSetIdPassagerNull() {
            passager.setIdUtilisateur(30L);
            passager.setIdPassager(null);
            
            assertNull(passager.getIdPassager());
            // idUtilisateur devrait rester inchangé
            assertEquals(30L, passager.getIdUtilisateur());
        }
    }

    @Nested
    @DisplayName("Tests de la note moyenne")
    class NoteMoyenneTests {

        @Test
        @DisplayName("setNoteMoyenne et getNoteMoyenne fonctionnent correctement")
        void testSetGetNoteMoyenne() {
            passager.setNoteMoyenne(4.2);
            assertEquals(4.2, passager.getNoteMoyenne());
        }

        @Test
        @DisplayName("calculerNoteMoyenne retourne la note moyenne actuelle")
        void testCalculerNoteMoyenne() {
            passager.setNoteMoyenne(3.9);
            assertEquals(3.9, passager.calculerNoteMoyenne());
        }

        @Test
        @DisplayName("La note moyenne peut être 5.0")
        void testNoteMoyenneMaximale() {
            passager.setNoteMoyenne(5.0);
            assertEquals(5.0, passager.getNoteMoyenne());
        }

        @Test
        @DisplayName("La note moyenne peut être un décimal précis")
        void testNoteMoyenneDecimale() {
            passager.setNoteMoyenne(4.678);
            assertEquals(4.678, passager.getNoteMoyenne(), 0.001);
        }
    }

    @Nested
    @DisplayName("Tests des méthodes métier")
    class MethodesMetierTests {

        @Test
        @DisplayName("rechercherOffres retourne null (non implémenté)")
        void testRechercherOffres() {
            // Note: Cette méthode devrait être implémentée avec un DAO
            assertNull(passager.rechercherOffres("Casablanca"));
        }

        @Test
        @DisplayName("reserverPlace retourne null (non implémenté)")
        void testReserverPlace() {
            Offre offre = new Offre();
            // Note: Cette méthode devrait être implémentée avec un DAO
            assertNull(passager.reserverPlace(offre, 2));
        }

        @Test
        @DisplayName("annulerReservation retourne true")
        void testAnnulerReservation() {
            Boolean resultat = passager.annulerReservation(1L);
            assertTrue(resultat);
        }

        @Test
        @DisplayName("consulterHistorique retourne null (non implémenté)")
        void testConsulterHistorique() {
            // Note: Cette méthode devrait être implémentée avec un DAO
            assertNull(passager.consulterHistorique());
        }

        @Test
        @DisplayName("getEvaluations retourne null (non implémenté)")
        void testGetEvaluations() {
            // Note: Cette méthode devrait être implémentée avec un DAO
            assertNull(passager.getEvaluations());
        }
    }

    @Nested
    @DisplayName("Tests de equals et hashCode")
    class EqualsHashCodeTests {

        @Test
        @DisplayName("Deux passagers avec le même ID sont égaux")
        void testEqualsMemeId() {
            Passager pass1 = new Passager();
            pass1.setIdPassager(1L);
            
            Passager pass2 = new Passager();
            pass2.setIdPassager(1L);
            
            assertEquals(pass1, pass2);
        }

        @Test
        @DisplayName("Deux passagers avec des IDs différents ne sont pas égaux")
        void testEqualsIdsDifferents() {
            Passager pass1 = new Passager();
            pass1.setIdPassager(1L);
            
            Passager pass2 = new Passager();
            pass2.setIdPassager(2L);
            
            assertNotEquals(pass1, pass2);
        }

        @Test
        @DisplayName("Un passager est égal à lui-même")
        void testEqualsLuiMeme() {
            assertEquals(passager, passager);
        }

        @Test
        @DisplayName("Un passager n'est pas égal à null")
        void testEqualsNull() {
            assertNotEquals(passager, null);
        }

        @Test
        @DisplayName("Un passager n'est pas égal à un objet d'un autre type")
        void testEqualsAutreType() {
            assertNotEquals(passager, "une chaîne");
        }

        @Test
        @DisplayName("hashCode est cohérent avec equals")
        void testHashCodeCoherent() {
            Passager pass1 = new Passager();
            pass1.setIdPassager(1L);
            
            Passager pass2 = new Passager();
            pass2.setIdPassager(1L);
            
            assertEquals(pass1.hashCode(), pass2.hashCode());
        }

        @Test
        @DisplayName("hashCode retourne 0 si ID est null")
        void testHashCodeIdNull() {
            Passager pass = new Passager();
            assertEquals(0, pass.hashCode());
        }
    }

    @Nested
    @DisplayName("Tests de toString")
    class ToStringTests {

        @Test
        @DisplayName("toString contient les informations principales")
        void testToStringComplet() {
            passager.setIdPassager(25L);
            String result = passager.toString();
            
            assertTrue(result.contains("idPassager=25"));
            assertTrue(result.contains("Bennani"));
            assertTrue(result.contains("Fatima"));
            assertTrue(result.contains("fatima@email.com"));
        }

        @Test
        @DisplayName("toString ne lève pas d'exception avec des valeurs null")
        void testToStringAvecNull() {
            Passager pass = new Passager();
            assertDoesNotThrow(() -> pass.toString());
        }
    }

    @Nested
    @DisplayName("Tests d'héritage")
    class HeritageTests {

        @Test
        @DisplayName("Passager hérite correctement des propriétés d'Utilisateur")
        void testHeritageUtilisateur() {
            // Test des méthodes héritées
            assertEquals("Bennani", passager.getNom());
            assertEquals("Fatima", passager.getPrenom());
            assertEquals("fatima@email.com", passager.getEmail());
            assertTrue(passager.getEstActif());
            assertNotNull(passager.getDateInscription());
        }

        @Test
        @DisplayName("seConnecter fonctionne pour un Passager")
        void testConnexionPassager() {
            assertTrue(passager.seConnecter("fatima@email.com", "password123"));
            assertFalse(passager.seConnecter("fatima@email.com", "mauvais"));
        }

        @Test
        @DisplayName("Les méthodes d'Utilisateur sont accessibles")
        void testMethodesUtilisateurAccessibles() {
            passager.setPhotoProfil("images/fatima.jpg");
            assertEquals("images/fatima.jpg", passager.getPhotoProfil());
            
            String initiales = passager.getInitiales();
            assertEquals("FB", initiales);
        }

        @Test
        @DisplayName("Un passager peut être désactivé")
        void testDesactivationPassager() {
            assertTrue(passager.getEstActif());
            
            passager.setEstActif(false);
            assertFalse(passager.getEstActif());
            
            // Ne peut plus se connecter si inactif
            assertFalse(passager.seConnecter("fatima@email.com", "password123"));
        }
    }

    @Nested
    @DisplayName("Tests de scénarios réels")
    class ScenariosReelsTests {

        @Test
        @DisplayName("Scénario complet : inscription → recherche → réservation → évaluation")
        void testScenarioComplet() {
            // 1. Nouveau passager s'inscrit
            Passager nouveauPass = new Passager(
                "Idrissi", "Amina", "amina@email.com", "pass", "0644556677"
            );
            
            assertEquals(0.0, nouveauPass.getNoteMoyenne());
            assertTrue(nouveauPass.getEstActif());
            
            // 2. Le passager est enregistré avec un ID
            nouveauPass.setIdPassager(100L);
            assertEquals(100L, nouveauPass.getId());
            
            // 3. Il recherche des offres (normalement via DAO)
            assertNull(nouveauPass.rechercherOffres("Casablanca-Rabat"));
            
            // 4. Il annule une réservation
            Boolean annulation = nouveauPass.annulerReservation(1L);
            assertTrue(annulation);
            
            // 5. Après quelques trajets, il reçoit des évaluations
            nouveauPass.setNoteMoyenne(4.6);
            assertEquals(4.6, nouveauPass.getNoteMoyenne());
        }

        @Test
        @DisplayName("Scénario d'évolution de la note moyenne")
        void testEvolutionNoteMoyenne() {
            // Note initiale
            assertEquals(0.0, passager.getNoteMoyenne());
            
            // Après premier trajet
            passager.setNoteMoyenne(4.0);
            assertEquals(4.0, passager.getNoteMoyenne());
            
            // Après plusieurs trajets
            passager.setNoteMoyenne(4.3);
            assertEquals(4.3, passager.getNoteMoyenne());
            
            // Après de nombreux trajets
            passager.setNoteMoyenne(4.5);
            assertEquals(4.5, passager.getNoteMoyenne());
        }

        @Test
        @DisplayName("Scénario de modification du profil")
        void testModificationProfil() {
            // Profil initial
            assertEquals("Bennani", passager.getNom());
            assertEquals("0623456789", passager.getTelephone());
            
            // Modification du téléphone
            passager.setTelephone("0612345678");
            assertEquals("0612345678", passager.getTelephone());
            
            // Ajout d'une photo
            passager.setPhotoProfil("images/fatima-profil.jpg");
            assertEquals("images/fatima-profil.jpg", passager.getPhotoProfil());
        }
    }

    @Nested
    @DisplayName("Tests de cas limites")
    class CasLimitesTests {

        @Test
        @DisplayName("Peut avoir un nom très long")
        void testNomLong() {
            String nomLong = "Bennani-El-Fassi-El-Alaoui";
            passager.setNom(nomLong);
            assertEquals(nomLong, passager.getNom());
        }

        @Test
        @DisplayName("Peut avoir un email avec format spécial")
        void testEmailFormatSpecial() {
            passager.setEmail("fatima.bennani+test@email.co.ma");
            assertEquals("fatima.bennani+test@email.co.ma", passager.getEmail());
        }

        @Test
        @DisplayName("Note moyenne peut être exactement 0.0")
        void testNoteMoyenneZero() {
            passager.setNoteMoyenne(0.0);
            assertEquals(0.0, passager.getNoteMoyenne());
        }

        @Test
        @DisplayName("Téléphone peut contenir des espaces et tirets")
        void testTelephoneAvecFormatage() {
            passager.setTelephone("06-23-45-67-89");
            assertEquals("06-23-45-67-89", passager.getTelephone());
            
            passager.setTelephone("+212 6 23 45 67 89");
            assertEquals("+212 6 23 45 67 89", passager.getTelephone());
        }
    }

    @Nested
    @DisplayName("Tests de validation métier")
    class ValidationMetierTests {

        @Test
        @DisplayName("Un passager doit avoir un email pour se connecter")
        void testConnexionSansEmail() {
            Passager pass = new Passager();
            pass.setMotDePasse("password");
            
            // Ne peut pas se connecter sans email
            assertThrows(NullPointerException.class, () -> {
                pass.seConnecter("test@email.com", "password");
            });
        }

        @Test
        @DisplayName("Un passager actif peut se connecter")
        void testConnexionPassagerActif() {
            assertTrue(passager.getEstActif());
            assertTrue(passager.seConnecter("fatima@email.com", "password123"));
        }

        @Test
        @DisplayName("Un passager inactif ne peut pas se connecter")
        void testConnexionPassagerInactif() {
            passager.setEstActif(false);
            assertFalse(passager.seConnecter("fatima@email.com", "password123"));
        }
    }

    @Nested
    @DisplayName("Tests de comparaison Passager vs Conducteur")
    class ComparaisonAvecConducteurTests {

        @Test
        @DisplayName("Un passager n'est pas un conducteur")
        void testPassagerPasConducteur() {
            Conducteur conducteur = new Conducteur();
            conducteur.setIdConducteur(1L);
            
            passager.setIdPassager(1L);
            
            // Même avec le même ID, ce sont des types différents
            assertNotEquals(passager, conducteur);
        }

        @Test
        @DisplayName("Passager et Conducteur ont des propriétés communes d'Utilisateur")
        void testProprietesCommunes() {
            Conducteur conducteur = new Conducteur(
                "Bennani", "Fatima", "fatima@email.com", "password123", "0623456789",
                "Dacia", "Logan", "A-12345-B", 4
            );
            
            // Même nom, prénom, email mais types différents
            assertEquals(passager.getNom(), conducteur.getNom());
            assertEquals(passager.getPrenom(), conducteur.getPrenom());
            assertEquals(passager.getEmail(), conducteur.getEmail());
            
            // Mais ce ne sont pas les mêmes objets
            assertNotEquals(passager, conducteur);
        }
    }
}