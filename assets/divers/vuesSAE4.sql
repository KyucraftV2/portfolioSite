--Vues en plus

CREATE OR REPLACE VIEW habitantDepartement (numdepartement, PopDepartement) AS
SELECT c.numdepartement,SUM(populationcommune) FROM Communes c JOIN departement d ON c.numdepartement=d.numdepartement
GROUP BY c.numdepartement;

CREATE OR REPLACE VIEW habitantNouvelleRegion (Region, PopNouvelleRegion) AS
SELECT nouvelleregion,SUM(PopDepartement) FROM habitantDepartement h
JOIN departement d ON h.numdepartement=d.numdepartement
JOIN Region r ON d.nouvelleregion=r.nomregion
GROUP BY nouvelleregion;

CREATE OR REPLACE VIEW habitantAncienneRegion (Region, PopAncienneRegion) AS
SELECT ancienneregion,SUM(PopDepartement) FROM habitantDepartement h
JOIN departement d ON h.numdepartement=d.numdepartement
JOIN Region r ON d.ancienneregion=r.nomregion
GROUP BY ancienneregion;


CREATE OR REPLACE VIEW TotalAnnees (annee,nbEntrees,recettes,nbSeances) AS
SELECT annee,SUM(nbEntrees),SUM(recettes),SUM(nbSeances) AS nbEntreesTotalAn FROM RegionAnnee
GROUP BY annee;

--Vues dans l'ordre
--1
CREATE OR REPLACE VIEW DepartementAnneeNotFinish (numdepartement, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE) AS
SELECT d.numdepartement, annee, SUM(nbEtablissements), SUM(nbEcrans), SUM(nbFauteuils), SUM(nbMultiplexes), SUM(nbSeances), SUM(nbEntrees), 
SUM(recettes), SUM(recettes/nbEntrees), SUM(nbEtablissementsAE), SUM(nbEcransAE), 
SUM(nbFauteuilsAE), SUM(nbSeancesAE), SUM(nbEntreesAE), SUM(recettesAE), 
SUM(recettes/nbEntrees)
FROM departement d
JOIN donneespardepartement do ON d.numdepartement=do.numdepartement
GROUP BY d.numdepartement,annee;

CREATE OR REPLACE VIEW DepartementAnnee (numdepartement, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE,indiceFrequentation,indiceFrequentationAE) AS
SELECT d.numdepartement, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE, nbEntrees/PopDepartement,nbEntreesAE/PopDepartement
FROM DepartementAnneeNotFinish d JOIN habitantDepartement h ON d.numdepartement=h.numdepartement;
--2
CREATE OR REPLACE VIEW RegionAnneeNotFinish (Region, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE) AS
SELECT nouvelleregion, annee, SUM(nbEtablissements), SUM(nbEcrans), SUM(nbFauteuils), SUM(nbMultiplexes), SUM(nbSeances), SUM(nbEntrees), 
SUM(recettes), SUM(recettes/nbEntrees), SUM(nbEtablissementsAE), SUM(nbEcransAE), 
SUM(nbFauteuilsAE), SUM(nbSeancesAE), SUM(nbEntreesAE), SUM(recettesAE), 
SUM(recettes/nbEntrees)
FROM Region r
JOIN departement d ON r.nomregion=d.nouvelleregion
JOIN donneespardepartement do ON d.numdepartement=do.numdepartement
GROUP BY nouvelleregion,annee;

CREATE OR REPLACE VIEW RegionAnnee (Region, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE,indiceFrequentation,indiceFrequentationAE) AS
SELECT r.Region, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE, nbEntrees/PopNouvelleRegion,nbEntreesAE/PopNouvelleRegion
FROM RegionAnneeNotFinish r JOIN habitantNouvelleRegion h ON r.Region=h.Region;

--3
CREATE OR REPLACE VIEW AncienneRegionAnneeNotFinish (Region, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE) AS
SELECT ancienneregion, annee, SUM(nbEtablissements), SUM(nbEcrans), SUM(nbFauteuils), SUM(nbMultiplexes), SUM(nbSeances), SUM(nbEntrees), 
SUM(recettes), SUM(recettes/nbEntrees), SUM(nbEtablissementsAE), SUM(nbEcransAE), 
SUM(nbFauteuilsAE), SUM(nbSeancesAE), SUM(nbEntreesAE), SUM(recettesAE), 
SUM(recettes/nbEntrees)
FROM Region r
JOIN departement d ON r.nomregion=d.ancienneregion
JOIN donneespardepartement do ON d.numdepartement=do.numdepartement
WHERE annee<2016
GROUP BY ancienneregion,annee;

CREATE OR REPLACE VIEW AncienneRegionAnnee (Region, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE,indiceFrequentation,indiceFrequentationAE) AS
SELECT r.Region, annee, nbEtablissements,nbEcrans,nbFauteuils,nbMultiplexes,nbSeances,nbEntrees,recettes,RME, nbEtablissementsAE,nbEcransAE,nbFauteuilsAE,nbSeancesAE,nbEntreesAE,recettesAE,RMEAE, nbEntrees/PopAncienneRegion,nbEntreesAE/PopAncienneRegion
FROM RegionAnneeNotFinish r JOIN habitantAncienneRegion h ON r.Region=h.Region;

