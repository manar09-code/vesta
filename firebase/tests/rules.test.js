import { readFileSync } from 'node:fs';
import { test, before, after, beforeEach } from 'node:test';
import {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} from '@firebase/rules-unit-testing';
import {
  doc, getDoc, setDoc, updateDoc, deleteDoc, writeBatch,
} from 'firebase/firestore';

let env;
const as = (uid) => env.authenticatedContext(uid).firestore();
const anon = () => env.unauthenticatedContext().firestore();

const makeListing = (owner, over = {}) => ({
  ownerId: owner, title: 'T', description: 'D', price: 100000,
  currency: 'TND', listingType: 'sale', propertyType: 'apartment',
  city: 'Tunis', photoCount: 0,
  createdAt: new Date(), updatedAt: new Date(), ...over,
});

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-vesta',
    firestore: {
      rules: readFileSync('../firestore.rules', 'utf8'),
      host: '127.0.0.1',
      port: 8085,
    },
  });
});

after(async () => { await env.cleanup(); });

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'users/alice'), { displayName: 'Alice', createdAt: new Date() });
    await setDoc(doc(db, 'users/alice/private/contact'), { email: 'a@x.tn' });
    await setDoc(doc(db, 'listings/l1'), makeListing('alice'));
    await setDoc(doc(db, 'listings/l1/photos/p0'), { base64: 'abc', createdAt: new Date() });
    await setDoc(doc(db, 'favorites/alice_l1'),
      { userId: 'alice', listingId: 'l1', createdAt: new Date() });
    await setDoc(doc(db, 'conversations/l1_bob'), {
      participantIds: ['bob', 'alice'], listingId: 'l1',
      lastMessage: '', lastMessageAt: new Date(),
    });
    await setDoc(doc(db, 'conversations/l1_bob/messages/m0'), {
      senderId: 'bob', text: 'hello', createdAt: new Date(),
    });
  });
});

// ---------- listings ----------
test('annonce valide creee par son proprietaire : OK', async () => {
  await assertSucceeds(setDoc(doc(as('alice'), 'listings/l2'), makeListing('alice')));
});
test('devise de 2 lettres : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l2'), makeListing('alice', { currency: 'TN' })));
});
test('location sans rentPeriod : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l2'), makeListing('alice', { listingType: 'rent' })));
});
test('location avec rentPeriod month : OK', async () => {
  await assertSucceeds(setDoc(doc(as('alice'), 'listings/l2'),
    makeListing('alice', { listingType: 'rent', rentPeriod: 'month' })));
});
test('propertyType hors liste : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l2'), makeListing('alice', { propertyType: 'castle' })));
});
test('photoCount a 6 : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l2'), makeListing('alice', { photoCount: 6 })));
});
test('annonce creee au nom d un autre : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l2'), makeListing('bob')));
});
test('modification par un autre utilisateur : refuse', async () => {
  await assertFails(updateDoc(doc(as('bob'), 'listings/l1'), { title: 'Hack' }));
});
test('lecture sans etre connecte : refuse', async () => {
  await assertFails(getDoc(doc(anon(), 'listings/l1')));
});
test('lecture par un utilisateur connecte : OK', async () => {
  await assertSucceeds(getDoc(doc(as('bob'), 'listings/l1')));
});

// ---------- photos ----------
test('photo p3 sans p1 ni p2 (id libre quelconque) : OK', async () => {
  const db = as('alice');
  const b = writeBatch(db);
  b.set(doc(db, 'listings/l1/photos/p3'), { base64: 'abc', createdAt: new Date() });
  b.update(doc(db, 'listings/l1'), { photoCount: 2 });
  await assertSucceeds(b.commit());
});
test('photo p5 : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l1/photos/p5'),
    { base64: 'abc', createdAt: new Date() }));
});
test('photo ajoutee par un autre que le proprietaire : refuse', async () => {
  await assertFails(setDoc(doc(as('bob'), 'listings/l1/photos/p2'),
    { base64: 'abc', createdAt: new Date() }));
});
test('photo trop grande (300000 caracteres) : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l1/photos/p2'),
    { base64: 'a'.repeat(300000), createdAt: new Date() }));
});
test('photo de 270000 caracteres : OK', async () => {
  await assertSucceeds(setDoc(doc(as('alice'), 'listings/l1/photos/p2'),
    { base64: 'a'.repeat(270000), createdAt: new Date() }));
});
test('mise a jour d une photo trop grande : refuse', async () => {
  await assertFails(updateDoc(doc(as('alice'), 'listings/l1/photos/p0'),
    { base64: 'a'.repeat(300000) }));
});
test('ajout de p1 + photoCount=2 dans un seul lot : OK', async () => {
  const db = as('alice');
  const b = writeBatch(db);
  b.set(doc(db, 'listings/l1/photos/p1'), { base64: 'abc', createdAt: new Date() });
  b.update(doc(db, 'listings/l1'), { photoCount: 2 });
  await assertSucceeds(b.commit());
});
test('creation annonce + photo p0 dans le meme lot : OK', async () => {
  const db = as('alice');
  const b = writeBatch(db);
  b.set(doc(db, 'listings/l2'), makeListing('alice', { photoCount: 1 }));
  b.set(doc(db, 'listings/l2/photos/p0'), { base64: 'abc', createdAt: new Date() });
  await assertSucceeds(b.commit());
});
test('suppression photo + annonce dans le meme lot : OK', async () => {
  const db = as('alice');
  const b = writeBatch(db);
  b.delete(doc(db, 'listings/l1/photos/p0'));
  b.delete(doc(db, 'listings/l1'));
  await assertSucceeds(b.commit());
});
test('suppression de photo par son proprietaire : OK', async () => {
  await assertSucceeds(deleteDoc(doc(as('alice'), 'listings/l1/photos/p0')));
});
test('suppression de photo par un autre : refuse', async () => {
  await assertFails(deleteDoc(doc(as('bob'), 'listings/l1/photos/p0')));
});

