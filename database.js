import mysql from "mysql2";
import dotenv from 'dotenv'

dotenv.config();

const pool = mysql.createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE
}).promise();

async function getUsers(params) {
    const [result] = await pool.query("SELECT * FROM users");
    return result;    
}
 
let users = getUsers();

const [result] = await pool.query("SELECT * FROM users")
console.log(users);