package com.covoiturage.model;


import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import java.sql.Time;
import java.util.Date;
import java.util.Calendar;

import models.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests unitaires pour la classe Offre
 */
@DisplayName("Tests de la classe Offre")
class OffreTest {

    private Offre offre;
    private Date dateDepart;
    private Time heureDepart;

    @BeforeEach
    void setUp() {
        // Création d'une date future (demain)
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 1);
        dateDepart = cal.getTime();
        
        // Heure de départ : 14h30
        heureDepart = Time.valueOf("14:30:00");
        
        // Création d'une offre de test
        offre = new Offre(1L, "Casablanca", "Rabat", dateDepart, heureDepart, 50.0, 4);
    }

    @Nested
    @DisplayName("Tests du constructeur")
    class ConstructeurTests {

        @Test
        @DisplayName("Le constructeur par défaut initialise correctement")
        void testConstructeurParDefaut() {
            Offre offreVide = new Offre();
            
            assertNotNull(offreVide);
            assertEquals("EN_ATTENTE", offreVide.getStatut());
            assertFalse(offreVide.getEstEffectuee());
            assertNotNull(offreVide.getDatePublication());
        }

        @Test
        @DisplayName("Le constructeur avec paramètres initialise correctement")
        void testConstructeurAvecParametres() {
            assertEquals(1L, offre.getIdConducteur());
            assertEquals("Casablanca", offre.getVilleDepart());
            assertEquals("Rabat", offre.getVilleArrivee());
            assertEquals(dateDepart, offre.getDateDepart());
            assertEquals(heureDepart, offre.getHeureDepart());
            assertEquals(50.0, offre.getPrixParPlace());
            assertEquals(4, offre.getPlacesTotales());
            assertEquals(4, offre.getPlacesDisponibles());
            assertEquals("EN_ATTENTE", offre.getStatut());
            assertFalse(offre.getEstEffectuee());
        }

        @Test
        @DisplayName("Les places disponibles égalent les places totales à la création")
        void testPlacesDisponiblesInitiales() {
            assertEquals(offre.getPlacesTotales(), offre.getPlacesDisponibles());
        }
    }

    @Nested
    @DisplayName("Tests de verifierDisponibilite")
    class VerifierDisponibiliteTests {

        @Test
        @DisplayName("Retourne true si places demandées <= places disponibles")
        void testDisponibiliteOk() {
            assertTrue(offre.verifierDisponibilite(2));
            assertTrue(offre.verifierDisponibilite(4));
        }

        @Test
        @DisplayName("Retourne false si places demandées > places disponibles")
        void testDisponibiliteInsuffisante() {
            assertFalse(offre.verifierDisponibilite(5));
        }

        @Test
        @DisplayName("Retourne false si places demandées est null")
        void testDisponibiliteNull() {
            assertFalse(offre.verifierDisponibilite(null));
        }

        @Test
        @DisplayName("Retourne false si places demandées <= 0")
        void testDisponibiliteNegativeOuZero() {
            assertFalse(offre.verifierDisponibilite(0));
            assertFalse(offre.verifierDisponibilite(-1));
        }

        @Test
        @DisplayName("Retourne false si plus de places disponibles")
        void testAucunePlaceDisponible() {
            offre.setPlacesDisponibles(0);
            assertFalse(offre.verifierDisponibilite(1));
        }
    }

    @Nested
    @DisplayName("Tests de mettreAJourPlaces")
    class MettreAJourPlacesTests {

        @Test
        @DisplayName("Les places disponibles diminuent correctement")
        void testDiminutionPlaces() {
            int placesInitiales = offre.getPlacesDisponibles();
            offre.mettreAJourPlaces(2);
            
            assertEquals(placesInitiales - 2, offre.getPlacesDisponibles());
            assertEquals(2, offre.getPlacesDisponibles());
        }

        @Test
        @DisplayName("Peut réserver toutes les places")
        void testReserverToutesLesPlaces() {
            offre.mettreAJourPlaces(4);
            assertEquals(0, offre.getPlacesDisponibles());
        }

        @Test
        @DisplayName("Les places peuvent devenir négatives (à gérer par la logique métier)")
        void testPlacesNegatives() {
            offre.mettreAJourPlaces(5);
            assertEquals(-1, offre.getPlacesDisponibles());
            // Note: Dans un vrai système, cette situation devrait être empêchée en amont
        }
    }

    @Nested
    @DisplayName("Tests de calculerRevenuTotal")
    class CalculerRevenuTotalTests {

        @Test
        @DisplayName("Calcule correctement le revenu sans réservation")
        void testRevenuSansReservation() {
            Double revenu = offre.calculerRevenuTotal();
            assertEquals(0.0, revenu);
        }

        @Test
        @DisplayName("Calcule correctement le revenu avec 2 places réservées")
        void testRevenuAvec2Places() {
            offre.mettreAJourPlaces(2);
            Double revenu = offre.calculerRevenuTotal();
            
            // 2 places × 50 MAD = 100 MAD
            assertEquals(100.0, revenu);
        }

        @Test
        @DisplayName("Calcule correctement le revenu avec toutes les places réservées")
        void testRevenuToutesPlaces() {
            offre.mettreAJourPlaces(4);
            Double revenu = offre.calculerRevenuTotal();
            
            // 4 places × 50 MAD = 200 MAD
            assertEquals(200.0, revenu);
        }

        @Test
        @DisplayName("Le revenu est correct avec des prix décimaux")
        void testRevenuPrixDecimal() {
            offre.setPrixParPlace(35.50);
            offre.mettreAJourPlaces(3);
            Double revenu = offre.calculerRevenuTotal();
            
            // 3 places × 35.50 MAD = 106.50 MAD
            assertEquals(106.5, revenu, 0.01);
        }
    }

    @Nested
    @DisplayName("Tests de gestion du statut")
    class GestionStatutTests {

        @Test
        @DisplayName("annuler() change le statut à ANNULEE")
        void testAnnuler() {
            offre.annuler();
            assertEquals("ANNULEE", offre.getStatut());
        }

        @Test
        @DisplayName("terminer() change le statut à TERMINEE")
        void testTerminer() {
            offre.terminer();
            assertEquals("TERMINEE", offre.getStatut());
        }

        @Test
        @DisplayName("Le statut initial est EN_ATTENTE")
        void testStatutInitial() {
            assertEquals("EN_ATTENTE", offre.getStatut());
        }

        @Test
        @DisplayName("marquerCommeEffectuee() change estEffectuee à true")
        void testMarquerCommeEffectuee() {
            assertFalse(offre.getEstEffectuee());
            offre.marquerCommeEffectuee();
            assertTrue(offre.getEstEffectuee());
        }
    }

    @Nested
    @DisplayName("Tests des getters et setters")
    class GettersSettersTests {

        @Test
        @DisplayName("setIdOffre et getIdOffre fonctionnent correctement")
        void testIdOffre() {
            offre.setIdOffre(100L);
            assertEquals(100L, offre.getIdOffre());
        }

        @Test
        @DisplayName("setVilleDepart et getVilleDepart fonctionnent correctement")
        void testVilleDepart() {
            offre.setVilleDepart("Marrakech");
            assertEquals("Marrakech", offre.getVilleDepart());
        }

        @Test
        @DisplayName("setPrixParPlace et getPrixParPlace fonctionnent correctement")
        void testPrixParPlace() {
            offre.setPrixParPlace(75.0);
            assertEquals(75.0, offre.getPrixParPlace());
        }

        @Test
        @DisplayName("setCommentaire et getCommentaire fonctionnent correctement")
        void testCommentaire() {
            offre.setCommentaire("Départ devant la gare");
            assertEquals("Départ devant la gare", offre.getCommentaire());
        }

        @Test
        @DisplayName("setConducteur et getConducteur fonctionnent correctement")
        void testConducteur() {
            Conducteur conducteur = new Conducteur();
            conducteur.setIdConducteur(1L);
            offre.setConducteur(conducteur);
            
            assertNotNull(offre.getConducteur());
            assertEquals(1L, offre.getConducteur().getIdConducteur());
        }
    }

    @Nested
    @DisplayName("Tests des cas limites")
    class CasLimitesTests {

        @Test
        @DisplayName("Prix peut être 0")
        void testPrixZero() {
            offre.setPrixParPlace(0.0);
            assertEquals(0.0, offre.getPrixParPlace());
        }

        @Test
        @DisplayName("Places totales peut être 1")
        void testUnePlaceUniquement() {
            Offre offreUnique = new Offre(1L, "Fes", "Meknes", dateDepart, heureDepart, 30.0, 1);
            assertEquals(1, offreUnique.getPlacesTotales());
            assertEquals(1, offreUnique.getPlacesDisponibles());
        }

        @Test
        @DisplayName("Peut avoir un grand nombre de places")
        void testNombreuxPlaces() {
            Offre offreBus = new Offre(1L, "Casa", "Agadir", dateDepart, heureDepart, 100.0, 50);
            assertEquals(50, offreBus.getPlacesTotales());
        }

        @Test
        @DisplayName("Date de publication est définie automatiquement")
        void testDatePublicationAutomatique() {
            Offre nouvelleOffre = new Offre();
            assertNotNull(nouvelleOffre.getDatePublication());
        }
    }

    @Nested
    @DisplayName("Tests de scénarios réels")
    class ScenariosReelsTests {

        @Test
        @DisplayName("Scénario complet : création → réservations → calcul revenu")
        void testScenarioComplet() {
            // 1. Offre créée avec 4 places
            assertEquals(4, offre.getPlacesDisponibles());
            
            // 2. Première réservation de 2 places
            assertTrue(offre.verifierDisponibilite(2));
            offre.mettreAJourPlaces(2);
            assertEquals(2, offre.getPlacesDisponibles());
            assertEquals(100.0, offre.calculerRevenuTotal());
            
            // 3. Deuxième réservation de 1 place
            assertTrue(offre.verifierDisponibilite(1));
            offre.mettreAJourPlaces(1);
            assertEquals(1, offre.getPlacesDisponibles());
            assertEquals(150.0, offre.calculerRevenuTotal());
            
            // 4. Tentative de réservation de 2 places (devrait échouer)
            assertFalse(offre.verifierDisponibilite(2));
            
            // 5. Dernière place réservée
            assertTrue(offre.verifierDisponibilite(1));
            offre.mettreAJourPlaces(1);
            assertEquals(0, offre.getPlacesDisponibles());
            assertEquals(200.0, offre.calculerRevenuTotal());
            
            // 6. Terminer l'offre
            offre.terminer();
            assertEquals("TERMINEE", offre.getStatut());
        }

        @Test
        @DisplayName("Scénario d'annulation d'offre")
        void testScenarioAnnulation() {
            assertEquals("EN_ATTENTE", offre.getStatut());
            
            offre.annuler();
            assertEquals("ANNULEE", offre.getStatut());
            
            // Même annulée, les données restent intactes
            assertEquals(4, offre.getPlacesDisponibles());
            assertEquals("Casablanca", offre.getVilleDepart());
        }
    }
}