--4
CREATE OR REPLACE VIEW TouteCateTouteAnnee (Region, annee, categorie, nombreEntrees) AS
SELECT p.region,p.annee,categorie,ROUND(SUM((pourcentage*nbEntrees)/100)) FROM Publiccine p
JOIN Categories c ON p.numCategorie=c.numcategorie
JOIN RegionAnnee r ON p.Region=r.Region AND r.annee=p.annee
GROUP BY c.numCategorie,p.Region,p.annee,categorie;



--5
CREATE OR REPLACE VIEW CateSexeTouteAnnee (Region, annee, categorie, nombreEntrees) AS
SELECT p.region,p.annee,categorie,ROUND(SUM(pourcentage/100*nbEntrees)) FROM Publiccine p
JOIN Categories c ON p.numCategorie=c.numcategorie
JOIN RegionAnnee r ON p.Region=r.Region AND r.annee=p.annee
WHERE typecategorie='sexe'
GROUP BY c.numCategorie,p.Region,p.annee,categorie;

--6
CREATE OR REPLACE VIEW CateAgeTouteAnnee (Region, annee, categorie, nombreEntrees) AS
SELECT p.region,p.annee,categorie,ROUND(SUM(pourcentage/100*nbEntrees)) FROM Publiccine p
JOIN Categories c ON p.numCategorie=c.numcategorie
JOIN RegionAnnee r ON p.Region=r.Region AND r.annee=p.annee
WHERE typecategorie='age'
GROUP BY c.numCategorie,p.Region,p.annee,categorie;

--7
CREATE OR REPLACE VIEW UnitUrbPlusieurDepart (numuniteUrbaine,nomUniteUrbaine) AS
SELECT nomUniteUrbaine,numuniteUrbaine FROM (
SELECT nomUniteUrbaine,c.numuniteUrbaine,COUNT(DISTINCT numdepartement) FROM Communes c
JOIN uniteurbaine u ON c.numuniteUrbaine=u.numuniteUrbaine
GROUP BY c.numuniteUrbaine,nomUniteUrbaine
HAVING COUNT(DISTINCT numdepartement)>1);


--8
CREATE OR REPLACE VIEW JourAnnee (jour,annee,nbEntrees,recettes,nbSeances) AS
SELECT jours, t.annee, ROUND(SUM(pourcentageentrees/100*nbEntrees)),SUM(pourcentagerecettes/100*recettes),ROUND(SUM(pourcentageseances/100*nbSeances)) FROM Freqjours f
JOIN Jours j ON joursemaine=jours
JOIN TotalAnnees t ON f.annee=t.annee
GROUP BY jours,t.annee;


--9
CREATE OR REPLACE VIEW Communes2014 (nomCommune,numCommune,nbEntrees) AS
SELECT nomcommune,numcommune,nbentrees FROM DONNEESPARCOMMUNE
WHERE annee=2014;

--10
CREATE OR REPLACE VIEW CommunesEcransEtab (nomDepartement,nomCommune,nbEcrans,nbEtablissements) AS
SELECT nomDepartement,c.nomCommune,nbEcrans,nbEtablissements FROM Communes c
JOIN DONNEESPARCOMMUNE d ON d.nomCommune=c.nomCommune AND d.numcommune=c.numcommune
JOIN departement de ON c.numdepartement=de.numdepartement
WHERE annee=2020;

--11
CREATE OR REPLACE VIEW NbEcransMaxDepart(nomDepartement,nomCommune) AS
SELECT nomDepartement,nomCommune FROM CommunesEcransEtab
WHERE nbEcrans IN (SELECT MAXECRANS FROM(SELECT nomDepartement,MAX(nbEcrans) as MAXECRANS FROM CommunesEcransEtab
GROUP BY nomDepartement));

--12
CREATE OR REPLACE VIEW debut (ancienneregion,nouvelleregion) AS
SELECT nomregion,LISTAGG(nomnouvelleregion,', ') WITHIN GROUP (ORDER BY nomregion) FROM region
WHERE nomnouvelleregion IS NOT NULL
GROUP BY nomregion;

CREATE OR REPLACE VIEW NOUVELLEANCIENNEREGION (nouvelleregion, listeancienneregion) AS
SELECT nouvelleregion,LISTAGG(ancienneregion, ', ') WITHIN GROUP (ORDER BY ancienneregion) FROM debut
GROUP BY nouvelleregion
ORDER BY Count(ancienneregion) DESC;


--13
CREATE OR REPLACE VIEW CommunnesOccitanie (nomCommune,numCommune,annee,nbEntrees) AS
SELECT c.nomCommune,c.numCommune,annee,SUM(nbEntrees) FROM Communes c
JOIN DONNEESPARCOMMUNE do ON c.nomCommune=do.nomCommune AND c.numcommune=do.numcommune
JOIN departement d ON c.numdepartement=d.numdepartement
JOIN Region r ON d.nouvelleregion=r.nomregion
WHERE d.nouvelleregion='Occitanie'
GROUP BY c.nomcommune,c.numcommune,annee;

--14
CREATE OR REPLACE VIEW CommuneOccitaniePlusNbEntrees (annee,nomCommune) AS
SELECT annee,nomCommune FROM CommunnesOccitanie
WHERE nbEntrees IN (SELECT nbEntreesMax FROM (SELECT annee,MAX(nbEntrees) as nbEntreesMax FROM CommunnesOccitanie
GROUP BY annee))