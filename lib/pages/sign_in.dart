import 'package:flutter/material.dart';
import 'package:BusyBee/JSON/user.dart';
import 'package:BusyBee/pages/home_page.dart';
import 'package:BusyBee/pages/sign_up.dart';
import 'package:BusyBee/services/databse_helper.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController controller;
  late AnimationController textAnimationController;

  // Animations
  late Animation<Offset> animationOffset;
  late Animation<Offset> textPositionAnimation;
  late Animation<double> textSizeAnimation;

  // Text field controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Login state
  bool isLogin = false;
  bool isPasswordVisible = true;

  // Form key
  final formKey = GlobalKey<FormState>();
  final db = DatabseHelper();

  // Initial text properties
  double textFontSize = 40.0;
  double textPositionTop = 100;

  @override
  void initState() {
    super.initState();

    // Main animation controller for the slide-in effect
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    animationOffset = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    // Animation controller for text position and size
    textAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    textPositionAnimation = Tween<Offset>(begin: Offset(0.2, 0.4),end:Offset( 0.1, 0.1)).animate(CurvedAnimation(parent: textAnimationController, curve: Curves.easeInOut));
    textSizeAnimation = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(parent: textAnimationController, curve: Curves.easeInOut));

    textAnimationController.addListener(() {
      setState(() {}); // rebuild so AnimatedPositioned & AnimatedDefaultTextStyle see new values
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      textAnimationController.forward().whenComplete((){
        controller.forward();
      });
    });
  }

  void signin() async {
    //final databasePath = await getDatabasesPath();
    //print('Database path: $databasePath');
    var result = await db.signIn(Users(username: usernameController.text, userPassword: passwordController.text, userid: null, userEmail: ''));
    if (result == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home_page()));
      db.saveUsername(usernameController.text);
      usernameController.clear();
      passwordController.clear();
    } else {
      setState(() {
        isLogin = true;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 230, 81, 0),
              const Color.fromARGB(255, 239, 108, 0),
              const Color.fromARGB(255, 255, 167, 38),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            SlideTransition(
              position: textPositionAnimation,
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 500),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSizeAnimation.value,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: textSizeAnimation.value,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "Hey BusyBee",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: textSizeAnimation.value,
                          ),
                        ),
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
            ),
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: animationOffset,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 30,right: 30,bottom: 30),
                      child: ListView(
                        children: [
                          Column(
                            children: <Widget>[
                              SizedBox(height: 60),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                                        child: TextFormField(
                                          controller: usernameController,
                                          validator: (value) => value!.isEmpty ? "Please enter your username" : null,
                                          style: TextStyle(color: Colors.grey),
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.person, color: Colors.grey),
                                            labelText: "Username",
                                            labelStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                                        child: TextFormField(
                                          controller: passwordController,
                                          validator: (value) => value!.isEmpty ? "Please enter your password" : null,
                                          style: TextStyle(color: Colors.grey),
                                          obscureText: isPasswordVisible,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.lock, color: Colors.grey),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPasswordVisible = !isPasswordVisible;
                                                });
                                              },
                                              icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                                            ),
                                            labelText: "Password",
                                            labelStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 60),
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    signin();
                                  }
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
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Don't have an account?",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Sign Up",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              isLogin ? Text("Incorrect username or password?", style: TextStyle(color: Colors.red)) : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
