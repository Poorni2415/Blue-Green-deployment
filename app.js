const express = require("express");

const app = express();

app.get("/", (req, res) => {
    res.send("Version 3 - Jenkins Deployment");
});

app.get("/health", (req, res) => {
    res.status(200).send("Healthy");
});

app.listen(3000, () => {
    console.log("App running");
});