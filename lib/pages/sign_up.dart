import 'package:flutter/material.dart';
import 'package:BusyBee/JSON/user.dart';
import 'package:BusyBee/services/databse_helper.dart';

class SignUp extends StatefulWidget{
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //controllers for the text fields
  final  usernameController = TextEditingController();
  final  emailController = TextEditingController();
  final  passwordController = TextEditingController();
  final  confirmPasswordController = TextEditingController();
  //to see what the user have clicked on
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  //global key to validate the form
   final db=DatabseHelper();
   //siginup function
   void signup()async{
    if (passwordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Passwords do not match")),
    );
    return;

    }
    if(usernameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill all the fields")),
    );
    return;
    }
    var result= await db.signUp(Users(username: usernameController.text, userEmail: emailController.text, userPassword: passwordController.text, userid: null));
    print(result);
    if(result == '0')
    {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User already exists")),
    );
      return;
    }
    else if(result == '-1')
    {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error while signing up")),
    );
      return;
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User created successfully")),
    );
      Navigator.pop(context);
    }
   }
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
      return Scaffold(
      body: Container(
        width:double.infinity,
        decoration:BoxDecoration(
          gradient: LinearGradient(
            colors:[
              const Color.fromARGB(255, 230, 81, 0),
              const Color.fromARGB(255, 239, 108, 0),
              const Color.fromARGB(255, 255, 167, 38),

            ])
          ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            SizedBox(height:80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Register Now!",style:TextStyle(color: Colors.white,fontSize:40),),
                  SizedBox(height:10,),
                  Row(
                    children: [
                      Text("Welcome To BusyBee",style:TextStyle(color: Colors.white,fontSize:18),),
                      SizedBox(width: 5),
                      Image.asset(
                        'lib/assets/bee.png',
                        width: 30,
                        height: 30,
                      ),
                    ],
                  )
                ],
              ),
              ),
              SizedBox(height:20),
              Expanded(
                child:Container(
                  decoration: BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(60),topRight:Radius.circular(60),
                    ),
                  ),
                  child:Padding(
                    padding:EdgeInsets.all(30),
                    child: ListView(
                      children: [Column(
                        children: <Widget>[
                          SizedBox(height:60),
                          Container(
                            decoration:BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                color:Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset:Offset(0, 10)
                              )]
                            ),
                            child:Form(
                              key: formkey,
                              child: Column(
                                children:[
                                  Container(
                                    padding:EdgeInsets.all(10), 
                                    decoration: BoxDecoration(
                                      border:Border(bottom:BorderSide(color:Colors.grey))
                                    ),
                                    child: TextFormField(
                                      //validator: (value) => value!.isEmpty ? "Please enter your username" : null,
                                      controller: usernameController,
                                      style: TextStyle(color: Colors.grey),
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.person,color:Colors.grey),
                                        labelText: "Username",
                                        labelStyle: TextStyle(color:Colors.grey,),
                                        border:InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:EdgeInsets.all(10), 
                                    decoration: BoxDecoration(
                                      border:Border(bottom:BorderSide(color:Colors.grey))
                                    ),
                                    child: TextFormField(
                                      //validator: (value) => value!.isEmpty ? "Please enter your email" : null,
                                      controller: emailController,
                                      style: TextStyle(color: Colors.grey),
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.email,color:Colors.grey),
                                        labelText: "Email",
                                        labelStyle: TextStyle(color:Colors.grey,),
                                        border:InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:EdgeInsets.all(10), 
                                    decoration: BoxDecoration(
                                      border:Border(bottom:BorderSide(color:Colors.grey))
                                    ),
                                    child: TextFormField(
                                      //validator: (value) => value!.isEmpty ? "Please enter your password" : null,
                                      controller: passwordController,
                                      style: TextStyle(color: Colors.grey),
                                      obscureText: isPasswordVisible,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(onPressed: (){
                                          setState(() {
                                            isPasswordVisible = !isPasswordVisible; 
                                          });
                                        },icon:isPasswordVisible?Icon(Icons.visibility_off):Icon(Icons.visibility),color:Colors.grey),
                                        icon: Icon(Icons.lock,color:Colors.grey),
                                        labelText: "Password",
                                        labelStyle: TextStyle(color:Colors.grey,),
                                        border:InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:EdgeInsets.all(10), 
                                    decoration: BoxDecoration(
                                      border:Border(bottom:BorderSide(color:Colors.grey))
                                    ),
                                    child: TextFormField(
                                      // validator: (value) {
                                      //   if(value!.isEmpty) {
                                      //     return "Please confirm your password";
                                      //   } else if (value != passwordController.text) {
                                      //     return "Passwords do not match";
                                      //   }
                                      // },
                                      controller: confirmPasswordController,
                                      obscureText: isConfirmPasswordVisible,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(onPressed: (){
                                          setState(() {
                                            isConfirmPasswordVisible = !isConfirmPasswordVisible; 
                                          });
                                        },icon:isConfirmPasswordVisible?Icon(Icons.visibility_off):Icon(Icons.visibility),color:Colors.grey),
                                        icon: Icon(Icons.lock,color:Colors.grey),
                                        labelText: "Confirm Password",
                                        labelStyle: TextStyle(color:Colors.grey,),
                                        border:InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                          SizedBox(height:60),
                          ElevatedButton(
                              onPressed: () {
                                //  login functionality
                                signup();
                              //  if (formkey.currentState!.validate()) {
                              // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 230, 81, 0), 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50), 
                                ),
                                minimumSize: Size(double.infinity, 50), 
                                padding: EdgeInsets.symmetric(horizontal: 50),
                              ),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          SizedBox(height:20),
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Already have an account?",style:TextStyle(color:Colors.grey),),
                                SizedBox(width:5),
                                Text("Sign in",style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold),)
                              ],
                            ),
                          ),
                          
                        ],
                                        ),
                      ]
                    ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}