import React, { useState, useEffect } from 'react';
import './App.css';
import ItemList from './components/ItemList';
import CreateItemForm from './components/CreateItemForm';
import MovementForm from './components/MovementForm';
import ItemDetail from './components/ItemDetail';
import { Item, Movement } from './types';

function App() {
  const [items, setItems] = useState<Item[]>([]);
  const [selectedItem, setSelectedItem] = useState<Item | null>(null);
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showMovementForm, setShowMovementForm] = useState(false);

  useEffect(() => {
    fetchItems();
  }, []);

  const fetchItems = async () => {
    try {
      const response = await fetch('/api/items');
      const data = await response.json();
      setItems(data.data || []);
    } catch (error) {
      console.error('Error fetching items:', error);
    }
  };

  const handleItemCreated = () => {
    fetchItems();
    setShowCreateForm(false);
  };

  const handleMovementCreated = () => {
    fetchItems();
    if (selectedItem) {
      fetchItemDetail(selectedItem.id);
    }
    setShowMovementForm(false);
  };

  const fetchItemDetail = async (itemId: number) => {
    try {
      const response = await fetch(`/api/items/${itemId}`);
      const data = await response.json();
      setSelectedItem(data.data);
    } catch (error) {
      console.error('Error fetching item detail:', error);
    }
  };

  const handleItemClick = (item: Item) => {
    fetchItemDetail(item.id);
  };

  const handleBackToList = () => {
    setSelectedItem(null);
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Inventory Management System</h1>
      </header>
      <main className="App-main">
        {selectedItem ? (
          <ItemDetail
            item={selectedItem}
            onBack={handleBackToList}
            onMovementCreated={handleMovementCreated}
          />
        ) : (
          <>
            <div className="App-actions">
              <button onClick={() => setShowCreateForm(!showCreateForm)}>
                {showCreateForm ? 'Cancel' : 'Create Item'}
              </button>
              <button onClick={() => setShowMovementForm(!showMovementForm)}>
                {showMovementForm ? 'Cancel' : 'Record Movement'}
              </button>
            </div>

            {showCreateForm && (
              <CreateItemForm
                onItemCreated={handleItemCreated}
                onCancel={() => setShowCreateForm(false)}
              />
            )}

            {showMovementForm && (
              <MovementForm
                items={items}
                onMovementCreated={handleMovementCreated}
                onCancel={() => setShowMovementForm(false)}
              />
            )}

            <ItemList items={items} onItemClick={handleItemClick} />
          </>
        )}
      </main>
    </div>
  );
}

export default App;

