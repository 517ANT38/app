
const { Sequelize ,DataTypes} = require('sequelize');


const connection=new Sequelize({
    database:"appmarks",
    username:"myapp",
    port:5432,
    dialect:"postgres",
    password:"myapp",
    host:"localhost",
    logging: false,
    timezone: '+04:00'
});


connection.sync();
module.exports={connection:connection,types:DataTypes}