// ---------- users ----------
test('profil public lisible par un utilisateur connecte : OK', async () => {
  await assertSucceeds(getDoc(doc(as('bob'), 'users/alice')));
});
test('contact prive lu par un autre : refuse', async () => {
  await assertFails(getDoc(doc(as('bob'), 'users/alice/private/contact')));
});
test('contact prive lu par son proprietaire : OK', async () => {
  await assertSucceeds(getDoc(doc(as('alice'), 'users/alice/private/contact')));
});
test('profil modifie par un autre : refuse', async () => {
  await assertFails(updateDoc(doc(as('bob'), 'users/alice'), { displayName: 'X' }));
});

// ---------- favorites ----------
test('favori bob_l1 cree par bob : OK', async () => {
  await assertSucceeds(setDoc(doc(as('bob'), 'favorites/bob_l1'),
    { userId: 'bob', listingId: 'l1', createdAt: new Date() }));
});
test('favori avec l id d un autre : refuse', async () => {
  await assertFails(setDoc(doc(as('bob'), 'favorites/alice_l1'),
    { userId: 'bob', listingId: 'l1', createdAt: new Date() }));
});
test('lecture d un favori absent : OK', async () => {
  await assertSucceeds(getDoc(doc(as('bob'), 'favorites/bob_l9')));
});
test('lecture du favori d un autre : refuse', async () => {
  await assertFails(getDoc(doc(as('bob'), 'favorites/alice_l1')));
});

// ---------- conversations ----------
test('lecture d une conversation absente : OK', async () => {
  await assertSucceeds(getDoc(doc(as('carol'), 'conversations/l1_carol')));
});
test('acheteur cree la conversation l1_carol avec le proprietaire : OK', async () => {
  await assertSucceeds(setDoc(doc(as('carol'), 'conversations/l1_carol'), {
    participantIds: ['carol', 'alice'], listingId: 'l1',
    lastMessage: '', lastMessageAt: new Date(),
  }));
});
test('proprietaire qui ouvre une conversation sur sa propre annonce : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'conversations/l1_alice'), {
    participantIds: ['alice', 'alice'], listingId: 'l1',
    lastMessage: '', lastMessageAt: new Date(),
  }));
});
test('conversation avec un mauvais id : refuse', async () => {
  await assertFails(setDoc(doc(as('carol'), 'conversations/wrong'), {
    participantIds: ['carol', 'alice'], listingId: 'l1',
    lastMessage: '', lastMessageAt: new Date(),
  }));
});
test('autre participant different du proprietaire : refuse', async () => {
  await assertFails(setDoc(doc(as('carol'), 'conversations/l1_carol'), {
    participantIds: ['carol', 'bob'], listingId: 'l1',
    lastMessage: '', lastMessageAt: new Date(),
  }));
});
test('lecture par un non-participant : refuse', async () => {
  await assertFails(getDoc(doc(as('carol'), 'conversations/l1_bob')));
});
test('lecture par un participant : OK', async () => {
  await assertSucceeds(getDoc(doc(as('bob'), 'conversations/l1_bob')));
});
test('changer participantIds a l update : refuse', async () => {
  await assertFails(updateDoc(doc(as('bob'), 'conversations/l1_bob'),
    { participantIds: ['bob', 'carol'] }));
});
test('changer listingId a l update : refuse', async () => {
  await assertFails(updateDoc(doc(as('bob'), 'conversations/l1_bob'), { listingId: 'l9' }));
});
test('mettre a jour lastMessage : OK', async () => {
  await assertSucceeds(updateDoc(doc(as('bob'), 'conversations/l1_bob'), { lastMessage: 'salut' }));
});

