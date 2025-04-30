import { Pool } from "pg";
import { ENV } from "../config/env";

const pool = new Pool({
  user: ENV.DB_USER,
  password: ENV.DB_PASSWORD,
  host: ENV.DB_HOST,
  port: ENV.DB_PORT,
  database: ENV.DB_NAME,
});

export default pool;
