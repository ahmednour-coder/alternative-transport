# 🐳 Lancer Alternative Transport avec Docker

Le projet est découpé en **deux conteneurs** :

| Conteneur | Rôle | Image | Port |
|---|---|---|---|
| `alt-api` | Backend Node/Express + SQLite | `alternative-transport-api` (construite depuis `backend/`) | **3000** |
| `alt-web` | Application Flutter Web servie par Nginx + proxy `/api` | `nginx:alpine` | **8080** |

```
Navigateur  ──►  http://localhost:8080  ──►  nginx (alt-web)
                                               ├── /          → build/web (Flutter)
                                               └── /api/...   → proxy → alt-api:3000
```

---

## 🚀 Démarrage rapide

### Option A — double-clic (le plus simple)

1. **`DOCKER_DEMARRER.bat`** → compile, construit, démarre et ouvre le navigateur.
2. **`DOCKER_ARRETER.bat`** → arrête les conteneurs.

> Si Docker Desktop n'est pas lancé, le script le démarre et attend que le moteur soit prêt.

### Option B — en ligne de commande

```powershell
cd "C:\Users\ahmed nour\Desktop\ms_project\alternative_transport_app"

# 1. Compiler l'app avec l'API en URL relative (proxy Nginx)
flutter build web --release --dart-define=API_BASE_URL=/api

# 2. Construire et démarrer
docker compose up -d --build

# 3. Vérifier
docker compose ps
```

Puis ouvrir **http://localhost:8080**

---

## 🔗 URLs utiles

| URL | Description |
|---|---|
| http://localhost:8080 | Application complète |
| http://localhost:8080/api/health | API via proxy Nginx |
| http://localhost:3000/api/health | API en direct (utile pour l'émulateur Android) |

**Identifiants** : `demo@alternative.tn` / `demo1234` (créé automatiquement au premier démarrage du conteneur API).

---

## 🧰 Commandes du quotidien

```powershell
docker compose ps                     # état des conteneurs
docker compose logs -f api            # logs du backend
docker compose logs -f web            # logs Nginx
docker compose restart api            # redémarrer l'API
docker compose up -d --build          # reconstruire après modification du backend
docker compose down                   # arrêter
docker compose down -v                # arrêter ET effacer la base SQLite
```

Après une modification du code **Flutter**, refaire uniquement :

```powershell
flutter build web --release --dart-define=API_BASE_URL=/api
```

(le volume `./build/web` est monté dans Nginx : pas besoin de `docker compose up`).

Après une modification du code **backend**, refaire uniquement :

```powershell
docker compose up -d --build api
```

---

## 📱 Utiliser le backend Docker depuis un téléphone / émulateur

L'API est exposée sur le port `3000` de la machine hôte.

| Cible | URL de l'API |
|---|---|
| Chrome / Windows | `http://localhost:3000/api` (auto) |
| Émulateur Android | `http://10.0.2.2:3000/api` (auto) |
| Téléphone physique (même Wi-Fi) | `flutter run --dart-define=API_BASE_URL=http://<IP_LOCALE>:3000/api` |

Sans Docker, le backend doit tourner sur la machine (`cd backend; npm install; npm start`).

---

## 🗄️ Données

La base SQLite est stockée dans un **volume Docker nommé** (`alternative-transport_api-data`), pas dans le dossier du projet :

- `docker compose down` → les données sont **conservées**
- `docker compose down -v` → la base est **supprimée** (le compte démo est recréé au démarrage suivant)

---

## 🩺 Dépannage

| Problème | Cause / solution |
|---|---|
| `failed to connect to the docker API` | Docker Desktop n'est pas démarré → lancer `DOCKER_DEMARRER.bat` |
| Page blanche sur `:8080` | `build/web` absent → refaire `flutter build web --release --dart-define=API_BASE_URL=/api` |
| `alt-api` en `unhealthy` | `docker compose logs api` — souvent un port 3000 déjà occupé |
| Le port 3000 est pris | Arrêter l'ancien `npm start`, ou changer `"3000:3000"` en `"3001:3000"` (et rebuild l'app) |
| L'app tombe en mode démo | L'API n'est pas joignable → vérifier http://localhost:8080/api/health |
