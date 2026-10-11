# Vesta — maquettes mobiles et plan de vérification

**Projet :** application immobilière Vesta (versions Flutter et React Native, backend Firebase commun). **Périmètre de cette tâche :** connexion, inscription, liste des annonces et détail d'une annonce. Rattachée à l'epic Design & C4 (VST-6 d'après le ticket transmis), Sprint 0.

> Source : description du ticket fournie et `README.md` du dépôt. Le PDF `docs/vesta_plan_de_travail.pdf` joint au message n'a pas pu être lu dans cet échange : vérifier ses éventuelles consignes graphiques supplémentaires avant validation. Le ticket transmis indique **Ahmed / revue Manar**, alors que `docs/jira/vesta_jira_backlog.csv` indique **Mahmoud / revue Eya** pour « Figma mockups ». Faire confirmer l'attribution et la clé exacte du ticket dans Jira ; aucun changement n'a été apporté au backlog.

## Livrables

- [`index.html`](index.html) : prototype navigable sur téléphone ou navigateur, sans installation de Flutter/React Native.
- [`styles.css`](styles.css) : styles responsive, couleurs, typographies et états interactifs.
- [`app.js`](app.js) : données **fictives** et navigation locale pour la démonstration.
- [`assets/`](assets/) : illustrations SVG **provisoires** des biens et de l'intérieur. Elles remplacent les photos en attendant les images de démonstration autorisées ou les photos hébergées sur Firebase Storage.
- [`server.js`](server.js) : petit serveur HTTP local basé sur Node.js, sans dépendance à installer.
- Captures d'aperçu à 375 px : [connexion](previews/connexion.png) · [inscription](previews/inscription.png) · [annonces](previews/annonces.png) · [détail](previews/detail.png). Les vues sont aussi navigables dans le prototype.

Ce livrable est une **maquette HTML/CSS interactive, pas un fichier Figma**, ni les écrans Flutter/React Native. Si le ticket exige des sources Figma éditables, les recréer dans Figma à partir de ces vues et partager le lien + exports après revue ; ne pas déclarer cette condition terminée avant cela.

## Ce qui est conçu

| Écran | Éléments à reprendre dans les deux apps | États montrés |
| --- | --- | --- |
| Connexion | Marque, e-mail, mot de passe affichable/masquable, CTA, entrée en mode démo | champ vide, e-mail invalide, mot de passe trop court |
| Inscription | Nom, e-mail, mot de passe, confirmation, CTA | erreurs de saisie et de confirmation |
| Liste | Recherche texte, vente/location, type de bien, prix maximum, cartes (visuel, titre, ville, prix, surface, chambres), favoris | résultats, aucun résultat, favoris vides |
| Détail | visuel principal, galerie de 3 illustrations, type, localisation, prix, surface, chambres, salles de bain, description, position indicative, CTA contact | favori actif/inactif, galerie sélectionnée |

**Parcours :** connexion ou inscription → liste → fiche du bien → retour liste. « Explorer sans compte » ouvre la liste pour vérifier le design sans identifiants. Le menu « Favoris » ne conserve les cœurs **qu'en mémoire** ; « Compte » revient à la connexion. « Contacter » indique que la messagerie n'est pas implémentée. Le plan de travail général prévoit aussi publication, carte, chat, notifications et profil : **hors périmètre de ces maquettes**.

### Repères visuels pour l'implémentation

- Format de référence : mobile 375–430 px de large ; vérifier aussi 320 px. En-tête et barres basses tiennent compte des safe areas (`env(safe-area-inset-*)`).
- Couleurs : vert profond `#173f39`, fond ivoire `#f9f8f3`, accent doré `#dba15b`. Les styles centraux se trouvent dans `styles.css` ; à formaliser en tokens communs Flutter et React Native.
- Typographies : DM Serif Display (titres) et DM Sans (interface), avec repli Georgia / Arial lorsque Google Fonts est inaccessible. La maquette reste lisible hors ligne.
- Les annonces et prix sont des exemples en TND, **pas des biens réels**. Le prix de location est indiqué « / mois ». L'emplacement est indicatif, pas une géolocalisation effective.
- La maquette n'envoie **aucune donnée à Firebase** et ne crée aucun compte : les formulaires simulent seulement la validation et la navigation. Ne pas confondre ce comportement avec une authentification testée.

## Étapes de travail détaillées

1. **Confirmer le ticket** avec Manar : responsable/reviewer, lien Figma éventuellement requis, charte graphique, textes, devise et jeu de données fictif. Faire valider le parcours acheteur/locataire, en lien avec les user stories de l'équipe.
2. **Examiner les écrans livrés** sur téléphone (instructions ci-dessous). Comparer la lisibilité et l'ordre des actions aux besoins : inscription/connexion → recherche → détail. Corriger les remarques visuelles dans `styles.css` et le contenu des écrans dans `index.html`.
3. **Faire valider les cas limites** : champs invalides, zéro résultat, favoris vides, prix vente/location, retour depuis la fiche, photos provisoires. Les états de chargement/erreur réseau seront à concevoir au moment de l'intégration Firebase.
4. **Si Figma est demandé** : créer des frames téléphone pour connexion, inscription, liste, détail, et une frame « états » (erreurs + zéro résultat). Reprendre les couleurs/espacements de cette maquette ; créer des composants réutilisables (boutons, champ, carte, badge, barre de navigation). Ajouter les liaisons clic/tap du prototype, partager l'URL éditable avec Manar et exporter les images des frames dans le dossier de design si l'équipe le souhaite. Cette étape nécessite un accès Figma et **n'est pas réalisée dans ce dépôt**.
5. **Préparer le passage au développement** : transmettre à l'équipe Flutter et React Native mêmes libellés, données/états et styles. Respecter l'architecture décrite dans le dépôt : `Screen → Controller → Repository → Service`. Dans les vraies apps, le contrôleur gérera filtres/auth/états et les repositories communiqueront avec Firebase ; le HTML actuel n'est pas une couche applicative à intégrer telle quelle.
6. **Ouvrir une PR** suivant `CONTRIBUTING.md` (branche issue de `develop`, clé Jira réelle dans le nom, PR ciblant `develop`). Demander la revue au reviewer **confirmé dans Jira** ; joindre captures mobile et résultat de la checklist ci-dessous. Une fois approuvée et mergée, mettre à jour le ticket avec le lien PR, les captures, le résultat de test sur vrai téléphone et les limites restantes. Ne marquer *Done* qu'une fois ces étapes réalisées.

## Tester la maquette

Pour démarrer pas à pas (PC, téléphone, arrêt et dépannage), voir aussi [`etapes.md`](../../etapes.md) à la racine du dépôt.

### Sur ordinateur

Depuis la racine du dépôt, lancer un serveur HTTP local avec **Node.js** (déjà nécessaire pour React Native) :

```powershell
node docs/mockups/server.js
```

Alternative si Python est installé : `python -m http.server 8000 --bind 0.0.0.0 --directory docs/mockups` (ou `py -m ...` sur Windows). **Sur la machine de préparation, `python` n'est pas installé : privilégier Node.** Ouvrir `http://localhost:8000/`. Dans les outils développeur du navigateur, activer l'émulation mobile et vérifier les largeurs **320 px**, **375 px** et **430 px**, puis recharger et consulter la console. Arrêter le serveur avec `Ctrl+C`.

### Sur un vrai téléphone

1. Mettre PC et téléphone sur le **même Wi-Fi** (pas de VPN/réseau invité isolant les appareils). Laisser le serveur lancé sur le PC.
2. Trouver l'adresse IPv4 locale du PC avec `ipconfig` sur Windows (par ex. `192.168.1.25`). Sur le téléphone, ouvrir `http://<IP-DU-PC>:8000/` dans Chrome Android ou Safari iOS. Si la page ne charge pas, vérifier l'IP, le Wi-Fi et l'autorisation du port 8000 dans le pare-feu Windows.
3. Répéter les scénarios ci-dessous au **toucher**, en mode portrait et paysage ; contrôler notamment texte, défilement, clavier ouvert, navigation et boutons situés près des bords/encoches. Faire une capture de chaque écran et noter modèle, OS, navigateur et date. L'URL HTTP est une maquette Web, **pas** un build des applications mobiles.
4. Facultatif : couper Internet après chargement et recharger pour vérifier les ressources locales (seules les polices en ligne peuvent être remplacées par les polices de repli). Pour une vérification totalement hors réseau, utiliser le serveur local sur le même Wi-Fi.

### Scénarios et résultats attendus

| # | Manipulation | Résultat attendu |
| --- | --- | --- |
| 1 | Ouvrir `/`, valider Connexion vide puis saisir un e-mail invalide. | Erreur claire sous le formulaire, focus sur le champ concerné ; pas de navigation. |
| 2 | Saisir un e-mail valide + mot de passe d'au moins 6 caractères, valider. | Ouverture de la liste avec message « mode démo » ; aucun compte réel créé. |
| 3 | Aller à Inscription, laisser le nom vide puis mettre deux mots de passe différents. | Erreur sur le nom puis sur la confirmation ; afficher/masquer le mot de passe fonctionne. |
| 4 | Utiliser « Explorer sans compte », saisir `Sousse`, puis `zzz`. | Un bien à Sousse puis état vide. Effacer les filtres restaure les 4 annonces. |
| 5 | Choisir « À louer », puis type « Appartement » et prix maximum `2000`. | Un seul bien : Le Patio Bleu, 1 800 TND/mois. |
| 6 | Effacer les filtres, ouvrir Villa des Oliviers. | Titre, localisation La Marsa, prix 1 250 000 TND, surface, chambres et description cohérents. |
| 7 | Toucher les 3 miniatures de la galerie, puis Retour. | Visuel principal et compteur changent ; retour vers la liste. |
| 8 | Ajouter un cœur sur une carte, aller à Favoris, le retirer. | Bien présent puis état « Aucun favori ». Les favoris sont effacés au rechargement. |
| 9 | Sur une fiche, appuyer sur « Contacter ». | Message indiquant que la messagerie n'est pas encore disponible. |
| 10 | Naviguer au clavier (Tab, Entrée, flèches sur les onglets) et tester à 320 px. | Éléments focusables, libellés accessibles, pas de bouton bloqué ni de débordement horizontal. |

**Suivi réel à compléter** (ne pas cocher avant exécution) :

- [ ] Vérification navigateur desktop + largeur 320/375/430 px, sans erreur console.
- [ ] Scénarios 1 à 10 exécutés sur vrai téléphone ; modèle/OS/navigateur : `________________` ; date : `________________`.
- [ ] Captures connexion, inscription, liste et détail jointes au ticket ou à la PR.
- [ ] Maquettes relues par Manar (ou reviewer confirmé), corrections effectuées.
- [ ] PR approuvée et mergée dans `develop` ; lien : `________________`.
- [ ] Ticket Jira mis à jour (preuves, limites et statut).

**Note :** les tests ci-dessus portent sur les **maquettes**. Lors de l'implémentation Flutter et React Native, refaire ces parcours sur chacune des deux applications installées sur téléphone, avec tests d'authentification réelle, filtres Firestore, chargement des photos et erreurs réseau.
