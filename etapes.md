# Étapes d'exécution — maquettes Vesta

Ce guide permet de lancer **la maquette Web interactive** (connexion, inscription, liste et détails des annonces). Ce n'est **pas encore** une application Flutter ou React Native installable : aucun compte ni annonce ne sont enregistrés dans Firebase.

## 1. Préparer le PC

1. Ouvrir **PowerShell** ou le terminal de VS Code.
2. Se placer à la racine du projet :

   ```powershell
   cd C:\CP\vesta\vesta
   ```

3. Vérifier que Node.js est installé :

   ```powershell
   node --version
   ```

   Si `node` n'est pas reconnu, installer Node.js, fermer et rouvrir le terminal, puis refaire la vérification. **Aucun `npm install` n'est nécessaire** pour ces maquettes.

## 2. Démarrer la maquette

Depuis `C:\CP\vesta\vesta`, exécuter :

```powershell
node docs/mockups/server.js
```

Le terminal doit afficher :

```text
Maquettes Vesta : http://localhost:8000/
```

**Laisser ce terminal ouvert** pendant le test. Si la page s'ouvre déjà et que le port 8000 est occupé, le serveur est peut-être déjà lancé : essayer directement l'étape 3 plutôt que de démarrer une deuxième instance.

## 3. Ouvrir sur le PC

Ouvrir **http://localhost:8000/** dans Chrome, Edge ou Firefox. L'écran initial est « Connexion ». Cliquer sur **Explorer sans compte** pour accéder immédiatement aux annonces ; on peut aussi tester l'onglet **Inscription**.

Pour simuler un écran de téléphone sur PC : dans Chrome/Edge, appuyer sur **F12**, puis cliquer sur l'icône téléphone/tablette (ou `Ctrl+Shift+M`) ; essayer les largeurs 320, 375 et 430 px.

## 4. Ouvrir sur un vrai téléphone (facultatif mais requis pour le ticket)

1. Connecter le téléphone et le PC au **même Wi-Fi**. Garder le serveur ouvert sur le PC.
2. Sur le PC, lancer `ipconfig` et repérer l'**adresse IPv4** de la carte Wi-Fi, par exemple `192.168.1.25`.
3. Sur le téléphone, ouvrir `http://192.168.1.25:8000/` en remplaçant l'adresse par **celle de votre PC**. Ne pas utiliser `localhost` sur le téléphone : cela désignerait le téléphone lui-même.
4. Si ça ne s'ouvre pas, vérifier le même Wi-Fi, l'adresse IPv4, le pare-feu Windows (autoriser Node.js sur le réseau privé) et l'absence d'isolation réseau/VPN. Ne pas exposer le serveur sur un réseau public.

## 5. Vérifier que ça fonctionne

- **Connexion** : envoyer le formulaire vide → message d'erreur ; entrer un e-mail valide et un mot de passe d'au moins 6 caractères → liste des annonces (simulation uniquement).
- **Inscription** : laisser le nom vide ou saisir deux mots de passe différents → message d'erreur.
- **Liste** : chercher `Sousse` → 1 bien ; chercher `zzz` → aucun résultat ; utiliser « Effacer les filtres » pour revenir aux 4 biens.
- **Détail** : ouvrir « Villa des Oliviers » → prix, galerie de visuels et retour vers la liste.
- **Favoris** : toucher un cœur et ouvrir « Favoris » → le bien apparaît ; ces favoris sont effacés au rechargement.

La [checklist complète des tests et les résultats attendus](docs/mockups/README.md#scénarios-et-résultats-attendus) sont dans `docs/mockups/README.md`. Les [captures d'aperçu](docs/mockups/README.md#livrables) y sont aussi disponibles.

## 6. Arrêter le serveur

Dans le terminal où `node docs/mockups/server.js` tourne, appuyer sur **Ctrl+C**. Si le serveur a été démarré en arrière-plan par un autre terminal ou outil, arrêter ce processus Node depuis ce terminal ou le gestionnaire des tâches ; fermer seulement l'onglet du navigateur ne suffit pas.

### En cas de problème

- **`node` introuvable** : installer Node.js, rouvrir PowerShell et tester `node --version`.
- **`EADDRINUSE` / port 8000 occupé** : une instance tourne déjà ; ouvrir `http://localhost:8000/` ou arrêter l'ancienne instance avant de relancer.
- **Page blanche / fichier introuvable** : vérifier que la commande est lancée depuis la racine du projet et utiliser exactement `http://localhost:8000/` (pas `index.html` seul).
- **Le téléphone n'accède pas à la page** : reprendre l'étape 4 ; sur le téléphone, remplacer impérativement `localhost` par l'IPv4 du PC.
