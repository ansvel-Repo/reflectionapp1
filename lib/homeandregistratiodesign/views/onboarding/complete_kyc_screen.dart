import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompleteKYCScreen extends StatefulWidget {
  const CompleteKYCScreen({super.key});
  @override
  State<CompleteKYCScreen> createState() => _CompleteKYCScreenState();
}

class _CompleteKYCScreenState extends State<CompleteKYCScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upgrade to Tier 3",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 4) {
            setState(() => _currentStep += 1);
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Upgrade request submitted successfully!"),
              ),
            );
          }
        },
        onStepCancel: () =>
            _currentStep > 0 ? setState(() => _currentStep -= 1) : null,
        onStepTapped: (step) => setState(() => _currentStep = step),
        steps: [
          _buildStep(
            title: "Upload Proof of Address",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(FontAwesomeIcons.fileArrowUp),
                  label: const Text("Upload Document"),
                  onPressed: () {
                    /* File picker logic would go here */
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  "Acceptable Documents:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const _AcceptableDocumentsList(),
              ],
            ),
          ),
          _buildStep(
            title: "Personal Details",
            content: Column(
              children: [
                _buildDropdown("Gender", ["Male", "Female", "Other"]),
                _buildTextFormField(
                  "Date of Birth",
                  FontAwesomeIcons.calendar,
                  isDate: true,
                ),
                _buildTextFormField("Place of Birth", FontAwesomeIcons.mapPin),
                _buildTextFormField(
                  "Mother's Maiden Name",
                  FontAwesomeIcons.personDress,
                ),
                _buildDropdown("Marital Status", [
                  "Single",
                  "Married",
                  "Divorced",
                ]),
              ],
            ),
          ),
          _buildStep(
            title: "Financial Profile",
            content: Column(
              children: [
                _buildDropdown("Source of Funds/Wealth", [
                  "Salary",
                  "Business",
                  "Inheritance",
                ]),
                _buildDropdown("Employment Status", [
                  "Employed",
                  "Self-Employed",
                  "Unemployed",
                ]),
                _buildTextFormField(
                  "Employer's Name",
                  FontAwesomeIcons.building,
                ),
              ],
            ),
          ),
          _buildStep(
            title: "Next of Kin",
            content: Column(
              children: [
                _buildTextFormField("Full Name", FontAwesomeIcons.user),
                _buildTextFormField(
                  "Phone Number",
                  FontAwesomeIcons.phone,
                  isNumber: true,
                ),
              ],
            ),
          ),
          _buildStep(
            title: "Additional Information",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Services Required",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const _ServiceSelection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Step _buildStep({required String title, required Widget content}) => Step(
    title: Text(title),
    content: content,
    isActive: _currentStep >= 0,
    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
  );
  Widget _buildTextFormField(
    String label,
    IconData icon, {
    bool isDate = false,
    bool isNumber = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      readOnly: isDate,
      onTap: isDate
          ? () => showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            )
          : null,
    ),
  );
  Widget _buildDropdown(String label, List<String> items) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {},
    ),
  );
}

class _AcceptableDocumentsList extends StatelessWidget {
  const _AcceptableDocumentsList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _DocumentItem(
          text: "Utility Bill (e.g., PHCN, Water) not older than 3 months.",
        ),
        _DocumentItem(text: "Recent Bank Statement not older than 3 months."),
        _DocumentItem(text: "Valid Tenancy Agreement or Rent Receipt."),
        _DocumentItem(text: "Recent Tax Assessment or Clearance Certificate."),
        _DocumentItem(
          text: "National ID Card (NIN Slip) showing your address.",
        ),
        _DocumentItem(
          text: "Letter from a recognized public official or employer.",
        ),
      ],
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final String text;
  const _DocumentItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ServiceSelection extends StatefulWidget {
  const _ServiceSelection();
  @override
  State<_ServiceSelection> createState() => _ServiceSelectionState();
}

class _ServiceSelectionState extends State<_ServiceSelection> {
  final Map<String, bool> _services = {
    'ATM Card': false,
    'Email Transaction Alerts': false,
    'Internet Web Application': false,
    'SMS Transaction Alerts': false,
  };
  @override
  Widget build(BuildContext context) => Column(
    children: _services.keys
        .map(
          (String key) => CheckboxListTile(
            title: Text(key),
            value: _services[key],
            onChanged: (bool? value) => setState(() => _services[key] = value!),
          ),
        )
        .toList(),
  );
}
