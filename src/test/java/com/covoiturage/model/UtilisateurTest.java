package com.covoiturage.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import java.util.Date;
import models.*;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests unitaires pour la classe Utilisateur
 */
@DisplayName("Tests de la classe Utilisateur")
class UtilisateurTest {

    private Utilisateur utilisateur;

    @BeforeEach
    void setUp() {
        // Initialisation avant chaque test
        utilisateur = new Utilisateur("Alami", "Ahmed", "ahmed@email.com", "password123", "0612345678");
    }

    @Nested
    @DisplayName("Tests du constructeur")
    class ConstructeurTests {

        @Test
        @DisplayName("Le constructeur par défaut initialise correctement")
        void testConstructeurParDefaut() {
            Utilisateur user = new Utilisateur();
            
            assertNotNull(user);
            assertTrue(user.getEstActif());
            assertNotNull(user.getDateInscription());
        }

        @Test
        @DisplayName("Le constructeur avec paramètres initialise correctement")
        void testConstructeurAvecParametres() {
            assertEquals("Alami", utilisateur.getNom());
            assertEquals("Ahmed", utilisateur.getPrenom());
            assertEquals("ahmed@email.com", utilisateur.getEmail());
            assertEquals("password123", utilisateur.getMotDePasse());
            assertEquals("0612345678", utilisateur.getTelephone());
            assertTrue(utilisateur.getEstActif());
            assertNotNull(utilisateur.getDateInscription());
        }
    }

    @Nested
    @DisplayName("Tests des getters et setters")
    class GettersSettersTests {

        @Test
        @DisplayName("setIdUtilisateur et getIdUtilisateur fonctionnent correctement")
        void testIdUtilisateur() {
            utilisateur.setIdUtilisateur(1L);
            assertEquals(1L, utilisateur.getIdUtilisateur());
        }

        @Test
        @DisplayName("setNom et getNom fonctionnent correctement")
        void testNom() {
            utilisateur.setNom("Bennani");
            assertEquals("Bennani", utilisateur.getNom());
        }

        @Test
        @DisplayName("setEmail et getEmail fonctionnent correctement")
        void testEmail() {
            utilisateur.setEmail("nouveau@email.com");
            assertEquals("nouveau@email.com", utilisateur.getEmail());
        }

        @Test
        @DisplayName("setEstActif et getEstActif fonctionnent correctement")
        void testEstActif() {
            utilisateur.setEstActif(false);
            assertFalse(utilisateur.getEstActif());
        }

        @Test
        @DisplayName("setPhotoProfil et getPhotoProfil fonctionnent correctement")
        void testPhotoProfil() {
            utilisateur.setPhotoProfil("images/profil.jpg");
            assertEquals("images/profil.jpg", utilisateur.getPhotoProfil());
        }
    }

    @Nested
    @DisplayName("Tests de la méthode seConnecter")
    class SeConnecterTests {

        @Test
        @DisplayName("La connexion réussit avec les bons identifiants")
        void testConnexionReussie() {
            Boolean resultat = utilisateur.seConnecter("ahmed@email.com", "password123");
            assertTrue(resultat);
        }

        @Test
        @DisplayName("La connexion échoue avec un mauvais email")
        void testConnexionEchecMauvaisEmail() {
            Boolean resultat = utilisateur.seConnecter("mauvais@email.com", "password123");
            assertFalse(resultat);
        }

        @Test
        @DisplayName("La connexion échoue avec un mauvais mot de passe")
        void testConnexionEchecMauvaisMotDePasse() {
            Boolean resultat = utilisateur.seConnecter("ahmed@email.com", "mauvaisMotDePasse");
            assertFalse(resultat);
        }

        @Test
        @DisplayName("La connexion échoue si le compte est inactif")
        void testConnexionEchecCompteInactif() {
            utilisateur.setEstActif(false);
            Boolean resultat = utilisateur.seConnecter("ahmed@email.com", "password123");
            assertFalse(resultat);
        }

        @Test
        @DisplayName("La connexion échoue avec email et mot de passe incorrects")
        void testConnexionEchecTout() {
            Boolean resultat = utilisateur.seConnecter("mauvais@email.com", "mauvaisMotDePasse");
            assertFalse(resultat);
        }
    }

    @Nested
    @DisplayName("Tests des méthodes utilitaires")
    class MethodesUtilitairesTests {

        @Test
        @DisplayName("getPhotoProfilUrl retourne l'URL par défaut si pas de photo")
        void testPhotoProfilUrlParDefaut() {
            String url = utilisateur.getPhotoProfilUrl();
            assertEquals("images/avatars/default-avatar.png", url);
        }

        @Test
        @DisplayName("getPhotoProfilUrl retourne l'URL de la photo si définie")
        void testPhotoProfilUrlDefinie() {
            utilisateur.setPhotoProfil("images/profil.jpg");
            String url = utilisateur.getPhotoProfilUrl();
            assertEquals("images/profil.jpg", url);
        }

        @Test
        @DisplayName("getInitiales retourne les initiales correctes")
        void testInitiales() {
            String initiales = utilisateur.getInitiales();
            assertEquals("AA", initiales);
        }

        @Test
        @DisplayName("getInitiales retourne 'U' si nom ou prénom manquant")
        void testInitialesSansNom() {
            Utilisateur user = new Utilisateur();
            String initiales = user.getInitiales();
            assertEquals("U", initiales);
        }
    }

    @Nested
    @DisplayName("Tests des cas limites")
    class CasLimitesTests {

        @Test
        @DisplayName("Gestion des valeurs null dans setPhotoProfil")
        void testPhotoProfilNull() {
            utilisateur.setPhotoProfil(null);
            String url = utilisateur.getPhotoProfilUrl();
            assertEquals("images/avatars/default-avatar.png", url);
        }

        @Test
        @DisplayName("Gestion des chaînes vides dans setPhotoProfil")
        void testPhotoProfilVide() {
            utilisateur.setPhotoProfil("");
            String url = utilisateur.getPhotoProfilUrl();
            assertEquals("images/avatars/default-avatar.png", url);
        }

        @Test
        @DisplayName("La date d'inscription est automatiquement définie")
        void testDateInscriptionAutomatique() {
            Utilisateur user = new Utilisateur();
            Date avant = new Date();
            
            // Petite pause pour s'assurer que la date est différente
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                // Ignore
            }
            
            assertNotNull(user.getDateInscription());
            assertTrue(user.getDateInscription().before(new Date()) || 
                      user.getDateInscription().equals(new Date()));
        }
    }

    @Nested
    @DisplayName("Tests de validation")
    class ValidationTests {

        @Test
        @DisplayName("Un utilisateur peut avoir un nom vide")
        void testNomVide() {
            utilisateur.setNom("");
            assertEquals("", utilisateur.getNom());
        }

        @Test
        @DisplayName("Un utilisateur peut avoir un email null")
        void testEmailNull() {
            utilisateur.setEmail(null);
            assertNull(utilisateur.getEmail());
            
            // La connexion ne devrait pas fonctionner avec un email null
            assertThrows(NullPointerException.class, () -> {
                utilisateur.seConnecter("test@email.com", "password");
            });
        }

        @Test
        @DisplayName("Un téléphone peut contenir des caractères spéciaux")
        void testTelephoneAvecCaracteresSpeciaux() {
            utilisateur.setTelephone("+212 6 12 34 56 78");
            assertEquals("+212 6 12 34 56 78", utilisateur.getTelephone());
        }
    }
}
