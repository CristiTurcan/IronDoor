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

class FaceDescriptor extends Model {
    static get tableName() {
        return 'face_descriptors';
    }

    id!: number;
    name!: string;
    descriptors!: number[][];
}

// Create the table if it doesn't exist
db.schema.hasTable('face_descriptors').then((exists) => {
    if (!exists) {
        return db.schema.createTable('face_descriptors', (table) => {
            table.increments('id').primary();
            table.string('name').notNullable();
            table.json('descriptors').notNullable();
        });
    }
}).catch((error) => {
    console.error('Error creating table:', error);
});

export default FaceDescriptor;