// ---------- messages ----------
test('message ecrit par un participant : OK', async () => {
  await assertSucceeds(setDoc(doc(as('bob'), 'conversations/l1_bob/messages/m1'),
    { senderId: 'bob', text: 'hi', createdAt: new Date() }));
});
test('message avec un senderId usurpe : refuse', async () => {
  await assertFails(setDoc(doc(as('bob'), 'conversations/l1_bob/messages/m1'),
    { senderId: 'alice', text: 'hi', createdAt: new Date() }));
});
test('message ecrit par un non-participant : refuse', async () => {
  await assertFails(setDoc(doc(as('carol'), 'conversations/l1_bob/messages/m1'),
    { senderId: 'carol', text: 'hi', createdAt: new Date() }));
});
test('message lu par un non-participant : refuse', async () => {
  await assertFails(getDoc(doc(as('carol'), 'conversations/l1_bob/messages/m0')));
});
test('message modifie : refuse', async () => {
  await assertFails(updateDoc(doc(as('bob'), 'conversations/l1_bob/messages/m0'), { text: 'edit' }));
});
test('message supprime : refuse', async () => {
  await assertFails(deleteDoc(doc(as('bob'), 'conversations/l1_bob/messages/m0')));
});

// ---------- hardening (VST-71) ----------
test('message de 2000 caracteres : OK', async () => {
  await assertSucceeds(setDoc(doc(as('bob'), 'conversations/l1_bob/messages/m1'),
    { senderId: 'bob', text: 'a'.repeat(2000), createdAt: new Date() }));
});
test('message de 2001 caracteres : refuse', async () => {
  await assertFails(setDoc(doc(as('bob'), 'conversations/l1_bob/messages/m1'),
    { senderId: 'bob', text: 'a'.repeat(2001), createdAt: new Date() }));
});
test('profil : createdAt non modifiable', async () => {
  await assertFails(updateDoc(doc(as('alice'), 'users/alice'), { createdAt: new Date() }));
});
test('contact : email qui n est pas un texte : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'users/alice/private/contact'), { email: 12345 }));
});
test('contact : phone qui n est pas un texte : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'users/alice/private/contact'),
    { email: 'a@x.tn', phone: 12345 }));
});
test('contact : email seul : OK', async () => {
  await assertSucceeds(setDoc(doc(as('alice'), 'users/alice/private/contact'),
    { email: 'b@x.tn' }));
});
test('contact : email et phone en texte : OK', async () => {
  await assertSucceeds(setDoc(doc(as('alice'), 'users/alice/private/contact'),
    { email: 'b@x.tn', phone: '+21612345678' }));
});
test('annonce : createdAt non modifiable', async () => {
  await assertFails(updateDoc(doc(as('alice'), 'listings/l1'), { createdAt: new Date() }));
});
test('annonce : le proprietaire modifie le titre : OK', async () => {
  await assertSucceeds(updateDoc(doc(as('alice'), 'listings/l1'), { title: 'Nouveau titre' }));
});

// ---------- photos (VST-35) ----------
test('photo lue par un utilisateur connecte : OK', async () => {
  await assertSucceeds(getDoc(doc(as('bob'), 'listings/l1/photos/p0')));
});
test('photo lue sans etre connecte : refuse', async () => {
  await assertFails(getDoc(doc(anon(), 'listings/l1/photos/p0')));
});
test('proprietaire ajoute la photo p1 : OK', async () => {
  await assertSucceeds(setDoc(doc(as('alice'), 'listings/l1/photos/p1'),
    { base64: 'abc', createdAt: new Date() }));
});
test('les cinq photos p0 a p4 avec photoCount 5 dans un lot : OK', async () => {
  const db = as('alice');
  const b = writeBatch(db);
  for (const id of ['p1', 'p2', 'p3', 'p4']) {
    b.set(doc(db, `listings/l1/photos/${id}`), { base64: 'abc', createdAt: new Date() });
  }
  b.update(doc(db, 'listings/l1'), { photoCount: 5 });
  await assertSucceeds(b.commit());
});
test('photo p10 : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l1/photos/p10'),
    { base64: 'abc', createdAt: new Date() }));
});
test('photo avec un id libre (photo1) : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l1/photos/photo1'),
    { base64: 'abc', createdAt: new Date() }));
});
test('photo de 280000 caracteres exactement : OK', async () => {
  await assertSucceeds(setDoc(doc(as('alice'), 'listings/l1/photos/p2'),
    { base64: 'a'.repeat(280000), createdAt: new Date() }));
});
test('photo de 280001 caracteres : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l1/photos/p2'),
    { base64: 'a'.repeat(280001), createdAt: new Date() }));
});
test('photo sans champ base64 : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l1/photos/p2'),
    { createdAt: new Date() }));
});
test('photo avec un base64 qui n est pas un texte : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l1/photos/p2'),
    { base64: 12345, createdAt: new Date() }));
});
test('mise a jour d une photo par un autre utilisateur : refuse', async () => {
  await assertFails(updateDoc(doc(as('bob'), 'listings/l1/photos/p0'), { base64: 'xyz' }));
});
test('photo avec un champ supplementaire volumineux : refuse', async () => {
  await assertFails(setDoc(doc(as('alice'), 'listings/l1/photos/p2'),
    { base64: 'abc', createdAt: new Date(), junk: 'a'.repeat(500000) }));
});