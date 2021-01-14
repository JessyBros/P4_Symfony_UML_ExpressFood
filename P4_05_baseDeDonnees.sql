CREATE DATABASE IF NOT EXISTS Express_Food;
USE Express_Food;

DROP TABLE IF EXISTS utilisateur;
CREATE TABLE utilisateur
(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,   
    nom VARCHAR(45) NOT NULL,
    prenom VARCHAR(45) NOT NULL,
    email VARCHAR(70) NOT NULL,
    telephone INT(10) NOT NULL,
    motDePasse VARCHAR(150) NOT NULL
    
);

DROP TABLE IF EXISTS type_produit;
CREATE TABLE type_produit
(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	type VARCHAR(45) NOT NULL
);

DROP TABLE IF EXISTS produit;
CREATE TABLE produit
(
    numProduit INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nom VARCHAR(45) NOT NULL,
    image VARCHAR(255) NOT NULL,
    description TEXT,
    prix DECIMAL NOT NULL,
    stock INT,
    type_produit_id INT NOT NULL,
    FOREIGN KEY (type_produit_id) REFERENCES type_produit(id)
);


DROP TABLE IF EXISTS livreur;
CREATE TABLE livreur
(
    numLivreur INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    photo VARCHAR(255) NOT NULL,
    statut BOOLEAN NOT NULL,
    longitude VARCHAR(45) NOT NULL,
    latitude VARCHAR(45) NOT NULL,
    utilisateur_id INT NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id)
);

DROP TABLE IF EXISTS stock_livreur;
CREATE TABLE stock_livreur
(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    quantite INT NOT NULL,
    produit_numProduit INT NOT NULL,
    livreur_numLivreur INT NOT NULL,
    FOREIGN KEY (produit_numProduit) REFERENCES produit(numProduit),
    FOREIGN KEY (livreur_numLivreur) REFERENCES livreur(numLivreur)
);

DROP TABLE IF EXISTS client;
CREATE TABLE client
(
    numClient INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    utilisateur_id INT NOT NULL,
    adresse_id INT NOT NULL,
    adresse_facturation_id INT NULL,
    adresse_livraison_id INT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id),
    FOREIGN KEY (adresse_id) REFERENCES adresse(id),
    FOREIGN KEY (adresse_facturation_id) REFERENCES adresse(id),
    FOREIGN KEY (adresse_livraison_id) REFERENCES adresse(id)    
);

DROP TABLE IF EXISTS commande;
CREATE TABLE commande
(
    numCommande INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    date DATE NOT NULL,
    statut_paiement VARCHAR(45) NOT NULL,
    statut_commande VARCHAR(45) NOT NULL,
    client_numClient INT NOT NULL,
    livreur_numLivreur INT NOT NULL,
    FOREIGN KEY (client_numClient) REFERENCES client(numClient),
    FOREIGN KEY (livreur_numLivreur) REFERENCES livreur(numLivreur)
);

DROP TABLE IF EXISTS ligne_Commande;
CREATE TABLE ligne_commande
(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    quantite INT NOT NULL,
    produit_numProduit INT NOT NULL,
    commande_numCommande INT NOT NULL,
    FOREIGN KEY (produit_numProduit) REFERENCES produit(numProduit),
    FOREIGN KEY (commande_numCommande) REFERENCES commande(numCommande)  
    
);

DROP TABLE IF EXISTS adresse;
CREATE TABLE adresse
(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    adresse VARCHAR(100) NOT NULL,
    ville VARCHAR(70) NOT NULL,
    code_postal INT NOT NULL
);

INSERT INTO utilisateur
VALUES (NULL, "BRUSSE", "Jason", "livreur@hotmail.com", "0637421524", "mdpLivreur"),
       (NULL, "KAYSE", "Lea", "client_lea@hotmail.com", "0782456234", "mdpClientLea"),
       (NULL, "DURAND", "Sophie", "client_sophie@hotmail.com", "0645219574", "mdpClientSophie");

INSERT INTO livreur
SET photo="photo.png", statut= true, longitude="2.348421541", latitude="2.1248545623", utilisateur_id=(SELECT id FROM utilisateur WHERE id="1"); 

