CREATE DATABASE weo;

USE weo;

DROP TABLE IF EXISTS bon_livraison;

CREATE TABLE bon_livraison (
          bon_livraison_id INT AUTO_INCREMENT ,
          bon_livraison_facturable VARCHAR(1) ,
          bon_livraison_affaire INT ,
          bon_livraison_numero INT ,
          bon_livraison_date_creation DATETIME ,
          bon_livraison_commande INT ,
          bon_livraison_client INT ,
          bon_livraison_adresse VARCHAR(255) ,
          bon_livraison_description VARCHAR(255) ,
          bon_livraison_facture INT ,
          bon_livraison_tva INT ,
          PRIMARY KEY(bon_livraison_id))
;

DROP TABLE IF EXISTS cmd_achat;

CREATE TABLE cmd_achat (
          cmd_achat_id INT AUTO_INCREMENT ,
          cmd_achat_numero INT ,
          cmd_achat_affaire INT ,
          cmd_achat_date_creation DATETIME ,
          cmd_achat_tier INT ,
          cmd_achat_tva INT ,
          cmd_achat_adresse_liv VARCHAR(255) ,
          cmd_achat_description VARCHAR(255) ,
          cmd_achat_solde VARCHAR(1) ,
          cmd_achat_tva_total DOUBLE(25,2) ,
          cmd_achat_ttc DOUBLE(25,2) ,
          PRIMARY KEY(cmd_achat_id))
;

DROP TABLE IF EXISTS cmd_achat_lignes;

CREATE TABLE cmd_achat_lignes (
          cmd_achat_ligne_id INT AUTO_INCREMENT ,
          cmd_achat_ligne_commande INT ,
          cmd_achat_ligne_ligne INT ,
          cmd_achat_ligne_produit INT ,
          cmd_achat_achat_ligne_description VARCHAR(255) ,
          cmd_achat_ligne_delai DATETIME ,
          cmd_achat_ligne_qt_cmd DOUBLE(25,2) ,
          cmd_achat_ligne_qt_livrai DOUBLE(25,2) ,
          cmd_achat_ligne_pu DOUBLE(28,5) ,
          cmd_achat_ligne_solde VARCHAR(1) ,
          PRIMARY KEY(cmd_achat_ligne_id))
;

DROP TABLE IF EXISTS devis_client;

CREATE TABLE devis_client (
          devis_id INT AUTO_INCREMENT ,
          devis_numero INT ,
          devis_date_creation DATETIME ,
          devis_tier INT ,
          devis_tva INT ,
          devis_adresse_liv VARCHAR(255) ,
          devis_description VARCHAR(255) ,
          devis_solde VARCHAR(1) ,
          devis_affaire INT ,
          devis_tva_total DOUBLE(25,2) ,
          devis_ttc DOUBLE(25,2) ,
          PRIMARY KEY(devis_id))
;

DROP TABLE IF EXISTS devis_lignes;

CREATE TABLE devis_lignes (
          devis_ligne_id INT AUTO_INCREMENT ,
          devis_ligne_devis INT ,
          devis_ligne_ligne INT ,
          devis_ligne_produit INT ,
          devis_ligne_description VARCHAR(255) ,
          devis_ligne_delai DATETIME ,
          devis_ligne_qt_cmd DOUBLE(25,2) ,
          devis_ligne_pu DOUBLE(28,5) ,
          PRIMARY KEY(devis_ligne_id))
;

DROP TABLE IF EXISTS demande_achat;

CREATE TABLE demande_achat (
          demande_achat_id INT AUTO_INCREMENT ,
          demande_achat_numero INT ,
          demande_achat_date_creation DATETIME ,
          demande_achat_tier INT ,
          demande_achat_tva INT ,
          demande_achat_adresse_liv VARCHAR(255) ,
          demande_achat_description VARCHAR(255) ,
          demande_achat_solde VARCHAR(1) ,
          demande_achat_affaire INT ,
          demande_achat_tva_total DOUBLE(25,2) ,
          demande_achat_ttc DOUBLE(25,2) ,
          PRIMARY KEY(demande_achat_id))
