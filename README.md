# EASV-databases-schema-migration

# Manual Migration Section

## Creating the Database Schema

#### I began database schema migration by creating SQL scripts

###  Table Creation

```sql
CREATE TABLE Products (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);
```


```sql
CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255) NOT NULL
);

ALTER TABLE Products
ADD CategoryId INT NULL,
CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id);
```
```sql
CREATE TABLE ProductRatings (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ProductId INT NOT NULL,
    Rating TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    CONSTRAINT FK_ProductRatings_Products FOREIGN KEY (ProductId) REFERENCES Products(Id)
);
```

## Mock Data

### Creating mock data for testing purpose

```sql
-- Categories
INSERT INTO Categories (Name) VALUES ('Technology'), ('Sport'), ('Literature');

-- Products
INSERT INTO Products (Name, Price, category_id) VALUES
                                                    ('Laptop', 1500.00, 1),
                                                    ('E-Book', 250.00, 1),
                                                    ('Calculator', 200.00, 2),
                                                    ('MacBook', 3345.99, 2),
                                                    ('Shoes', 29.99, 3),

-- ProductRatings
INSERT INTO ProductRatings (ProductId, Rating, Review) VALUES
                                                            (1, 5),
                                                            (1, 4),
                                                            (2, 4),
                                                            (3, 5),
                                                            (4, 5);
```

### Rollback
#### Due to SQL's enforcement of referential integrity, it's crucial to follow a particular order when removing tables to avoid constraint violations:
#### During development, I maintained separate files for each command to manage the sequence in which entities should be deleted, considering foreign key dependencies
```sql
-- Drop ProductRatings
DROP TABLE IF EXISTS ProductRatings;

-- Drop Products
DROP TABLE IF EXISTS Products;

-- Drop Categories
DROP TABLE IF EXISTS Categories;
```

# Entity Framework Core Migration

provides an overview of managing database schema modifications using Entity Framework Core (EF Core), covering everything from initial setup to migration management and rollback.

## Library Setup

Begin by installing EF Core libraries in your project:

- `Microsoft.EntityFrameworkCore.Sqlite`
- `Microsoft.EntityFrameworkCore.Design`

These libraries facilitate the use of EF Core with SQLite Server databases and add the project tools for migration management.

## Model and DbContext Definitions

### Models

Within your application, define C# classes that mirror the database's tables.

```csharp
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}

public class Category
{
    public int Id { get; set; }
    public string Name { get; set; }
}

public class ProductRating
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public Product Product { get; set; }
    public int Rating { get; set; }
}
```

## DbContext Implementation
### Create a DbContext to represent a database session, it allows entity querying and saving. It should include DbSet properties for each entity model:

```csharp
public class ApplicationDbContext : DbContext
{
    public DbSet<Product> Products { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<ProductRating> ProductRatings { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlite("Data Source=ecommerce.db");
    }
}
```

## Migration Creation and Application
### Generating Migrations
### To prepare a new migration reflecting your model or DbContext modifications, execute:

Add-Migration AddCategories

## Applying Migrations
### To update your database schema according to the migration

Update-Database

## Rolling Back

#### To revert to a specific migration, use the update database command with the desired migration name as the target:
- Update-Database PreviousMigrationName