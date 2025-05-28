import 'package:BusyBee/services/databse_helper.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final db=DatabseHelper();
  bool is_password_visible = false;
  bool is_confirm_password_visible = false;
  final formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    loadData();
  }
    void signOut() async {
    //db.signOut();
    db.logedin = !db.logedin;
    Navigator.pop(context);
  }
  Future<void> loadData() async {
    final u = await db.getUsername() ??'';
    final e = await db.getEmail() ?? '';
    final p = await db.getPassword() ?? '';
   setState(() {
      usernameController.text=u;
      emailController.text=e;
      passwordController.text=p;
      String username=usernameController.text;
      String email=emailController.text;
      String password=passwordController.text;
      // print("Username: $username");
      // print("Email: $email");
      // print("Password: $password");
   });
  }
  void saveInfo() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String newPassword = newPasswordController.text;
    if(password!=newPassword ){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password does not match"),
          duration: Duration(seconds: 2),
        ),
      );
    }
    else{
      await db.UpdateUserData(username, email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
          duration: Duration(seconds: 2),
        ),
      );
      loadData();
      //db.reloadCurrentUser();
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        
        title: Text("Edit Profile",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ProfilePic(
              image: 'https://i.postimg.cc/cCsYDjvj/user-2.png',
              imageUploadBtnPress: () {},
            ),
            Divider(color: Theme.of(context).dividerColor),
            Form(
              key: formKey,
              child: Column(
                children: [
                  UserInfoEditField(
                    text: "Name",
                    child: TextFormField(
                      controller: usernameController,
                      validator: (value) => value!.isEmpty ? "Enter your name" : null,
                      //initialValue: usernameController.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                         hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                          ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Email",
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) => value!.isEmpty ? "Enter your email" : null,
                      //initialValue: emailController.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Old Password",
                    child: TextFormField(
                      obscureText: is_password_visible,
                      controller: passwordController,
                      validator: (value) => value!.isEmpty ? "Enter your password" : null,
                      //initialValue: passwordController.text,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            is_password_visible = !is_password_visible;
                          });
                        }, 
                         icon: Icon(
                            is_password_visible ? Icons.visibility_off : Icons.visibility,
                            size: 20,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "New Password",
                    child: TextFormField(
                      controller: newPasswordController,
                      obscureText: is_confirm_password_visible,
                      style: Theme.of(context).textTheme.bodyLarge,
                      validator: (value) => value!.isEmpty ? "Enter your new password" : null,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            is_confirm_password_visible = !is_confirm_password_visible;
                          });
                        },
                         icon: Icon(
                            is_confirm_password_visible ? Icons.visibility_off : Icons.visibility,
                            size: 20,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        hintText: "New Password",
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      signOut();
                      Navigator.pop(context);
                      //Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      foregroundColor: Theme.of(context).primaryColor,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        saveInfo();
                      }
                    },
                    child: const Text("Save Update"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
           color: Theme.of(context).dividerColor,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(image),
          ),
          InkWell(
            onTap: imageUploadBtnPress,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(text),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}