;

DROP TABLE IF EXISTS demande_achat_lignes;

CREATE TABLE demande_achat_lignes (
          demande_achat_ligne_id INT AUTO_INCREMENT ,
          demande_achat_ligne_demande_achat INT ,
          demande_achat_ligne_ligne INT ,
          demande_achat_ligne_produit INT ,
          demande_achat_ligne_description VARCHAR(255) ,
          demande_achat_ligne_delai DATETIME ,
          demande_achat_ligne_qt_cmd DOUBLE(25,2) ,
          demande_achat_ligne_pu DOUBLE(28,5) ,
          PRIMARY KEY(demande_achat_ligne_id))
;

DROP TABLE IF EXISTS cmd_client;

CREATE TABLE cmd_client (
          cmd_vente_id INT AUTO_INCREMENT ,
          cmd_vente_facturable VARCHAR(1) ,
          cmd_vente_numero INT ,
          cmd_vente_affaire INT ,
          cmd_vente_date_creation DATETIME ,
          cmd_vente_tier INT ,
          cmd_vente_tva INT ,
          cmd_vente_adresse_liv VARCHAR(255) ,
          cmd_vente_description VARCHAR(255) ,
          cmd_vente_solde VARCHAR(1) ,
          cmd_vente_tva_total DOUBLE(25,2) ,
          cmd_vente_ttc DOUBLE(25,2) ,
          PRIMARY KEY(cmd_vente_id))
;

DROP TABLE IF EXISTS cmd_vente_lignes;

CREATE TABLE cmd_vente_lignes (
          cmd_vente_ligne_id INT AUTO_INCREMENT ,
          cmd_vente_ligne_commande INT ,
          cmd_vente_ligne_ligne INT ,
          cmd_vente_ligne_produit INT ,
          cmd_vente_ligne_description VARCHAR(255) ,
          cmd_vente_ligne_delai DATETIME ,
          cmd_vente_ligne_qt_cmd DOUBLE(25,2) ,
          cmd_vente_ligne_qt_livrai DOUBLE(25,2) ,
          cmd_vente_ligne_pu_achat DOUBLE(28,5) ,
          cmd_vente_ligne_pu DOUBLE(28,5) ,
          cmd_vente_ligne_solde VARCHAR(1) ,
          PRIMARY KEY(cmd_vente_ligne_id))
;

DROP TABLE IF EXISTS facture;

CREATE TABLE facture (
          facture_id INT AUTO_INCREMENT ,
          facture_numero INT ,
          facture_client INT ,
          facture_date_creation DATETIME ,
          facture_ht DOUBLE(25,2) ,
          facture_relation_tva INT ,
          facture_tva DOUBLE(25,2) ,
          facture_ttc DOUBLE(25,2) ,
          facture_echeance DATETIME ,
          facture_type VARCHAR(1) ,
          facture_type_bon VARCHAR(1) ,
          facture_reglee VARCHAR(1) ,
          facture_commentaire VARCHAR(25) ,
          facture_representant INT ,
          facture_taux_comm DOUBLE(28,5) ,
          PRIMARY KEY(facture_id))
;

DROP TABLE IF EXISTS familles;

CREATE TABLE familles (
          famille_id INT AUTO_INCREMENT ,
          famille_nom VARCHAR(50) ,
          famille_description VARCHAR(255) ,
          famille_type VARCHAR(1) ,
          PRIMARY KEY(famille_id))
;

DROP TABLE IF EXISTS historique;

CREATE TABLE historique (
          histor_id INT AUTO_INCREMENT ,
          histor_date_mvt DATETIME ,
          histor_produit INT ,
          histor_libelle VARCHAR(20) ,
          histor_class_mvt VARCHAR(1) ,
          histor_document INT ,
          histor_qt_mvt DOUBLE(25,2) ,
          histor_pu_mouvement DOUBLE(28,5) ,
          histor_user INT ,
          PRIMARY KEY(histor_id))
