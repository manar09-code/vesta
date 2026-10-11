// Prototype de maquettes : données et actions locales, sans Firebase ni authentification.
const listings = [
  { id: 'marsa', title: 'Villa des Oliviers', location: 'La Marsa, Tunis', type: 'Villa', transaction: 'vente', price: 1250000, area: 240, rooms: 4, baths: 3, image: 'assets/villa.svg', description: 'Une villa lumineuse avec terrasse et jardin, à deux pas de la mer. De beaux espaces pour imaginer votre prochain quotidien.' },
  { id: 'lac', title: 'L’Appartement Lumière', location: 'Les Berges du Lac, Tunis', type: 'Appartement', transaction: 'vente', price: 420000, area: 108, rooms: 3, baths: 2, image: 'assets/apartment.svg', description: 'Un appartement chaleureux avec un séjour ouvert et de grandes baies vitrées. Un cadre paisible, proche des commerces et des services.' },
  { id: 'sousse', title: 'Le Patio Bleu', location: 'Sousse, Sousse', type: 'Appartement', transaction: 'location', price: 1800, area: 82, rooms: 2, baths: 1, image: 'assets/coast.svg', description: 'Un cocon clair et accueillant avec un patio ensoleillé, idéal pour profiter de la ville et de la côte.' },
  { id: 'menzah', title: 'Maison des Jasmins', location: 'El Menzah, Tunis', type: 'Villa', transaction: 'location', price: 3200, area: 165, rooms: 3, baths: 2, image: 'assets/villa.svg', description: 'Une maison familiale avec jardin et espace de vie généreux, dans un quartier calme et bien desservi.' }
];
const state = { transaction: 'all', favorites: new Set(), favoritesOnly: false, selectedImage: 0, listingId: 'marsa' };
const $ = (selector) => document.querySelector(selector);
const money = (amount) => new Intl.NumberFormat('fr-FR').format(amount) + ' TND';
const normalized = (text) => text.toLocaleLowerCase('fr').normalize('NFD').replace(/[\u0300-\u036f]/g, '');
let toastTimer;

