import React, { useState } from 'react';
import './Form.css';
import { Item } from '../types';

interface MovementFormProps {
  items: Item[];
  onMovementCreated: () => void;
  onCancel: () => void;
}

const MovementForm: React.FC<MovementFormProps> = ({ items, onMovementCreated, onCancel }) => {
  const [formData, setFormData] = useState({
    item_id: '',
    quantity: '',
    movement_type: 'IN'
  });
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      const response = await fetch(`/api/items/${formData.item_id}/movements`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          movement: {
            quantity: parseInt(formData.quantity),
            movement_type: formData.movement_type
          }
        }),
      });

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data.error || data.errors || 'Failed to create movement');
      }

      onMovementCreated();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="Form-container">
      <h2>Record Inventory Movement</h2>
      <form onSubmit={handleSubmit} className="Form">
        <div className="Form-group">
          <label htmlFor="item_id">Item *</label>
          <select
            id="item_id"
            value={formData.item_id}
            onChange={(e) => setFormData({ ...formData, item_id: e.target.value })}
            required
          >
            <option value="">Select an item</option>
            {items.map((item) => (
              <option key={item.id} value={item.id}>
                {item.name} ({item.sku}) - Stock: {item.stock} {item.unit}
              </option>
            ))}
          </select>
        </div>

        <div className="Form-group">
          <label htmlFor="movement_type">Movement Type *</label>
          <select
            id="movement_type"
            value={formData.movement_type}
            onChange={(e) => setFormData({ ...formData, movement_type: e.target.value })}
            required
          >
            <option value="IN">IN</option>
            <option value="OUT">OUT</option>
            <option value="ADJUSTMENT">ADJUSTMENT</option>
          </select>
        </div>

        <div className="Form-group">
          <label htmlFor="quantity">Quantity *</label>
          <input
            type="number"
            id="quantity"
            value={formData.quantity}
            onChange={(e) => setFormData({ ...formData, quantity: e.target.value })}
            min={formData.movement_type === 'ADJUSTMENT' ? undefined : '1'}
            required
          />
          <small>For ADJUSTMENT, use positive or negative values</small>
        </div>

        {error && <div className="Form-error">{error}</div>}

        <div className="Form-actions">
          <button type="submit" disabled={loading}>
            {loading ? 'Recording...' : 'Record Movement'}
          </button>
          <button type="button" onClick={onCancel}>
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
};

export default MovementForm;

