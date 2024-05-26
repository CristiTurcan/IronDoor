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

class Enrollment extends Model {
  static get tableName() {
    return 'enrollments';
  }

  id!: number;
  name!: string;
  imageBase64!: string;
}

// Create the table if it doesn't exist
db.schema.hasTable('enrollments').then((exists) => {
  if (!exists) {
    return db.schema.createTable('enrollments', (table) => {
      table.increments('id').primary();
      table.string('name').notNullable();
      table.text('imageBase64').notNullable();
    });
  }
}).catch((error) => {
  console.error('Error creating table:', error);
});

export default Enrollment;
