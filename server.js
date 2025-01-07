const express = require("express");
const path = require("path");
const app = express();
const readitem = require("./components/readitem");

app.use("/hello", readitem);

app.get("/", (req, res) => {
    res.send("hello");
});


app.get("/img/:img", (req, res) => {
    const img = req.params.img;
    const imgPath = path.join(__dirname, "image", img); 
    res.sendFile(imgPath, (err) => {
        if (err) {
            console.error("Error sending file:", err);
            res.status(404).send("File not found");
        }
    });
});

// Start the server
app.listen(8000, () => {
    console.log("http://localhost:8000");
});
