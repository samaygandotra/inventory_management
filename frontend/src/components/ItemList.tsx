import React from 'react';
import './ItemList.css';
import { Item } from '../types';

interface ItemListProps {
  items: Item[];
  onItemClick: (item: Item) => void;
}

const ItemList: React.FC<ItemListProps> = ({ items, onItemClick }) => {
  return (
    <div className="ItemList">
      <h2>Items</h2>
      {items.length === 0 ? (
        <p>No items found. Create your first item!</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>SKU</th>
              <th>Unit</th>
              <th>Stock</th>
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <tr key={item.id} onClick={() => onItemClick(item)} className="clickable-row">
                <td>{item.name}</td>
                <td>{item.sku}</td>
                <td>{item.unit}</td>
                <td className={item.stock < 10 ? 'low-stock' : ''}>{item.stock}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default ItemList;

