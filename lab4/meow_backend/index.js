
const express = require('express');
const mysql = require("mysql");
const app = express();

app.use(express.json());
const port  = process.env.PORT || 8081;

app.listen(port,()=>{
  console.log(`cat rest api listening on the port ${port}`);
});
app.get('/',async(req,res)=>{
  res.json({status:"Meow Meow!Ready to roll"});
});

const pool = mysql.createPool({
    user:"root",
    password:"djq010918091877",
    database:"cat",
    host:"localhost",
    port:3306
})

// app.get("/:breed",async(req,res)=>{
//     const query = "select * from breed where name = ?";
//     pool.query(query, [req.params.breed],(error,results)=>{
//       if(!results[0]) {
//         res.json({status:"Not found"});
//       } else {
//         res.json(results[0]);
//       }
//     });
// });

app.get("/getall",async(req,res)=>{
  const query = "select * from cat";
  pool.query(query, [],(error,results)=>{
    if(!results) {
      res.json({status:"Not found"});
    } else {
      console.log(results)
      res.json(results);
    }
  });
});

app.get("/getplaces",async(req,res)=>{
  const query = "select * from Place";
  pool.query(query, [],(error,results)=>{
    if(!results) {
      res.json({status:"Not found"});
    } else {
      res.json(results);
    }
  });
});

app.get("/getfoods",async(req,res)=>{
  const query = "select * from Food";
  pool.query(query, [],(error,results)=>{
    if(!results) {
      res.json({status:"Not found"});
    } else {
      console.log(results);
      res.json(results);
    }
  });
});

app.post("/postplace",async (req,res)=>{
  const data = {
    palce_id:parseInt(req.body.place_id),
    place_address:req.body.place_address,
    place_busytime:req.body.place_busytime
  };
  console.log(data)
  const query = "insert into Place values(?,?,?)";
  pool.query(query, Object.values(data),(error)=>{
    if(error){
      res.json({status:"failure",reason:error.code});
    } else {
      res.json({status:"success",data:data});
    }
  });
});



app.post("/postbreed",async (req,res)=>{
  const data = {
    breed_name:req.body.breed_name,
    brees_description:req.body.breed_description,
    breed_notes:req.body.breed_notes
  };
  console.log(data)
  const query = "insert into cat_breed values(?,?,?)";
  pool.query(query, Object.values(data),(error)=>{
    if(error){
      res.json({status:"failure",reason:error.code});
    } else {
      res.json({status:"success",data:data});
    }
  });
});

app.post("/postfood",async (req,res)=>{
  const data = {
    food_no:req.body.food_no,
    food_description:req.body.food_description
  };
  const query = "insert into Food values(?,?)";
  pool.query(query, Object.values(data),(error)=>{
    if(error){
      res.json({status:"failure",reason:error.code});
    } else {
      res.json({status:"success",data:data});
    }
  });
});


app.post("/postcat",async (req,res)=>{
  const data = {
    cat_name:req.body.cat_name,
    breed_name:req.body.breed_name,
    place_id:req.body.palce_id,
    cat_color:req.body.cat_color,
    cat_character:req.body.cat_character,
    cat_gender:req.body.cat_gender
  };
  console.log(data)
  const query = "insert into cat values(?,?,?,?,?,?)";
  pool.query(query, Object.values(data),(error)=>{
    if(error){
      res.json({status:"failure",reason:error.code});
    } else {
      res.json({status:"success",data:data});
    }
  });
});


app.get("/getallfoodRecord",async(req,res)=>{
  const query = "select * from feedRecord";
  pool.query(query, [],(error,results)=>{
    if(!results) {
      res.json({status:"Not found"});
    } else {
      res.json(results);
    }
  });
});

app.get("/getallappearance",async(req,res)=>{
  const query = "select * from appearance";
  pool.query(query, [],(error,results)=>{
    if(!results) {
      res.json({status:"Not found"});
    } else {
      res.json(results);
    }
  });
});

app.post("/postFoodRecord",async (req,res)=>{
  const data = {
    cat_name:req.body.cat_name,
    food_no:parseInt(req.body.food_no),
    palce_id:parseInt(req.body.place_id),
    feed_time:req.body.feed_time
  };
  console.log(data)
  const query = "insert into feedRecord values(?,?,?,?)";
  pool.query(query, Object.values(data),(error)=>{
    if(error){
      res.json({status:"failure",reason:error.code});
    } else {
      res.json({status:"success",data:data});
    }
  });
});

app.post("/postappearance",async (req,res)=>{
  const data = {
    cat_name:req.body.cat_name,
    palce_id:parseInt(req.body.place_id),
    appearance_time:req.body.appearance_time
    
  };
  const query = "insert into appearance values(?,?,?)";
  pool.query(query, Object.values(data),(error)=>{
    if(error){
      res.json({status:"failure",reason:error.code});
    } else {
      res.json({status:"success",data:data});
    }
  });
});

app.post("/postuser",async (req,res)=>{
  const data = {
    user_no:req.body.user,
    student_no:null,
    user_stat:parseInt(req.body.user_stat),
    user_password:req.body.passwd
  };
  const query = "insert into user values(?,?,?,?)";
  pool.query(query, Object.values(data),(error)=>{
    if(error){
      res.json({status:"failure",reason:error.code});
    } else {
      res.json({status:"success",reason:"null"});
    }
  });
});

app.get("/finduser/:user_no/:user_password",async (req,res)=>{
  const query = "select * from user where user_no=? and user_password=?";
  pool.query(query, [req.params.user_no,req.params.user_password],(error,results)=>{
    console.log(results)
    if(results.length == 0) {
      res.json({status:"Not found",reason:"Not found user"});
    } else {
      console.log("resagsfgwgf")
      res.json({status:"success",reason:"null"});
    }
  });
});