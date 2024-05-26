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

class Notification extends Model {
    static get tableName() {
        return 'notifications';
    }

    id!: number;
    name!: string;
    message!: string;
    hasImage!: boolean;
    imageBase64?: string;
}

// Create the table if it doesn't exist
db.schema.hasTable('notifications').then((exists) => {
    if (!exists) {
        return db.schema.createTable('notifications', (table) => {
            table.increments('id').primary();
            table.string('name');
            table.string('message');
            table.boolean('hasImage');
            table.string('imageBase64').nullable();
        });
    }
}).catch((error) => {
    console.error('Error creating table:', error);
});

export default Notification;
