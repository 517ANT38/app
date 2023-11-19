
const { Sequelize ,DataTypes} = require('sequelize');


const connection=new Sequelize({
    database:"postgres",
    username:"myapp",
    port:5432,
    dialect:"postgres",
    password:"postgres",
    host:"127.0.0.1",
    logging: false,
    timezone: '+04:00'
});


connection.sync();
module.exports={connection:connection,types:DataTypes}