;

DROP TABLE IF EXISTS ligne_bon_livraison;

CREATE TABLE ligne_bon_livraison (
          ligne_bl_id INT AUTO_INCREMENT ,
          ligne_bl_date DATETIME ,
          ligne_bl_bl INT ,
          ligne_bl_realation_ligne_cmd INT ,
          ligne_bl_produit INT ,
          ligne_bl_description VARCHAR(255) ,
          ligne_bl_prix DOUBLE(28,5) ,
          ligne_bl_qt DOUBLE(28,5) ,
          PRIMARY KEY(ligne_bl_id))
;

DROP TABLE IF EXISTS ligne_facture;

CREATE TABLE ligne_facture (
          ligne_facture_id INT AUTO_INCREMENT ,
          ligne_facture_facture INT ,
          ligne_facture_ligne INT ,
          ligne_facture_affaire INT ,
          ligne_facture_ligne_b INT ,
          ligne_facture_produit INT ,
          ligne_facture_description VARCHAR(255) ,
          ligne_facture_qt DOUBLE(28,5) ,
          ligne_facture_pu DOUBLE(28,5) ,
          ligne_facture_ht DOUBLE(28,5) ,
          ligne_facture_tva INT ,
          ligne_facture_mnt_tva DOUBLE(28,5) ,
          ligne_facture_ttc DOUBLE(28,5) ,
          PRIMARY KEY(ligne_facture_id))
;

DROP TABLE IF EXISTS parametres;

CREATE TABLE parametres (
          param_id INT AUTO_INCREMENT ,
          param_nom VARCHAR(30) ,
          param_adresse VARCHAR(255) ,
          param_siret VARCHAR(20) ,
          param_tvaintra VARCHAR(20) ,
          param_devise VARCHAR(10) ,
          param_default_tva INT ,
          param_num_devis INT ,
          param_num_demande_achat INT ,
          param_num_cmd_cl INT ,
          param_num_cmd_fr INT ,
          param_num_bon_livraison INT ,
          param_num_bon_reception INT ,
          param_num_facture INT ,
          param_num_facture_br INT ,
          param_num_affaire INT ,
          param_backup_auto VARCHAR(1) ,
          param_backup_auto_time INT ,
          param_serveurfordata VARCHAR(255) ,
          param_url_for_consult VARCHAR(255) ,
          param_mail_expeditor VARCHAR(50) ,
          param_smtp_serveur VARCHAR(50) ,
          param_smtp_port MEDIUMINT ,
          param_smtp_ssl VARCHAR(1) ,
          param_smtpauthentification VARCHAR(1) ,
          param_smtpuserlogin VARCHAR(50) ,
          param_smtpuserpassword VARCHAR(50) ,
          param_passwordforchange VARCHAR(50) ,
          param_date_creat DATETIME ,
          PRIMARY KEY(param_id))
;

DROP TABLE IF EXISTS produits;

CREATE TABLE produits (
          produit_id INT AUTO_INCREMENT ,
          produit_code VARCHAR(50) ,
          produit_libelle VARCHAR(50) ,
          produit_description VARCHAR(255) ,
          produit_type VARCHAR(1) ,
          produit_famille INT ,
          produit_date_creat DATETIME ,
          produit_compte_compta VARCHAR(10) ,
          produit_compte_compta_fr VARCHAR(10) ,
          produit_gest_stock VARCHAR(1) ,
          produit_autorise_stock_negatif VARCHAR(1) ,
          produit_gest_reapro VARCHAR(1) ,
          produit_default_fournisseur INT ,
          produit_prix_achat DOUBLE(28,5) ,
          produit_default_client INT ,
          produit_prix_vente DOUBLE(28,5) ,
          produit_cmdachat_min DOUBLE(24,1) ,
          produit_cmdachat_max DOUBLE(24,1) ,
          produit_cmdvente_min DOUBLE(24,1) ,
          produit_cmdvente_max DOUBLE(24,1) ,
          produit_stock_min DOUBLE(24,1) ,
          produit_stock_max DOUBLE(24,1) ,
          produit_stock DOUBLE(28,5) ,
          produit_delai_reapro SMALLINT ,
          produit_image VARCHAR(255) ,
          PRIMARY KEY(produit_id))
