export interface Item {
  id: number;
  name: string;
  sku: string;
  unit: string;
  stock: number;
  inserted_at: string;
  updated_at: string;
}

export interface Movement {
  id: number;
  item_id: number;
  quantity: number;
  movement_type: 'IN' | 'OUT' | 'ADJUSTMENT';
  inserted_at: string;
  updated_at: string;
}

