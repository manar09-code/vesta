import {useRef, useState} from 'react';
import {Listing, Transaction} from '../models/listing';

const ILLUSTRATIONS = ['villa', 'apartment', 'coast'];

/**
 * Contrôleur du formulaire de publication : champs, validation en
 * français et création de l'annonce (démo, en mémoire).
 * Miroir de `PublishController` côté Flutter.
 */
export function usePublishController() {
  const [transaction, setTransaction] = useState<Transaction>('vente');
  const [type, setType] = useState('Villa');
  const [title, setTitle] = useState('');
  const [location, setLocation] = useState('');
  const [price, setPrice] = useState('');
  const [area, setArea] = useState('');
  const [rooms, setRooms] = useState('');
  const [baths, setBaths] = useState('');
  const [description, setDescription] = useState('');
  const [error, setError] = useState<string | null>(null);

  const illustrationIndex = useRef(0);

  /** Valide le formulaire ; retourne l'annonce créée ou null. */
  function validate(): Listing | null {
    let nextError: string | null = null;
    if (title.trim().length === 0) {
      nextError = 'Indiquez un titre pour l’annonce.';
    } else if (location.trim().length === 0) {
      nextError = 'Indiquez la ville ou le quartier.';
    } else if (!/^\d+$/.test(price.trim())) {
      nextError = 'Entrez un prix valide en TND.';
    } else if (!/^\d+$/.test(area.trim())) {
      nextError = 'Entrez une surface valide en m².';
    }
    setError(nextError);
    if (nextError !== null) {
      return null;
    }

    const illustration = ILLUSTRATIONS[illustrationIndex.current % ILLUSTRATIONS.length];
    illustrationIndex.current += 1;

    return {
      id: `pub-${Date.now()}`,
      title: title.trim(),
      location: location.trim(),
      type,
      transaction,
      price: Number.parseInt(price.trim(), 10),
      area: Number.parseInt(area.trim(), 10),
      rooms: /^\d+$/.test(rooms.trim()) ? Number.parseInt(rooms.trim(), 10) : 1,
      baths: /^\d+$/.test(baths.trim()) ? Number.parseInt(baths.trim(), 10) : 1,
      image: illustration,
      description:
        description.trim().length === 0
          ? 'Annonce publiée depuis l’application Vesta.'
          : description.trim(),
    };
  }

  function clear() {
    setTitle('');
    setLocation('');
    setPrice('');
    setArea('');
    setRooms('');
    setBaths('');
    setDescription('');
    setTransaction('vente');
    setType('Villa');
    setError(null);
  }

  return {
    transaction,
    setTransaction,
    type,
    setType,
    title,
    setTitle,
    location,
    setLocation,
    price,
    setPrice,
    area,
    setArea,
    rooms,
    setRooms,
    baths,
    setBaths,
    description,
    setDescription,
    error,
    validate,
    clear,
  };
}
