import 'package:ansvel/homeandregistratiodesign/models/ad_slide.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


const Uuid uuid = Uuid();

class AdManagementScreen extends StatefulWidget {
  const AdManagementScreen({super.key});

  @override
  State<AdManagementScreen> createState() => _AdManagementScreenState();
}

class _AdManagementScreenState extends State<AdManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _buttonTextController = TextEditingController(text: 'Learn More');
  final _actionTargetController = TextEditingController();
  AdActionType _selectedActionType = AdActionType.WebLink;
  bool _isPublishing = false;

  Future<void> _publishAd() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isPublishing = true;
      });

      final newAd = AdSlide(
        id: uuid.v4(),
        imageUrl: _imageUrlController.text.trim(),
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim(),
        buttonText: _buttonTextController.text.trim(),
        actionType: _selectedActionType,
        actionTarget: _actionTargetController.text.trim(),
      );

      try {
        await FirebaseFirestore.instance.collection('advertisements').add(newAd.toFirestore());
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ad published successfully!"), backgroundColor: Colors.green));
          _formKey.currentState!.reset();
          _buttonTextController.text = 'Learn More';
          _imageUrlController.clear();
          _titleController.clear();
          _subtitleController.clear();
          _actionTargetController.clear();
          setState(() {
            _selectedActionType = AdActionType.WebLink;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to publish ad: $e"), backgroundColor: Colors.red));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isPublishing = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _buttonTextController.dispose();
    _actionTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ad Management", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text("Create New Ad", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Background Image URL', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _subtitleController, decoration: const InputDecoration(labelText: 'Subtitle', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _buttonTextController, decoration: const InputDecoration(labelText: 'Button Text', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                DropdownButtonFormField<AdActionType>(
                  value: _selectedActionType,
                  decoration: const InputDecoration(labelText: 'Action Type', border: OutlineInputBorder()),
                  items: AdActionType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.name))).toList(),
                  onChanged: (v) => setState(() => _selectedActionType = v!),
                ),
                const SizedBox(height: 12),
                TextFormField(controller: _actionTargetController, decoration: InputDecoration(labelText: _selectedActionType == AdActionType.WebLink ? 'Web URL' : 'In-App Page Name', border: const OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isPublishing ? null : _publishAd,
                    icon: _isPublishing ? const SizedBox.shrink() : const Icon(Icons.publish),
                    label: _isPublishing
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                        : const Text("Publish Ad", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}