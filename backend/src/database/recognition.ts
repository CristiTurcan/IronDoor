import knex from 'knex';
import { Model } from 'objection';

const knexConfig = {
  client: 'sqlite3',
  connection: {
    filename: './mydb.sqlite'
  },
  useNullAsDefault: true
};

const db = knex(knexConfig);
Model.knex(db);

class Recognition extends Model {
  static get tableName() {
    return 'recognitions';
  }

  id!: number;
  imageBase64!: string;
}

// Create the table if it doesn't exist
db.schema.hasTable('recognitions').then((exists) => {
  if (!exists) {
    return db.schema.createTable('recognitions', (table) => {
      table.increments('id').primary();
      table.text('imageBase64').notNullable();
    });
  }
}).catch((error) => {
  console.error('Error creating table:', error);
});

export default Recognition;