function showToast(message) {
  const toast = $('#toast');
  toast.textContent = message;
  toast.hidden = false;
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => { toast.hidden = true; }, 3500);
}
function navigate(hash) {
  if (location.hash === hash) renderRoute();
  else location.hash = hash;
}
function renderRoute() {
  const hash = decodeURIComponent(location.hash.slice(1));
  const isDetail = hash.startsWith('detail-') && listings.some((item) => item.id === hash.slice(7));
  const isList = hash === 'annonces' || hash === 'favoris';
  $('#auth-screen').hidden = isDetail || isList;
  $('#list-screen').hidden = !isList;
  $('#detail-screen').hidden = !isDetail;
  if (isDetail) {
    state.listingId = hash.slice(7);
    state.selectedImage = 0;
    renderDetail();
  } else if (isList) {
    state.favoritesOnly = hash === 'favoris';
    renderListings();
  } else {
    setAuthTab(hash === 'inscription' ? 'signup' : 'login');
  }
  window.scrollTo(0, 0);
}
function setAuthTab(tab) {
  const signup = tab === 'signup';
  for (const [buttonId, panelId, active] of [['login-tab', 'login-panel', !signup], ['signup-tab', 'signup-panel', signup]]) {
    const button = $('#' + buttonId);
    button.classList.toggle('is-active', active);
    button.setAttribute('aria-selected', String(active));
    button.tabIndex = active ? 0 : -1;
    $('#' + panelId).hidden = !active;
  }
}
function formError(form, message, field) {
  const error = $('#' + form + '-error');
  error.textContent = message;
  error.hidden = false;
  if (field) field.focus();
}
function validateAuth(formName) {
  const form = $('#' + formName + '-form');
  const email = form.elements.email;
  const password = form.elements.password;
  const error = $('#' + formName + '-error');
  error.hidden = true;
  if (formName === 'signup' && !form.elements.name.value.trim()) return formError(formName, 'Indiquez votre nom.', form.elements.name);
  if (!email.validity.valid || !email.value.trim()) return formError(formName, 'Entrez une adresse e-mail valide.', email);
  if (password.value.length < 6) return formError(formName, 'Le mot de passe doit contenir au moins 6 caractères.', password);
  if (formName === 'signup' && password.value !== form.elements.confirm.value) return formError(formName, 'Les mots de passe ne correspondent pas.', form.elements.confirm);
  navigate('#annonces');
  showToast('Mode démo : navigation uniquement, aucune donnée enregistrée.');
}
function resetFilters() {
  $('#search-input').value = '';
  $('#type-filter').value = 'all';
  $('#price-filter').value = '';
  state.transaction = 'all';
  renderListings();
}
function renderListings() {
  const query = normalized($('#search-input').value.trim());
  const type = $('#type-filter').value;
  const maxPrice = Number($('#price-filter').value);
  const filtered = listings.filter((item) =>
    (!state.favoritesOnly || state.favorites.has(item.id)) &&
    (state.transaction === 'all' || state.transaction === item.transaction) &&
    (type === 'all' || item.type === type) &&
    (!query || normalized(`${item.title} ${item.location} ${item.type}`).includes(query)) &&
    (!$('#price-filter').value || item.price <= maxPrice)
  );
  $('#list-heading').innerHTML = state.favoritesOnly ? 'Vos biens<br><em>préférés.</em>' : 'Le bon endroit<br>pour <em>vivre mieux.</em>';
  $('.section-head h2').textContent = state.favoritesOnly ? 'Mes favoris' : 'Biens à explorer';
  $('#result-count').textContent = `${filtered.length} bien${filtered.length > 1 ? 's' : ''} trouvé${filtered.length > 1 ? 's' : ''}`;
  document.querySelectorAll('[data-transaction]').forEach((button) => {
    const active = button.dataset.transaction === state.transaction;
    button.classList.toggle('is-active', active);
    button.setAttribute('aria-pressed', String(active));
  });
  document.querySelectorAll('[data-nav]').forEach((button) => {
    const active = button.dataset.nav === (state.favoritesOnly ? 'favorites' : 'explore');
    button.classList.toggle('is-active', active);
    if (active) button.setAttribute('aria-current', 'page');
    else button.removeAttribute('aria-current');
  });
  $('#listing-cards').innerHTML = filtered.map((item) => `
    <article class="listing-card"><div class="card-media"><button type="button" class="card-image-link" data-detail="${item.id}" aria-label="Voir ${item.title}"><img src="${item.image}" alt="Illustration de ${item.title}"></button><span class="card-badge">${item.transaction === 'vente' ? 'À vendre' : 'À louer'}</span><button type="button" class="card-heart" data-favorite="${item.id}" aria-label="${state.favorites.has(item.id) ? 'Retirer des favoris' : 'Ajouter aux favoris'} : ${item.title}" aria-pressed="${state.favorites.has(item.id)}">${state.favorites.has(item.id) ? '♥' : '♡'}</button></div><div class="card-body"><div class="card-body-head"><span>${item.type}</span><span>✦ Sélection Vesta</span></div><h3><button type="button" data-detail="${item.id}">${item.title}</button></h3><p class="card-location">⌖ ${item.location}</p><div class="card-foot"><div><strong>${money(item.price)}</strong>${item.transaction === 'location' ? '<small> / mois</small>' : ''}</div><span>${item.area} m² · ${item.rooms} ch.</span></div></div></article>`).join('');
  $('#empty-state').hidden = filtered.length > 0;
  if (!filtered.length) {
    const noFavorites = state.favoritesOnly && !state.favorites.size;
    $('#empty-state h3').textContent = noFavorites ? 'Aucun favori pour le moment' : 'Aucun bien trouvé';
    $('#empty-state p').textContent = noFavorites ? 'Enregistrez un bien avec le cœur pour le retrouver ici.' : 'Essayez une autre ville ou élargissez vos filtres.';
    $('#empty-reset').textContent = noFavorites ? 'Voir les annonces' : 'Effacer les filtres';
  }
}
function renderDetail() {
  const item = listings.find((listing) => listing.id === state.listingId);
  if (!item) return;
  const gallery = [item.image, 'assets/living-room.svg', 'assets/kitchen.svg'];
  $('#detail-image').src = gallery[state.selectedImage];
  $('#detail-image').alt = `Illustration ${state.selectedImage + 1} du bien ${item.title}`;
  $('#detail-counter').textContent = `Illustration ${state.selectedImage + 1} / ${gallery.length}`;
  $('#detail-transaction').textContent = item.transaction === 'vente' ? 'À vendre' : 'À louer';
  $('#detail-type').textContent = item.type;
  $('#detail-title').textContent = item.title;
  $('#detail-location').textContent = '⌖ ' + item.location;
  $('#detail-price').textContent = money(item.price);
  $('#detail-period').textContent = item.transaction === 'location' ? '/ mois' : '';
  $('#footer-price').textContent = money(item.price) + (item.transaction === 'location' ? ' / mois' : '');
  $('#detail-area').textContent = `${item.area} m² de surface`;
  $('#detail-rooms').textContent = `${item.rooms} chambres`;
  $('#detail-baths').textContent = `${item.baths} s. de bain`;
  $('#detail-description').textContent = item.description;
  $('#detail-map-location').textContent = item.location;
  const favorite = state.favorites.has(item.id);
  $('#detail-favorite').textContent = favorite ? '♥' : '♡';
  $('#detail-favorite').setAttribute('aria-pressed', String(favorite));
  $('#detail-favorite').setAttribute('aria-label', favorite ? 'Retirer des favoris' : 'Ajouter aux favoris');
  $('#detail-gallery').innerHTML = gallery.map((image, index) => `<button type="button" class="gallery-button" data-image="${index}" aria-label="Afficher l’illustration ${index + 1}" aria-pressed="${state.selectedImage === index}"><img src="${image}" alt=""></button>`).join('');
}
function toggleFavorite(id) {
  if (state.favorites.has(id)) state.favorites.delete(id);
  else state.favorites.add(id);
  if ($('#detail-screen').hidden) renderListings();
  else renderDetail();
  showToast(state.favorites.has(id) ? 'Bien ajouté aux favoris (mode démo).' : 'Bien retiré des favoris (mode démo).');
}

