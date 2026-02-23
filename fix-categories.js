const Database = require('better-sqlite3');
const db = new Database('./.tmp/data.db');

// Clear existing links
db.prepare('DELETE FROM products_categoria_links').run();

// Ropa (ID 1) = products 1-20
for(let i = 1; i <= 20; i++) {
  db.prepare('INSERT INTO products_categoria_links (product_id, category_id) VALUES (?, ?)').run(i, 1);
}

// Fragancias (ID 2) = products 21-25
for(let i = 21; i <= 25; i++) {
  db.prepare('INSERT INTO products_categoria_links (product_id, category_id) VALUES (?, ?)').run(i, 2);
}

// Accesorios (ID 3) = products 26-30
for(let i = 26; i <= 30; i++) {
  db.prepare('INSERT INTO products_categoria_links (product_id, category_id) VALUES (?, ?)').run(i, 3);
}

console.log('Done! Categories fixed!');
db.close();