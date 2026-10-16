# 🍔 Hungry — Food Ordering App

A Flutter food-delivery app (Arabic-friendly error messages) backed by **Supabase**
(Auth + Postgres + Realtime). Browse burgers & sides, customise an order, manage a live cart,
check out, and track order history.

## ✨ Features

- 🔐 Email/password authentication (sign up, login, logout)
- 👤 User profile
- 🏠 Home: product list, category filter, search by name, skeleton loading
- 🍟 Product details: spice level slider, toppings, side options, quantity
- 🛒 Cart: real-time sync (Supabase Realtime), update quantity, remove items
- 💳 Checkout & order creation
- 📜 Order history with live updates, delete order

## 🧱 Tech Stack

| Layer            | Choice                                                   |
| ---------------- | -------------------------------------------------------- |
| UI               | Flutter (Material), `flutter_svg`, `gap`, `skeletonizer` |
| State management | `flutter_bloc` (Cubit)                                   |
| Backend          | `supabase_flutter` (Auth, Postgres, Realtime)            |
| Config           | `flutter_dotenv`                                         |

## 🗂 Architecture

Feature-first structure, with a repository + Cubit per feature:

```
lib/
├── core/        # constants, errors (Failure), Supabase service, utils
├── features/
│   ├── auth/    # cubit · data(repo) · view · widgets
│   ├── home/    # products, categories, search, details
│   ├── cart/
│   └── oreders/ # checkout, order history
├── shared/      # reusable buttons, text fields, snackbars
├── root.dart    # bottom navigation
└── splash.dart
```

## 🚀 Getting Started

```bash
git clone <https://github.com/HASSAN-FADAI/food_app>
cd hungry_food
flutter pub get
flutter run
```

### Supabase setup

1. Create a Supabase project and copy **Project URL** and **anon (public) key** into `.env`.
2. Create tables: `profiles`, `products`, `cart_items`, `orders`, `order_items`.
3. Run [`supabase/rls_policies.sql`](supabase/rls_policies.sql) to enable Row Level Security.

   with **Auto Confirm User** enabled.

## 🔒 Security Notes

- Only the public **anon key** is used in the client. The `service_role` key must **never** be in the app or the repo.
- `.env` is git-ignored; use `.env.example` as a template.
- Since the anon key is visible inside any built app, data protection relies on **Row Level Security** — see `supabase/rls_policies.sql`.

## 🗺 Roadmap

**Done ✅**

- [x] Authentication (sign up / login / logout)
- [x] Product listing, categories, search
- [x] Product customisation (spice, toppings, sides)
- [x] Real-time cart
- [x] Checkout & order history

**Planned 🔜**

- [ ] Email verification & password reset
- [ ] Row Level Security for every table (policies provided)
- [ ] Push notifications for order status (FCM)
- [ ] Editable delivery address & profile photo
- [ ] Online payment integration
- [ ] Favorites & product reviews
- [ ] Server-side order total calculation (Postgres function / Edge Function)
- [ ] Dark mode & localization (AR/EN)
- [ ] Unit/widget tests + CI (GitHub Actions)