document.querySelectorAll('.auth-tab').forEach((button) => {
  button.addEventListener('click', () => navigate(button.id === 'signup-tab' ? '#inscription' : '#connexion'));
  button.addEventListener('keydown', (event) => {
    if (!['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return;
    event.preventDefault();
    const tab = event.key === 'ArrowLeft' || event.key === 'Home' ? 'login' : 'signup';
    navigate(tab === 'signup' ? '#inscription' : '#connexion');
    $('#' + tab + '-tab').focus();
  });
});
for (const formName of ['login', 'signup']) {
  $('#' + formName + '-form').addEventListener('submit', (event) => { event.preventDefault(); validateAuth(formName); });
}
document.querySelectorAll('[data-toggle-password]').forEach((button) => button.addEventListener('click', () => {
  const field = document.getElementById(button.dataset.togglePassword);
  const visible = field.type === 'password';
  field.type = visible ? 'text' : 'password';
  button.textContent = visible ? 'Masquer' : 'Afficher';
  button.setAttribute('aria-label', (visible ? 'Masquer' : 'Afficher') + ' le mot de passe');
}));
$('#demo-entry').addEventListener('click', () => navigate('#annonces'));
$('#search-input').addEventListener('input', renderListings);
$('#type-filter').addEventListener('change', renderListings);
$('#price-filter').addEventListener('input', renderListings);
$('#reset-filters').addEventListener('click', resetFilters);
$('#empty-reset').addEventListener('click', () => { if (state.favoritesOnly && !state.favorites.size) navigate('#annonces'); else resetFilters(); });
$('#filters-toggle').addEventListener('click', () => {
  const panel = $('#filter-panel');
  panel.hidden = !panel.hidden;
  $('#filters-toggle').setAttribute('aria-expanded', String(!panel.hidden));
});
document.querySelectorAll('[data-transaction]').forEach((button) => button.addEventListener('click', () => {
  state.transaction = button.dataset.transaction;
  renderListings();
}));
$('#listing-cards').addEventListener('click', (event) => {
  const favorite = event.target.closest('[data-favorite]');
  if (favorite) return toggleFavorite(favorite.dataset.favorite);
  const detail = event.target.closest('[data-detail]');
  if (detail) navigate('#detail-' + detail.dataset.detail);
});
document.querySelectorAll('[data-nav]').forEach((button) => button.addEventListener('click', () => {
  navigate(button.dataset.nav === 'favorites' ? '#favoris' : button.dataset.nav === 'account' ? '#connexion' : '#annonces');
}));
$('#back-to-list').addEventListener('click', () => navigate(state.favoritesOnly ? '#favoris' : '#annonces'));
$('#detail-favorite').addEventListener('click', () => toggleFavorite(state.listingId));
$('#detail-gallery').addEventListener('click', (event) => {
  const button = event.target.closest('[data-image]');
  if (button) { state.selectedImage = Number(button.dataset.image); renderDetail(); }
});
$('#contact-button').addEventListener('click', () => showToast('Messagerie prévue dans une prochaine tâche : action non disponible dans la maquette.'));
window.addEventListener('hashchange', renderRoute);
renderRoute();
