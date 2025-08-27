// import 'package:ansvel/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:ansvel/homeandregistratiodesign/views/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/dashboard.dart';

class PartnerInformationForm extends StatefulWidget {
  @override
  _PartnerInformationFormState createState() => _PartnerInformationFormState();
}

class _PartnerInformationFormState extends State<PartnerInformationForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for TextFormFields
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _officialEmailController =
      TextEditingController();
  final TextEditingController _yourEmailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _countryOfRegistrationController =
      TextEditingController();
  final TextEditingController _countryOfOperationController =
      TextEditingController();
  final TextEditingController _headOfficeAddressController =
      TextEditingController();
  final TextEditingController _primaryNatureOfBusinessController =
      TextEditingController();
  final TextEditingController _regulatorNameController =
      TextEditingController();

  // Tickbox states
  bool _canContactDirectly = false;
  bool _canMakeDecisions = false;
  bool _isLicensed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Partner Information Form',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Details
              _sectionTitle('Contact Details'),
              _buildTextFormField(
                  'Phone Number (with Country Code)', _phoneNumberController),
              _buildTextFormField(
                  'Official Contact Email Address', _officialEmailController),
              _buildTextFormField('Your Email Address', _yourEmailController),
              const SizedBox(height: 20),

              // Personal Information
              _sectionTitle('Personal Information'),
              _buildTextFormField('Your Full Name', _fullNameController),
              _buildTextFormField(
                  'Your Grade Level in the Company', _gradeLevelController),
              _buildCheckbox(
                  'Can we contact you directly?', _canContactDirectly, (value) {
                setState(() {
                  _canContactDirectly = value!;
                });
              }),
              _buildCheckbox(
                  'Are you at the level where you can take decisions regarding integration?',
                  _canMakeDecisions, (value) {
                setState(() {
                  _canMakeDecisions = value!;
                });
              }),
              const SizedBox(height: 20),

              // Company Details
              _sectionTitle('Company Details'),
              _buildTextFormField('Company Name', _companyNameController),
              _buildTextFormField(
                  'Country of Registration', _countryOfRegistrationController),
              _buildTextFormField(
                  'Country of Operation', _countryOfOperationController),
              _buildTextFormField('Head Office Address (Include Country)',
                  _headOfficeAddressController),
              _buildTextFormField('Primary Nature of Business',
                  _primaryNatureOfBusinessController),
              _buildCheckbox(
                  'Are you licensed by a regulator/government?', _isLicensed,
                  (value) {
                setState(() {
                  _isLicensed = value!;
                });
              }),
              if (_isLicensed)
                _buildTextFormField(
                    'Name of Regulator', _regulatorNameController),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.deepPurpleAccent, // Dark blue button
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const StadiumBorder(),
                      elevation: 8,
                      shadowColor: Colors.black87,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.deepPurpleAccent,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to submit this form')),
        );
        return;
      }

      final data = {
        'userId': user.uid,
        'phoneNumber': _phoneNumberController.text,
        'officialEmail': _officialEmailController.text,
        'yourEmail': _yourEmailController.text,
        'fullName': _fullNameController.text,
        'gradeLevel': _gradeLevelController.text,
        'canContactDirectly': _canContactDirectly,
        'canMakeDecisions': _canMakeDecisions,
        'companyName': _companyNameController.text,
        'countryOfRegistration': _countryOfRegistrationController.text,
        'countryOfOperation': _countryOfOperationController.text,
        'headOfficeAddress': _headOfficeAddressController.text,
        'primaryNatureOfBusiness': _primaryNatureOfBusinessController.text,
        'isLicensed': _isLicensed,
        'regulatorName': _isLicensed ? _regulatorNameController.text : null,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('partnerinformationsourcing').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );

      // Clear the form
      _formKey.currentState!.reset();
      setState(() {
        _canContactDirectly = false;
        _canMakeDecisions = false;
        _isLicensed = false;
      });
    }
  }
}
