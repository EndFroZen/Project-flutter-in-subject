const express = require("express")
const route = express.Router()

route.get("/hello",(req,res)=>{
    const data = {
        image : `http://localhost:8000/img/1.png`
    }
    res.json(data)
})

module.exports = route;