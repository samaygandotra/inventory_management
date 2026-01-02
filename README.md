# Inventory Management System

A full-stack inventory management system built with Elixir/Phoenix backend and React/TypeScript frontend.

## Tech Stack

- **Backend**: Elixir + Phoenix (JSON API), PostgreSQL
- **Frontend**: React + TypeScript
- **Testing**: ExUnit (backend tests)

## Project Structure

```
.
├── backend/          # Phoenix application
│   ├── lib/
│   │   ├── inventory_management/          # Core business logic
│   │   │   ├── inventory/                 # Inventory context
│   │   │   │   ├── item.ex               # Item schema
│   │   │   │   └── movement.ex           # Movement schema
│   │   │   └── inventory.ex              # Inventory context (business logic)
│   │   └── inventory_management_web/      # Web layer
│   │       ├── controllers/              # API controllers
│   │       └── views/                    # JSON views
│   ├── priv/repo/migrations/             # Database migrations
│   └── test/                             # ExUnit tests
└── frontend/         # React application
    └── src/
        ├── components/                    # React components
        └── types.ts                      # TypeScript types
```

## Data Model

### Item
- `id`: Integer (primary key)
- `name`: String (required)
- `sku`: String (required, unique)
- `unit`: String (required, one of: "pcs", "kg", "litre")
- `inserted_at`: Timestamp
- `updated_at`: Timestamp

### Inventory Movement
- `id`: Integer (primary key)
- `item_id`: Integer (foreign key to items)
- `quantity`: Integer (required, must be positive)
- `movement_type`: String (required, one of: "IN", "OUT", "ADJUSTMENT")
- `inserted_at`: Timestamp
- `updated_at`: Timestamp

## Stock Calculation Logic

**Important**: Stock is **not stored directly** in the database. It is calculated on-the-fly from inventory movements.

### Formula
```
Stock = sum(IN movements) - sum(OUT movements) + sum(ADJUSTMENT movements)
```

### Movement Types
- **IN**: Adds to stock (positive quantity)
- **OUT**: Subtracts from stock (positive quantity)
- **ADJUSTMENT**: Can add or subtract (positive or negative quantity)

### Example
```
Initial: 0 stock
+ IN: 100 units → Stock = 100
- OUT: 30 units → Stock = 70
+ IN: 20 units → Stock = 90
+ ADJUSTMENT: +5 units → Stock = 95
- OUT: 10 units → Stock = 85
```

### Negative Stock Prevention
The system **prevents negative stock** by:
1. Validating stock after each movement creation
2. Rolling back the movement if it would result in negative stock
3. Returning a clear error message: "Stock cannot be negative. Current stock would be: X"

## Backend APIs

### Items

#### GET /api/items
Fetch all items with current stock.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Widget A",
      "sku": "WID001",
      "unit": "pcs",
      "stock": 50,
      "inserted_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

#### POST /api/items
Create a new item.

**Request:**
```json
{
  "item": {
    "name": "Widget A",
    "sku": "WID001",
    "unit": "pcs"
  }
}
```

#### GET /api/items/:id
Get a specific item with current stock.

#### PUT /api/items/:id
Update an item.

#### DELETE /api/items/:id
Delete an item.

### Movements

#### POST /api/items/:id/movements
Record an inventory movement.

**Request:**
```json
{
  "movement": {
    "quantity": 10,
    "movement_type": "IN"
  }
}
```

**Response (Success):**
```json
{
  "data": {
    "id": 1,
    "item_id": 1,
    "quantity": 10,
    "movement_type": "IN",
    "inserted_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

**Response (Error - Negative Stock):**
```json
{
  "error": "Stock cannot be negative. Current stock would be: -5"
}
```

#### GET /api/items/:id/movements
Get movement history for an item.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "item_id": 1,
      "quantity": 10,
      "movement_type": "IN",
      "inserted_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

## How to Run the Project

### Prerequisites
- Elixir 1.14+ and Erlang/OTP 25+
- PostgreSQL 12+
- Node.js 18+ and npm
- Mix (comes with Elixir)

### Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
mix deps.get
```

3. Create and setup the database:
```bash
mix ecto.create
mix ecto.migrate
```

4. (Optional) Seed the database:
```bash
mix run priv/repo/seeds.exs
```

5. Start the Phoenix server:
```bash
mix phx.server
```

The API will be available at `http://localhost:4000`

### Frontend Setup

1. Navigate to the frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

The frontend will be available at `http://localhost:3000`

### Running Tests

#### Backend Tests
```bash
cd backend
mix test
```

The test suite includes:
- Stock calculation tests
- Negative stock rejection tests
- Item and movement CRUD tests

## Frontend Features

### Item List
- Displays all items with current stock
- Click on an item to view details
- Highlights low stock items (< 10 units)

### Create Item Form
- Create new items with name, SKU, and unit
- Validates required fields and unit type

### Inventory Movement Form
- Record IN, OUT, or ADJUSTMENT movements
- Validates quantity and prevents negative stock
- Shows current stock for selected item

### Item Detail View
- View item information and current stock
- Display complete movement history
- Record new movements from detail view

## Assumptions

1. **Stock Calculation**: Stock is always calculated from movements, never stored directly
2. **Negative Stock**: Not allowed - system rejects movements that would result in negative stock
3. **Movement Quantity**: Must be positive for IN/OUT, can be positive or negative for ADJUSTMENT
4. **SKU Uniqueness**: Each item must have a unique SKU
5. **Unit Types**: Only three unit types supported: "pcs", "kg", "litre"
6. **Transaction Safety**: Movement creation is atomic - if stock validation fails, the movement is rolled back

## Improvements & Future Enhancements

1. **Authentication & Authorization**: Add user authentication and role-based access control
2. **Pagination**: Implement pagination for items and movements lists
3. **Search & Filtering**: Add search by name/SKU and filter by unit type
4. **Stock Alerts**: Email/notification system for low stock items
5. **Audit Trail**: Enhanced logging and audit trail for all movements
6. **Bulk Operations**: Support for bulk item creation and movement recording
7. **Reports**: Generate inventory reports (stock levels, movement summaries)
8. **Real-time Updates**: WebSocket support for real-time stock updates
9. **Export/Import**: CSV/Excel export and import functionality
10. **Multi-warehouse**: Support for multiple warehouse locations
11. **Reservations**: Reserve stock for pending orders
12. **Unit Tests for Frontend**: Add Jest/React Testing Library tests
13. **API Documentation**: Add Swagger/OpenAPI documentation
14. **Docker Support**: Containerize the application for easy deployment
15. **CI/CD Pipeline**: Automated testing and deployment

## Development Notes

- The backend uses Ecto for database operations
- Stock calculation happens in the `Inventory.calculate_stock/1` function
- Negative stock validation occurs in `Inventory.validate_stock/1`
- CORS is enabled for frontend-backend communication
- The frontend uses React hooks for state management
- API errors are displayed to users with clear messages

## License

ISC
