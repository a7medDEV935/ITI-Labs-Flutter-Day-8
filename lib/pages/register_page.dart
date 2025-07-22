import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _gender;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate() && _gender != null) {
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('full_name', _fullNameController.text.trim());
        await prefs.setString('email', _emailController.text.trim());
        await prefs.setString('password', _passwordController.text.trim());
        await prefs.setString('phone', _phoneController.text.trim());
        await prefs.setString('address', _addressController.text.trim());
        await prefs.setString('gender', _gender!);
        List<String> users = prefs.getStringList('users') ?? [];
        Map<String, dynamic> newUser = {
          'full_name': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'gender': _gender!,
        };
        String userJson = jsonEncode(newUser);
        users.add(userJson);
        await prefs.setStringList('user', users);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords not match")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pless fill all fields before submit")),
      );
    }
  }

  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 50,
                        child: _image != null
                            ? ClipOval(
                                child: Image.file(
                                  _image!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey.shade200,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue.shade300,
                          radius: 20,
                          child: Icon(
                            Icons.camera_alt,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildTextFiled(
                  _fullNameController,
                  'Full Name',
                  Icons.person,
                ),
                _buildTextFiled(
                  _emailController,
                  'Email',
                  Icons.mail,
                ),
                _buildTextFiled(
                  _phoneController,
                  'Phone',
                  Icons.phone,
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    hintText: 'Choose your gender',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'female'].map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _gender = val),
                  validator: (val) => val == null ? 'Gender is required' : null,
                ),
                _buildTextFiled(
                  _addressController,
                  'Address',
                  Icons.location_on,
                  maxlines: 3,
                ),
                _buildTextFiled(
                  _passwordController,
                  'Password',
                  Icons.lock,
                  obscureText: true,
                ),
                _buildTextFiled(
                  _confirmPasswordController,
                  'Confirm Password',
                  Icons.lock,
                  obscureText: true,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Register'),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTextFiled(
  TextEditingController controller,
  String label,
  IconData icon, {
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  int maxlines = 1,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxlines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Input filed is required' : null,
    ),
  );
}
