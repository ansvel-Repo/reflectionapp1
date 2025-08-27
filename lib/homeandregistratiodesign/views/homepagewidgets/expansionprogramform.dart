// import 'package:ansvel/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:ansvel/homeandregistratiodesign/util/appthemedata.dart';
import 'package:ansvel/homeandregistratiodesign/views/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/dashboard.dart';
// import 'package:ansvel/ridewithme/themes/app_them_data.dart';

class ExpansionProgramForm extends StatefulWidget {
  @override
  _ExpansionProgramFormState createState() => _ExpansionProgramFormState();
}

class _ExpansionProgramFormState extends State<ExpansionProgramForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _selectedRole;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _developerOption;

  List<String> roles = [
    'Partnership Driver',
    'Business Developer',
    'Developer Network',
  ];

  List<String> developerOptions = [
    'I HAVE BUILT AN APP',
    'I WANT TO BUILD APPS FOR ANSVEL',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData.primary50,
      appBar: AppBar(
        title: Text('Expansion Program Form'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
            weight: 500,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavWithAnimatedIcons()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Select Role',
                  border: OutlineInputBorder(),
                ),
                items: roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_selectedRole != null) _buildRoleSpecificFields(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.deepPurple[400],
                  shape: const StadiumBorder(),
                  elevation: 8,
                  shadowColor: Colors.black87,
                ),
                child: Text(
                  'Submit',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSpecificFields() {
    switch (_selectedRole) {
      case 'Partnership Driver':
        return _buildPartnershipDriverFields();
      case 'Business Developer':
        return _buildBusinessDeveloperFields();
      case 'Developer Network':
        return _buildDeveloperNetworkFields();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildPartnershipDriverFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We intend to grow our business through partnerships with financial institutions, businesses, manufacturers, hospitals, big tech companies (Microsoft, Google, etc.), distributors, and others in Nigeria and other countries. If you are able to close any of these partnerships, we will share the profit with you, and you will receive 10% of the profit generated from the business annually.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _fullNameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _phoneNumberController,
          decoration: InputDecoration(
            labelText: 'Phone Number (with Country Code)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Describe Your Target Business',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe your target business';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBusinessDeveloperFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'As a business developer without the necessary software skills to develop your ideas, we can develop the idea and share the profit at a 70:30 ratio between us and you, respectively. Please note that you would be responsible for selling the service; otherwise, the profit would be shared at a 90:10 ratio between us and you, respectively.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _fullNameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _phoneNumberController,
          decoration: InputDecoration(
            labelText: 'Phone Number (with Country Code)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Describe Your Business Idea (200 words)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe your business idea';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDeveloperNetworkFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You are a software engineer, and you have built the idea in Flutter or on a web platform, or you are willing to develop ideas from Ansvel. We will share the profit with you at a 60:40 ratio between us and you, respectively.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _fullNameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _phoneNumberController,
          decoration: InputDecoration(
            labelText: 'Phone Number (with Country Code)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Describe Your Experience (200 words)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe your experience';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _developerOption,
          decoration: InputDecoration(
            labelText: 'Developer Option',
            border: OutlineInputBorder(),
          ),
          items: developerOptions.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _developerOption = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select an option';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to submit this form')),
        );

        return;
      }

      final data = {
        'userId': user.uid,
        'role': _selectedRole,
        'fullName': _fullNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'description': _descriptionController.text,
        'email': _emailController.text,
        'developerOption': _developerOption,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('expansionProgram').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully!')),
      );
      Get.to(() => BottomNavWithAnimatedIcons());

      // Clear the form
      _formKey.currentState!.reset();
      setState(() {
        _selectedRole = null;
        _developerOption = null;
      });
    }
  }
}
