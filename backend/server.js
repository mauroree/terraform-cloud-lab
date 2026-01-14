const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { PutItemCommand } = require("@aws-sdk/client-dynamodb");
const express = require("express");
const cors = require("cors");

const dynamoClient = new DynamoDBClient({
  region: process.env.AWS_REGION
});


const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

app.post("/register", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Email e senha são obrigatórios" });
  }

  try {
    const command = new PutItemCommand({
      TableName: process.env.DYNAMODB_TABLE,
      Item: {
        email: { S: email },
        password: { S: password }
      }
    });

    await dynamoClient.send(command);

    return res.status(201).json({
      message: "Usuário cadastrado com sucesso"
    });
  } catch (error) {
    console.error("Erro ao gravar no DynamoDB:", error);

    return res.status(500).json({
      message: "Erro ao salvar usuário"
    });
  }
});


app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});


app.listen(PORT, "0.0.0.0", () => {
  console.log(`Backend rodando na porta ${PORT}`);
});