;

DROP TABLE IF EXISTS represent;

CREATE TABLE represent (
          represent_id INT AUTO_INCREMENT ,
          represent_nom VARCHAR(30) ,
          represent_prenom VARCHAR(30) ,
          represent_adresse VARCHAR(255) ,
          represent_date_naissance DATETIME ,
          represent_sexe VARCHAR(1) ,
          represent_date_entree DATETIME ,
          represent_date_sortie DATETIME ,
          represent_tx_com DOUBLE(10,5) ,
          represent_photo VARCHAR(255) ,
          PRIMARY KEY(represent_id))
;

DROP TABLE IF EXISTS tiers;

CREATE TABLE tiers (
          tier_id INT AUTO_INCREMENT ,
          tier_compte VARCHAR(20) ,
          tier_compte_fr VARCHAR(20) ,
          tier_nom VARCHAR(50) ,
          tier_date_creation DATETIME ,
          tiers_adresse VARCHAR(255) ,
          tier_type VARCHAR(1) ,
          tier_echeance_reglement INT ,
          tier_famille INT ,
          tier_default_tva INT ,
          tier_telephone VARCHAR(20) ,
          tier_fax VARCHAR(20) ,
          tier_contact VARCHAR(50) ,
          tier_email_contact VARCHAR(50) ,
          tier_site_web VARCHAR(50) ,
          tier_represent INT ,
          PRIMARY KEY(tier_id))
;

DROP TABLE IF EXISTS tva;

CREATE TABLE tva (
          tva_id INT AUTO_INCREMENT ,
          tva_nom VARCHAR(20) ,
          tva_taux DOUBLE(25,2) ,
          tva_description VARCHAR(30) ,
          tva_compte_compta_vente VARCHAR(10) ,
          tva_compte_compta_achat VARCHAR(10) ,
          PRIMARY KEY(tva_id))
;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
          user_id INT AUTO_INCREMENT ,
          user_nom VARCHAR(30) ,
          user_prenom VARCHAR(30) ,
          user_profil INT ,
          user_fonction VARCHAR(50) ,
          user_mail VARCHAR(50) ,
          user_login VARCHAR(10) ,
          user_pass VARCHAR(10) ,
          PRIMARY KEY(user_id))
;

DROP TABLE IF EXISTS historiquemailfile;

CREATE TABLE historiquemailfile (
          historiquemailfilefileId INT AUTO_INCREMENT ,
          historiquemailfilehistoriquemail INT ,
          historiquemailfilefile VARCHAR(255) ,
          PRIMARY KEY(historiquemailfilefileId))
;

DROP TABLE IF EXISTS historiquemail;

CREATE TABLE historiquemail (
          historiquemailid INT AUTO_INCREMENT ,
          historiquemailstatus VARCHAR(1) ,
          historiquemaildate DATETIME ,
          historiquemailfrom VARCHAR(100) ,
          historiquemailto TEXT ,
          historiquemailtohiddenrecipient VARCHAR(1) ,
          historiquemailsubject VARCHAR(100) ,
          historiquemailbody TEXT ,
          historiquemailerror INT ,
          historiquemailuser INT ,
          PRIMARY KEY(historiquemailid))
;

DROP TABLE IF EXISTS errormessages;

