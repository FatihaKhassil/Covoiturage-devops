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
 * Tests unitaires pour la classe Reservation
 */
@DisplayName("Tests de la classe Reservation")
class ReservationTest {

    private Reservation reservation;
    private Offre offre;
    private Passager passager;

    @BeforeEach
    void setUp() {
        // Création d'un passager
        passager = new Passager("Bennani", "Fatima", "fatima@email.com", "pass123", "0623456789");
        passager.setIdPassager(2L);
        
        // Création d'une offre
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 1);
        Date dateDepart = cal.getTime();
        Time heureDepart = Time.valueOf("10:00:00");
        
        offre = new Offre(1L, "Casablanca", "Marrakech", dateDepart, heureDepart, 80.0, 4);
        offre.setIdOffre(10L);
        
        // Création d'une réservation
        reservation = new Reservation(offre, passager, 2, 160.0);
    }

    @Nested
    @DisplayName("Tests du constructeur")
    class ConstructeurTests {

        @Test
        @DisplayName("Le constructeur par défaut initialise correctement")
        void testConstructeurParDefaut() {
            Reservation resaVide = new Reservation();
            
            assertNotNull(resaVide);
            assertEquals("CONFIRMEE", resaVide.getStatut());
            assertNotNull(resaVide.getDateReservation());
        }

        @Test
        @DisplayName("Le constructeur avec paramètres initialise correctement")
        void testConstructeurAvecParametres() {
            assertNotNull(reservation.getOffre());
            assertNotNull(reservation.getPassager());
            assertEquals(2, reservation.getNombrePlaces());
            assertEquals(160.0, reservation.getPrixTotal());
            assertEquals("CONFIRMEE", reservation.getStatut());
            assertNotNull(reservation.getDateReservation());
        }

        @Test
        @DisplayName("Le statut initial est CONFIRMEE")
        void testStatutInitial() {
            assertEquals("CONFIRMEE", reservation.getStatut());
        }
    }

    @Nested
    @DisplayName("Tests de calculerPrixTotal")
    class CalculerPrixTotalTests {

        @Test
        @DisplayName("Retourne le prix total correct")
        void testCalculPrixTotal() {
            Double prix = reservation.calculerPrixTotal();
            assertEquals(160.0, prix);
        }

        @Test
        @DisplayName("Le prix total peut être modifié")
        void testModificationPrixTotal() {
            reservation.setPrixTotal(200.0);
            assertEquals(200.0, reservation.calculerPrixTotal());
        }
    }

    @Nested
    @DisplayName("Tests de gestion du statut")
    class GestionStatutTests {

        @Test
        @DisplayName("confirmer() définit le statut à CONFIRMEE")
        void testConfirmer() {
            reservation.setStatut("EN_ATTENTE");
            reservation.confirmer();
            assertEquals("CONFIRMEE", reservation.getStatut());
        }

        @Test
        @DisplayName("annuler() définit le statut à ANNULEE et retourne true")
        void testAnnuler() {
            Boolean resultat = reservation.annuler();
            
            assertTrue(resultat);
            assertEquals("ANNULEE", reservation.getStatut());
        }

        @Test
        @DisplayName("terminer() définit le statut à TERMINEE")
        void testTerminer() {
            reservation.terminer();
            assertEquals("TERMINEE", reservation.getStatut());
        }

        @Test
        @DisplayName("peutEtreAnnulee retourne true si statut est CONFIRMEE")
        void testPeutEtreAnnuleeOui() {
            assertTrue(reservation.peutEtreAnnulee());
        }

        @Test
        @DisplayName("peutEtreAnnulee retourne false si statut n'est pas CONFIRMEE")
        void testPeutEtreAnnuleeNon() {
            reservation.setStatut("TERMINEE");
            assertFalse(reservation.peutEtreAnnulee());
            
            reservation.setStatut("ANNULEE");
            assertFalse(reservation.peutEtreAnnulee());
        }
    }

    @Nested
    @DisplayName("Tests des getters et setters")
    class GettersSettersTests {

        @Test
        @DisplayName("setIdReservation et getIdReservation fonctionnent correctement")
        void testIdReservation() {
            reservation.setIdReservation(100L);
            assertEquals(100L, reservation.getIdReservation());
        }

        @Test
        @DisplayName("setOffre et getOffre fonctionnent correctement")
        void testOffre() {
            Offre nouvelleOffre = new Offre();
            nouvelleOffre.setIdOffre(20L);
            reservation.setOffre(nouvelleOffre);
            
            assertEquals(20L, reservation.getOffre().getIdOffre());
        }

        @Test
        @DisplayName("setPassager et getPassager fonctionnent correctement")
        void testPassager() {
            Passager nouveauPassager = new Passager();
            nouveauPassager.setIdPassager(5L);
            reservation.setPassager(nouveauPassager);
            
            assertEquals(5L, reservation.getPassager().getIdPassager());
        }

        @Test
        @DisplayName("setNombrePlaces et getNombrePlaces fonctionnent correctement")
        void testNombrePlaces() {
            reservation.setNombrePlaces(3);
            assertEquals(3, reservation.getNombrePlaces());
        }

        @Test
        @DisplayName("setMessagePassager et getMessagePassager fonctionnent correctement")
        void testMessagePassager() {
            reservation.setMessagePassager("Je serai en retard de 5 minutes");
            assertEquals("Je serai en retard de 5 minutes", reservation.getMessagePassager());
        }

      
    }

    @Nested
    @DisplayName("Tests de la gestion des évaluations")
    class GestionEvaluationsTests {

        @Test
        @DisplayName("setEvaluation et getEvaluation fonctionnent correctement")
        void testEvaluation() {
            Evaluation evaluation = new Evaluation();
            reservation.setEvaluation(evaluation);
            
            assertNotNull(reservation.getEvaluation());
        }

        @Test
        @DisplayName("Une réservation peut ne pas avoir d'évaluation")
        void testSansEvaluation() {
            assertNull(reservation.getEvaluation());
        }
    }

    @Nested
    @DisplayName("Tests des cas limites")
    class CasLimitesTests {

        @Test
        @DisplayName("Réservation avec 1 seule place")
        void testUneSeulePlace() {
            Reservation resaUnique = new Reservation(offre, passager, 1, 80.0);
            assertEquals(1, resaUnique.getNombrePlaces());
            assertEquals(80.0, resaUnique.getPrixTotal());
        }

        @Test
        @DisplayName("Réservation avec prix à 0")
        void testPrixZero() {
            Reservation resaGratuite = new Reservation(offre, passager, 2, 0.0);
            assertEquals(0.0, resaGratuite.getPrixTotal());
        }

        @Test
        @DisplayName("Message passager peut être null")
        void testMessageNull() {
            assertNull(reservation.getMessagePassager());
            reservation.setMessagePassager(null);
            assertNull(reservation.getMessagePassager());
        }

        @Test
        @DisplayName("Date de réservation est définie automatiquement")
        void testDateReservationAutomatique() {
            assertNotNull(reservation.getDateReservation());
            assertTrue(reservation.getDateReservation().before(new Date()) || 
                      reservation.getDateReservation().equals(new Date()));
        }
    }

    @Nested
    @DisplayName("Tests de scénarios réels")
    class ScenariosReelsTests {

        @Test
        @DisplayName("Scénario complet : création → confirmation → évaluation")
        void testScenarioComplet() {
            // 1. Réservation créée et confirmée
            assertEquals("CONFIRMEE", reservation.getStatut());
            assertTrue(reservation.peutEtreAnnulee());
            
            // 2. Passager ajoute un message
            reservation.setMessagePassager("J'apporte un gâteau pour le trajet");
            assertEquals("J'apporte un gâteau pour le trajet", reservation.getMessagePassager());
            
            // 3. Le trajet est terminé
            reservation.terminer();
            assertEquals("TERMINEE", reservation.getStatut());
            assertFalse(reservation.peutEtreAnnulee());
            
            // 4. Le passager évalue
            reservation.setEstEvalue(true);
            
        }

        @Test
        @DisplayName("Scénario d'annulation")
        void testScenarioAnnulation() {
            // 1. Vérification qu'on peut annuler
            assertTrue(reservation.peutEtreAnnulee());
            
            // 2. Annulation
            Boolean resultat = reservation.annuler();
            assertTrue(resultat);
            assertEquals("ANNULEE", reservation.getStatut());
            
            // 3. Ne peut plus être annulée
            assertFalse(reservation.peutEtreAnnulee());
            
            // 4. Les données restent intactes
            assertEquals(2, reservation.getNombrePlaces());
            assertEquals(160.0, reservation.getPrixTotal());
            assertNotNull(reservation.getOffre());
            assertNotNull(reservation.getPassager());
        }

        @Test
        @DisplayName("Scénario de modification avant confirmation")
        void testModificationAvantConfirmation() {
            // 1. Modification du nombre de places
            reservation.setNombrePlaces(3);
            assertEquals(3, reservation.getNombrePlaces());
            
            // 2. Ajustement du prix
            reservation.setPrixTotal(240.0);
            assertEquals(240.0, reservation.getPrixTotal());
            
            // 3. Confirmation
            reservation.confirmer();
            assertEquals("CONFIRMEE", reservation.getStatut());
        }

        @Test
        @DisplayName("Cycle de vie complet d'une réservation")
        void testCycleVieComplet() {
            // Création
            assertNotNull(reservation);
            assertEquals("CONFIRMEE", reservation.getStatut());
            
          
            
            // Terminaison
            reservation.terminer();
            assertEquals("TERMINEE", reservation.getStatut());
            
            // Évaluation
            Evaluation eval = new Evaluation();
            reservation.setEvaluation(eval);
            reservation.setEstEvalue(true);
            
            assertNotNull(reservation.getEvaluation());
        }
    }

    @Nested
    @DisplayName("Tests de cohérence des données")
    class CoherenceDonneesTests {

        @Test
        @DisplayName("Le prix total devrait correspondre au calcul : nbPlaces × prixParPlace")
        void testCoherencePrix() {
            // Prix de l'offre : 80 MAD/place
            // Nombre de places : 2
            // Prix total attendu : 160 MAD
            
            Double prixCalcule = offre.getPrixParPlace() * reservation.getNombrePlaces();
            assertEquals(reservation.getPrixTotal(), prixCalcule);
        }

        @Test
        @DisplayName("Le nombre de places réservées ne doit pas dépasser les places disponibles de l'offre")
        void testCoherencePlaces() {
            // Cette vérification devrait normalement être faite avant la création
            // de la réservation, mais on teste quand même la cohérence
            assertTrue(reservation.getNombrePlaces() <= offre.getPlacesTotales());
        }

        @Test
        @DisplayName("La date de réservation ne peut pas être dans le futur")
        void testDateReservationPaseDansFutur() {
            Date maintenant = new Date();
            Date dateResa = reservation.getDateReservation();
            
            assertTrue(dateResa.before(maintenant) || dateResa.equals(maintenant));
        }
    }
}
