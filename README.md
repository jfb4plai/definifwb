# DéfiniFWB — Guide d'installation

Application de définitions interactives pour tableau blanc interactif (TBI).
Compatible avec le même projet Supabase que FlashFWB.

---

## Étape 1 — Créer la base de données

1. Va dans ton projet Supabase → **SQL Editor**
2. Clique **New query**
3. Copie-colle tout le contenu de `setup.sql`
4. Clique **Run**
5. Résultat attendu : "Success. No rows returned"

---

## Étape 2 — Vérifier les clés Supabase

Le fichier `config.js` contient déjà les clés de ton projet FlashFWB.
Si tu utilises un projet Supabase différent, remplace les valeurs :

```js
const SUPABASE_URL = 'https://ton-projet.supabase.co';
const SUPABASE_ANON_KEY = 'ta-clé-anon';
```

---

## Étape 3 — Mettre sur GitHub

```bash
cd definifwb
git init
git add .
git commit -m "DéfiniFWB v1.0 — Sprint 1"
git branch -M main
git remote add origin https://github.com/TON_COMPTE/definifwb.git
git push -u origin main
```

---

## Étape 4 — Déployer sur Vercel

1. Va sur https://vercel.com → **Add New > Project**
2. Sélectionne le repo `definifwb`
3. Laisse tous les paramètres par défaut
4. Clique **Deploy**
5. L'app sera disponible sur `https://definifwb.vercel.app` (ou URL générée)

---

## Utilisation quotidienne

### Enseignant·e
1. Se connecter sur l'URL Vercel
2. Créer une nouvelle séance (titre + date)
3. Ajouter les mots et définitions (formulaire, CSV ou dictée vocale)
4. Choisir le mode élève (👆 Cliquable, 🔗 Relier, ❓ Quiz)
5. Cliquer **Activer** → une URL + QR code apparaissent
6. Afficher l'URL sur le TBI ou scanner le QR code

### Élèves (TBI)
- Ouvrir l'URL affichée → interface immédiate, sans compte, optimisée tactile

---

## Modes disponibles (Sprint 1)

| Mode | Description | État |
|------|-------------|------|
| 👆 Mot cliquable | Touche un mot → voit sa définition | ✅ Actif |
| 🔗 Relier | Relie mot ↔ définition par trait | ✅ Actif |
| ❓ Quiz flash | QCM généré automatiquement | ✅ Actif |
| ⌨️ Clavier guidé | Tape le mot à partir de la définition | 🚧 Sprint 2 |
| 🔍 Retrouver le mot | Trouve le mot d'une définition | 🚧 Sprint 2 |
| 💡 Indice progressif | La définition se révèle mot par mot | 🚧 Sprint 2 |

---

## Méthodes d'entrée des données

| Méthode | État |
|---------|------|
| Formulaire manuel | ✅ Actif |
| Import CSV (Mot,Définition) | ✅ Actif |
| Dictée vocale (Chrome) | ✅ Actif |
| Import PDF | 🚧 Sprint 3 |

---

## Structure des fichiers

```
definifwb/
├── index.html    Application complète
├── config.js     Clés Supabase
├── setup.sql     Script base de données
├── vercel.json   Configuration déploiement
└── README.md     Ce fichier
```
