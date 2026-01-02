import React, { useState } from 'react';
import './Form.css';

interface CreateItemFormProps {
  onItemCreated: () => void;
  onCancel: () => void;
}

const CreateItemForm: React.FC<CreateItemFormProps> = ({ onItemCreated, onCancel }) => {
  const [formData, setFormData] = useState({
    name: '',
    sku: '',
    unit: 'pcs'
  });
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      const response = await fetch('/api/items', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ item: formData }),
      });

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data.errors || 'Failed to create item');
      }

      onItemCreated();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="Form-container">
      <h2>Create Item</h2>
      <form onSubmit={handleSubmit} className="Form">
        <div className="Form-group">
          <label htmlFor="name">Name *</label>
          <input
            type="text"
            id="name"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            required
          />
        </div>

        <div className="Form-group">
          <label htmlFor="sku">SKU *</label>
          <input
            type="text"
            id="sku"
            value={formData.sku}
            onChange={(e) => setFormData({ ...formData, sku: e.target.value })}
            required
          />
        </div>

        <div className="Form-group">
          <label htmlFor="unit">Unit *</label>
          <select
            id="unit"
            value={formData.unit}
            onChange={(e) => setFormData({ ...formData, unit: e.target.value })}
            required
          >
            <option value="pcs">pcs</option>
            <option value="kg">kg</option>
            <option value="litre">litre</option>
          </select>
        </div>

        {error && <div className="Form-error">{error}</div>}

        <div className="Form-actions">
          <button type="submit" disabled={loading}>
            {loading ? 'Creating...' : 'Create Item'}
          </button>
          <button type="button" onClick={onCancel}>
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
};

export default CreateItemForm;

