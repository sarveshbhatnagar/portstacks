const functions = require("firebase-functions");
const admin = require("firebase-admin");

const serviceAccount = require("./permissions.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const express = require("express");

const app = express();
const db = admin.firestore();

const cors = require("cors");

app.use(cors({ origin: true }));

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// PORTFOLIO
// Routes

app.get("/hello-world", (req, res) => {
  return res.status(200).send("Hello World");
});

// Add a portfolio.
// Sample Body:
// {
//     "uid":"myuser",
//  "stockdata":{"NNDM":{"price":12,"quant":10},"MSFT":{"price":230,"quant":2}},
//     "portfolio_name":"basic portfolio",
//     "stocks":["NNDM","MSFT"]
// }
app.post("/api/portfolio/v1/addportfolio/:uid", (req, res) => {
  (() => {
    try {
      let docid;

      db.collection("users")
        .doc("" + req.params.uid)
        .collection("portfolios")
        .add({
          data: req.body.data,
          portfolio_name: req.body.portfolio_name,
          stocks: req.body.stocks,
        })
        .then(function (response) {
          docid = response.id;
          response.update({ id: docid });

          return res.status(200).send("");
        })
        .catch(function (err) {
          return res.status(500).send(err);
        });
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

// Read Portfolio
app.get("/api/portfolio/v1/readportfolio/:uid/:docid", (req, res) => {
  db.collection("users")
    .doc("" + req.params.uid)
    .collection("portfolios")
    .doc("" + req.params.docid)
    .get()
    .then(function (doc) {
      return res.status(200).send(doc.data());
    })
    .catch(function (error) {
      return res.status(500).send(error);
    });
});

// Read Portfolios
app.get("/api/portfolio/v1/readportfolios/:uid", (req, res) => {
  db.collection("users")
    .doc("" + req.params.uid)
    .collection("portfolios")
    .get()
    .then(function (querySnapshot) {
      let docs = [];
      docs = [];
      querySnapshot.forEach(function (doc) {
        docs.push(doc.data());
      });
      return res.status(200).send(docs);
    })
    .catch(function (error) {
      return res.status(500).send(error);
    });
});

// Delete Portfolio

app.delete("/api/portfolio/v1/deleteportfolio/:uid/:docid", (req, res) => {
  try {
    db.collection("users")
      .doc("" + req.params.uid)
      .collection("portfolios")
      .doc("" + req.params.docid)
      .delete()
      .then(function (result) {
        return res.status(200).send("");
      })
      .catch(function (error) {});
  } catch (e) {
    return res.status(500).send(e.message);
  }
});

// Delete Stock from a portfolio

// Update a portfolio

app.post("/api/portfolio/v1/updateportfolio/:uid/:docid", (req, res) => {
  (() => {
    try {
      db.collection("users")
        .doc("" + req.params.uid)
        .collection("portfolios")
        .doc("" + req.params.docid)
        .update({
          data: req.body.data,
          portfolio_name: req.body.portfolio_name,
          stocks: req.body.stocks,
        })
        .then(function (response) {
          // docid = response.id;
          // response.update({ id: docid });

          return res.status(200).send("");
        })
        .catch(function (err) {
          return res.status(500).send(err);
        });
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

// Export the api to firebase cloud functions
exports.app = functions.https.onRequest(app);
