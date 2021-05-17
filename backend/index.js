const express = require('express');

var http = require('http');

// const cors = require('cors');

const app = express();

const port  = process.env.PORT || 5000;

var server = http.createServer(app);

var io = require('socket.io')(server
//     ,{
//     cors:{
//         origin:"*"
//     }
// }
);

//middle ware

app.use(express.json());
// app.use(cors());

var clients = {};

io.on("connection" , (socket)=>{
console.log("connected");
console.log(socket.id , "has joined");
socket.on("signin",(id)=>{
    console.log(id);
    clients[id] = socket;
    // console.log(clients[id]);
});


socket.on("msg",(msg)=>{
    console.log(msg);
    let dest_id = msg.dest_id;
    
    if(clients[dest_id])
    clients[dest_id].emit("msg",msg);
});
socket.on('send-image',(img)=>{
    // console.log(img.img);
    // console.log(img.src_id);
    // console.log(img.dest_id);
    if(clients[img.dest_id])
    clients[img.dest_id].emit("send-image",img);

    console.log("Send File");
});
});





server.listen(port, "0.0.0.0", ()=>{
    console.log("Server started");
    
})