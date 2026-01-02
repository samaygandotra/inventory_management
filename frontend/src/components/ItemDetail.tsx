import React, { useState, useEffect } from 'react';
import './ItemDetail.css';
import { Item, Movement } from '../types';
import MovementForm from './MovementForm';

interface ItemDetailProps {
  item: Item;
  onBack: () => void;
  onMovementCreated: () => void;
}

const ItemDetail: React.FC<ItemDetailProps> = ({ item, onBack, onMovementCreated }) => {
  const [movements, setMovements] = useState<Movement[]>([]);
  const [showMovementForm, setShowMovementForm] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchMovements();
  }, [item.id]);

  const fetchMovements = async () => {
    try {
      const response = await fetch(`/api/items/${item.id}/movements`);
      const data = await response.json();
      setMovements(data.data || []);
    } catch (error) {
      console.error('Error fetching movements:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleMovementCreated = () => {
    fetchMovements();
    onMovementCreated();
    setShowMovementForm(false);
  };

  return (
    <div className="ItemDetail">
      <button onClick={onBack} className="ItemDetail-back">← Back to List</button>
      
      <div className="ItemDetail-header">
        <h2>{item.name}</h2>
        <div className="ItemDetail-info">
          <p><strong>SKU:</strong> {item.sku}</p>
          <p><strong>Unit:</strong> {item.unit}</p>
          <p><strong>Current Stock:</strong> <span className={item.stock < 10 ? 'low-stock' : ''}>{item.stock} {item.unit}</span></p>
        </div>
        <button onClick={() => setShowMovementForm(!showMovementForm)}>
          {showMovementForm ? 'Cancel' : 'Record Movement'}
        </button>
      </div>

      {showMovementForm && (
        <MovementForm
          items={[item]}
          onMovementCreated={handleMovementCreated}
          onCancel={() => setShowMovementForm(false)}
        />
      )}

      <div className="ItemDetail-movements">
        <h3>Movement History</h3>
        {loading ? (
          <p>Loading...</p>
        ) : movements.length === 0 ? (
          <p>No movements recorded yet.</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Quantity</th>
              </tr>
            </thead>
            <tbody>
              {movements.map((movement) => (
                <tr key={movement.id}>
                  <td>{new Date(movement.inserted_at).toLocaleString()}</td>
                  <td className={`movement-type-${movement.movement_type.toLowerCase()}`}>
                    {movement.movement_type}
                  </td>
                  <td className={movement.movement_type === 'OUT' ? 'negative' : 'positive'}>
                    {movement.movement_type === 'OUT' ? '-' : '+'}{movement.quantity}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
};

export default ItemDetail;

