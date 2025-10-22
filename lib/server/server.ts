import express from "express";
import dotenv from "dotenv";
import usuarioRouter from "./src/routes/usuario.routes";
import alimentoRouter from "./src/routes/alimento.routes";
import campanhaRouter from "./src/routes/campanhas.routes";
import doacaoRouter from "./src/routes/doacao.routes";
import localidadeRouter from "./config/routes/localidade.router";
import cors from "cors";

// Carrega o .env do diretório do servidor (lib/server/.env)
dotenv.config({ path: "./.env" });

const app = express();
app.use(
  cors({
    origin: "http://localhost:3000",
  })
);

// Express routes
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use("/api", [
  usuarioRouter,
  alimentoRouter,
  campanhaRouter,
  doacaoRouter,
  localidadeRouter,
]);

app.listen(5000, () => {
  console.log("Server started on port 5000");
});