INSERT INTO adresse
VALUES (NULL, "5 rue de la renardise", "Paris", "75014"),
(NULL, "3 rue volonte de fer", "Paris", "75014"),
       (NULL, "9 rue de la paix", "Paris", "75015");
       
INSERT INTO client
SET numClient="437",utilisateur_id=(SELECT id FROM utilisateur WHERE id="2"), adresse_id=(SELECT id FROM adresse WHERE id="1"), adresse_facturation_id=(SELECT id FROM adresse WHERE id="1"),adresse_livraison_id=(SELECT id FROM adresse WHERE id="2");

INSERT INTO client
SET numClient="921",utilisateur_id=(SELECT id FROM utilisateur WHERE id="3"), adresse_id=(SELECT id FROM adresse WHERE id="3"), adresse_facturation_id=(SELECT id FROM adresse WHERE id="3"),adresse_livraison_id=(SELECT id FROM adresse WHERE id="3");

INSERT INTO commande
SET numCommande="27", date="2020/04/15", statut_paiement="paiement accepté", statut_commande="livré", client_numClient=(SELECT numClient FROM client WHERE numClient="437" ), livreur_numLivreur=(SELECT numLivreur FROM livreur WHERE numLivreur="1");

INSERT INTO commande
SET numCommande="42", date="2020/04/16", statut_paiement="paiement accepté", statut_commande="en cours de livraison", client_numClient=(SELECT numClient FROM client WHERE numClient="921" ), livreur_numLivreur=(SELECT numLivreur FROM livreur WHERE numLivreur="1");   
   
INSERT INTO type_produit
SET type="plat";
INSERT INTO type_produit
SET type="dessert";

INSERT INTO produit
SET numProduit="14", nom="burger maison", image="buger.png", description="salade oignon, burger 120g pain sésame", prix="12.5", stock="27", type_produit_id=(SELECT id FROM type_produit WHERE id="1");
INSERT INTO produit
SET numProduit="15",  nom="grattin", image="grattin.png", description= NULL, prix="11", stock="14", type_produit_id=(SELECT id FROM type_produit WHERE id="1");
INSERT INTO produit
SET numProduit="16", nom="panna cotta", image="panna_cotta.png", description="fruit rouge", prix="6.5", stock="12", type_produit_id=(SELECT id FROM type_produit WHERE id="2");
INSERT INTO produit
SET numProduit="17", nom="glace vanille", image="glace_vanille.png", description= NULL, prix="2.5", stock="50", type_produit_id=(SELECT id FROM type_produit WHERE id="2");


INSERT INTO stock_livreur
VALUES (NULL , 8, (SELECT numProduit FROM produit WHERE numProduit="14"), (SELECT numLivreur FROM livreur WHERE numLivreur="1")),
       (NULL , 8, (SELECT numProduit FROM produit WHERE numProduit="15"), (SELECT numLivreur FROM livreur WHERE numLivreur="1")),
       (NULL , 5, (SELECT numProduit FROM produit WHERE numProduit="16"), (SELECT numLivreur FROM livreur WHERE numLivreur="1")),
	   (NULL , 5, (SELECT numProduit FROM produit WHERE numProduit="17"), (SELECT numLivreur FROM livreur WHERE numLivreur="1"));
 
INSERT INTO ligne_commande
VALUES (NULL, 3, (SELECT numProduit FROM produit WHERE nom="burger maison"), (SELECT numCommande FROM commande WHERE numCommande="27")),
	   (NULL, 4, (SELECT numProduit FROM produit WHERE nom="panna cotta"),(SELECT numCommande FROM commande WHERE numCommande="27"));
       
        INSERT INTO ligne_commande
VALUES (NULL, 1, (SELECT numProduit FROM produit WHERE nom="grattin"), (SELECT numCommande FROM commande WHERE numCommande="42")),
	   (NULL, 2, (SELECT numProduit FROM produit WHERE nom="glace vanille"),(SELECT numCommande FROM commande WHERE numCommande="42"));
