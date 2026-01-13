const express = require("express");
const cors = require("cors");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

app.post("/register", (req, res) => {
  const data = req.body;

  console.log("Dados recebidos:", data);

  return res.status(201).json({
    message: "Cadastro recebido com sucesso",
    data
  });
});

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

app.listen(PORT, () => {
  console.log(`Backend rodando na porta ${PORT}`);
});
