# Tunisian Arabic glossary and tone guide (ar-TN)

Status: **draft**, to be read by Manar and by one Tunisian reader outside the team (VST-77). Terms marked "?" need a native check.
Source of the existing terms: `flutter-app/lib/l10n/app_ar.arb` and `docs/offer-types.md` section 6.

## 1. Tone guide

1. Talk to the user in the singular, friendly and polite, like the current app texts ("ادخل باش تكمل").
2. Short sentences. One idea per sentence.
3. Buttons are verbs in the imperative: ادخل, ابعث, احذف, احفظ.
4. Messages and hints may use Tunisian words (باش, برشا, ما ... ش). Titles and buttons prefer words that every Arabic reader understands.
5. No mix of scripts in one sentence. Exceptions: numbers (Latin digits), `TND`, and the name Vesta.
6. Numbers in Latin digits: 450, 120 000. Never Arabic-Indic digits (٤٥٠).
7. Arabic is written right to left. Numbers and `TND` stay left to right inside Arabic sentences.
8. Do not translate word for word from French or English. Write what a Tunisian would really say.

## 2. Money (TND)

| Rule | English | Français | العربية |
|---|---|---|---|
| Sale | `120 000 TND` | `120 000 TND` | `120 000 TND` |
| Per night | `150 TND / night` | `150 TND / nuit` | `150 TND / ليلة` |
| Per month | `900 TND / month` | `900 TND / mois` | `900 TND / شهر` |
| Per year | `5 000 TND / year` | `5 000 TND / an` | `5 000 TND / سنة` |

- Thousands separator: one non-breaking space, in the three languages.
- The amount comes first, then `TND`, then the unit. `formatPrice` is the only function that formats a price (spec VST-100).
- In right-to-left screens the amount and `TND` stay in one left-to-right block. To check on a phone set to Arabic.
- Note: the ticket VST-77 writes `TND 450`, the merged spec writes `450 TND`. This file follows the spec. To confirm with Manar.

## 3. Terms: listings and properties

| Key term | English | Français | العربية (تونسي) | Note |
|---|---|---|---|---|
| listing | Listing | Annonce | إعلان | app_ar |
| offer.sale | For sale | À vendre | للبيع | spec |
| offer.rent | For rent | À louer | للكراء | spec |
| offer.stay | Stay | Séjour | إقامة | spec |
| tab.buy | Buy | Acheter | شراء | spec |
| tab.rent | Rent | Louer | كراء | spec |
| tab.stay | Stay | Séjourner | إقامة | spec |
| price | Price | Prix | السوم | Tunisian word, app_ar |
| city | City | Ville | المدينة | app_ar |
| governorate | Governorate | Gouvernorat | الولاية | |
| apartment | Apartment | Appartement | شقة | app_ar |
| house | House | Maison | دار | app_ar |
| villa | Villa | Villa | فيلا | app_ar |
| studio | Studio | Studio | ستوديو | app_ar |
| riad | Riad | Riad | رياض | app_ar |
| guest house | Guest house | Maison d'hôtes | دار ضيافة | app_ar |
| land | Land | Terrain | أرض | ? |
| commercial | Commercial | Local commercial | محل تجاري | ? |
| rooms | Rooms | Chambres | بيوت | in Tunisian, بيت means a room (app_ar) |
| bathrooms | Bathrooms | Salles de bain | بيوت الماء | app_ar, ? |
| area | Area (m²) | Surface (m²) | المساحة (م²) | app_ar |
| furnished | Furnished | Meublé | مفروش | spec |
| negotiable | Negotiable | Négociable | قابل للتفاوض | spec |
| status.sold | Sold | Vendu | مباع | spec |
| status.rented | Rented | Loué | مكري | spec |
| status.reserved | Reserved | Réservé | محجوز | spec |
| no longer available | No longer available | N'est plus disponible | ما عادش متوفر | replaces the stiffer "لم يعد متاحا" |
| guest | Guest | Voyageur | ضيف | |
| host | Host | Hôte | المضيف | |
| owner | Owner | Propriétaire | المالك | app_ar |

## 4. Terms: app actions

| Key term | English | Français | العربية (تونسي) | Note |
|---|---|---|---|---|
| favorites | Favorites | Favoris | المفضلة | app_ar |
| search | Search | Recherche | بحث | app_ar |
| explore | Explore | Explorer | اكتشف | app_ar |
| filters | Filters | Filtres | فلاتر | ? or التصفية |
| all | All | Tous | الكل | filter chip |
| map | Map | Carte | الخريطة | app_ar |
| chat | Chat | Messages | الرسائل | app_ar |
| message | Message | Message | رسالة | |
| send | Send | Envoyer | ابعث | imperative, Tunisian |
| notifications | Notifications | Notifications | الإشعارات | app_ar |
| profile | Profile | Profil | حسابي | app_ar |
| settings | Settings | Paramètres | الإعدادات | |
| language | Language | Langue | اللغة | app_ar |
| log in | Log in | Se connecter | دخول | app_ar, button |
| sign up | Sign up | Créer un compte | إنشاء حساب | app_ar |
| log out | Log out | Se déconnecter | خروج | app_ar |
| email | Email | E-mail | البريد الإلكتروني | app_ar |
| password | Password | Mot de passe | كلمة السر | app_ar, Tunisian |
| full name | Full name | Nom complet | الاسم الكامل | app_ar |
| publish | Publish | Publier | انشر إعلان | app_ar |
| save | Save | Enregistrer | احفظ | |
| edit | Edit | Modifier | بدّل | ? |
| delete | Delete | Supprimer | احذف | app_ar |
| cancel | Cancel | Annuler | إلغاء | |
| retry | Try again | Réessayer | عاود جرّب | app_ar |
| remove | Remove | Retirer | شيل | ? or احذف |
| accept | Accept | Accepter | اقبل | |
| decline | Decline | Refuser | ارفض | |
| booking request | Booking request | Demande de réservation | طلب حجز | Sprint 3 |
| visit request | Visit request | Demande de visite | طلب زيارة | Sprint 3 |
| call | Call | Appeler | اتصل | |
| WhatsApp | WhatsApp | WhatsApp | واتساب | brand name stays in Latin letters in a Latin context |
| share | Share | Partager | شارك | |
| report | Report | Signaler | بلّغ | ? |
| block | Block | Bloquer | احظر | ? |
| delete account | Delete account | Supprimer mon compte | احذف حسابي | |
| review | Review | Avis | رأي | ? |
| rating | Rating | Note | التقييم | |
| gallery | Gallery | Galerie | المعرض | app_ar |
| camera | Camera | Appareil photo | الكاميرا | app_ar |
| photos | Photos | Photos | الصور | app_ar |
| verified | Verified | Vérifié | موثّق | badge |
| coming soon | Coming soon | Bientôt disponible | قريبا | app_ar |

## 5. Terms: stay and amenities

| Key term | English | Français | العربية (تونسي) | Note |
|---|---|---|---|---|
| per night | per night | / nuit | / ليلة | spec |
| per month | per month | / mois | / شهر | spec |
| per year | per year | / an | / سنة | spec |
| check-in | Check-in | Arrivée | الوصول | ? |
| check-out | Check-out | Départ | المغادرة | ? |
| max guests | Max guests | Voyageurs max | أقصى عدد ضيوف | |
| beds | Beds | Lits | الفرشات