CREATE TABLE errormessages (
          errormessages_id INT AUTO_INCREMENT ,
          errormessagesdate DATETIME ,
          errormessages_type VARCHAR(1) ,
          errormessages_document INT ,
          errormessages_nom VARCHAR(50) ,
          errormessages_description TEXT ,
          errormessagesuser INT ,
          PRIMARY KEY(errormessages_id))
;

DROP TABLE IF EXISTS fichiers;

CREATE TABLE fichiers (
          fichiers_id INT AUTO_INCREMENT ,
          fichiers_classeinfo VARCHAR(1) ,
          fichiers_element INT ,
          fichiers_nom VARCHAR(30) ,
          fichier_date_creation DATETIME ,
          fichiers_description VARCHAR(255) ,
          fichier VARCHAR(255) ,
          PRIMARY KEY(fichiers_id))
;

DROP TABLE IF EXISTS bon_reception;

CREATE TABLE bon_reception (
          bon_reception_id INT AUTO_INCREMENT ,
          bon_reception_facturable VARCHAR(1) ,
          bon_reception_affaire INT ,
          bon_reception_numero INT ,
          bon_reception_date_creation DATETIME ,
          bon_reception_commande INT ,
          bon_reception_fournisseur INT ,
          bon_reception_adresse VARCHAR(255) ,
          bon_reception_description VARCHAR(255) ,
          bon_reception_facture TEXT ,
          bon_reception_tva INT ,
          PRIMARY KEY(bon_reception_id))
;

DROP TABLE IF EXISTS ligne_bon_reception;

CREATE TABLE ligne_bon_reception (
          ligne_br_id INT AUTO_INCREMENT ,
          ligne_br_date DATETIME ,
          ligne_br_br INT ,
          ligne_br_relation_ligne_cmd INT ,
          ligne_br_produit INT ,
          ligne_br_description VARCHAR(255) ,
          ligne_br_prix DOUBLE(28,5) ,
          ligne_br_qt DOUBLE(28,5) ,
          PRIMARY KEY(ligne_br_id))
;

DROP TABLE IF EXISTS affaire;

CREATE TABLE affaire (
          affaire_id INT AUTO_INCREMENT ,
          affaire_numero INT ,
          affaire_tier INT ,
          affaire_nom VARCHAR(50) ,
          affaire_date_creation DATETIME ,
          affaire_date_fin DATETIME ,
          affaire_date_maj DATETIME ,
          affaire_solde VARCHAR(1) ,
          affaire_total_achat_en_cours DOUBLE(25,2) ,
          affaire_total_achat_rec DOUBLE(25,2) ,
          affaire_total_achat DOUBLE(25,2) ,
          affaire_total_vente_en_cours DOUBLE(25,2) ,
          affaire_total_vente_exp DOUBLE(25,2) ,
          affaire_total_vente DOUBLE(25,2) ,
          affaire_adresse_liv VARCHAR(255) ,
          affaire_description VARCHAR(255) ,
          PRIMARY KEY(affaire_id))
;

DROP TABLE IF EXISTS profils;

CREATE TABLE profils (
          profil_id INT AUTO_INCREMENT ,
          profil_nom VARCHAR(30) ,
          profil_description VARCHAR(255) ,
          PRIMARY KEY(profil_id))
;

DROP TABLE IF EXISTS droits;

CREATE TABLE droits (
          droit_id INT AUTO_INCREMENT ,
          droit_description VARCHAR(255) ,
          droit_type VARCHAR(1) ,
          droit_modele VARCHAR(1) ,
          droit_class VARCHAR(30) ,
          droit_action VARCHAR(30) ,
          PRIMARY KEY(droit_id))
;

DROP TABLE IF EXISTS joint_profils_droits;

CREATE TABLE joint_profils_droits (
          joint_profil INT ,
          joint_droit INT ,
          joint_description VARCHAR(255) ,
          PRIMARY KEY(joint_profil,joint_droit))
;

GRANT ALL ON weo.* TO 'demo'@'%' IDENTIFIED BY 'vraduser';
FLUSH PRIVILEGES;
