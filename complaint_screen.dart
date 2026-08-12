import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';
import '../services/sampark_launcher.dart';
import '../services/reference_generator.dart';
import '../services/offline_cache_service.dart';
import '../widgets/disclaimer_banner.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'पानी (Drinking Water)';
  final TextEditingController _descController = TextEditingController();
  
  String? _generatedRefId;
  String? _gpsLocation;
  String? _attachedFile;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'पानी (Drinking Water)',
    'बिजली (Electricity Supply)',
    'सड़क (Road & Pathways)',
    'नाली एवं जलजमाव (Drainage)',
    'सफाई (Sanitation & Waste)',
    'स्ट्रीट लाइट (Street Lighting)',
    'अन्य ग्रामीण समस्या (Others)',
  ];

  void _generateReference() {
    setState(() {
      _generatedRefId = ReferenceGenerator.generateComplaintReference();
    });
  }

  void _getGpsLocation() {
    setState(() {
      _gpsLocation = '24.5241° N, 76.1724° E (हरनावदा गजा, झालरापाटन)';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('GPS स्थान सफलतापूर्वक प्राप्त किया गया।')),
    );
  }

  void _attachPhoto() {
    setState(() {
      _attachedFile = 'IMG_20260812_Harnawada_Gaja.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('फ़ोटो संलग्न की गई।')),
    );
  }

  Future<void> _submitGrievance() async {
    if (_formKey.currentState!.validate()) {
      if (_generatedRefId == null) {
        _generateReference();
      }

      setState(() {
        _isSubmitting = true;
      });

      final complaintData = {
        'reference_id': _generatedRefId,
        'category': _selectedCategory,
        'description': _descController.text,
        'location': _gpsLocation ?? 'हरनावदा गजा',
        'attached_file': _attachedFile,
        'created_at': DateTime.now().toIso8601String(),
      };

      await OfflineCacheService.saveComplaintLocally(complaintData);

      setState(() {
        _isSubmitting = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          title: const Text('शिकायत दर्ज (टीम गोपालसिंह)', style: TextStyle(color: AppColors.royalGold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('आपकी शिकायत की आंतरिक संदर्भ आईडी: $_generatedRefId', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.saffronAccent)),
              const SizedBox(height: 10),
              Text(ReferenceGenerator.disclaimer, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ठीक है', style: TextStyle(color: AppColors.royalGold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                SamparkLauncher.launchSamparkPortal();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.saffronAccent),
              child: const Text('181 संपर्क पोर्टल खोलें'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('nav_complaint')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DisclaimerBanner(),
              const SizedBox(height: 16),

              // Category Picker
              const Text('शिकायत की श्रेणी चुनें *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.royalGold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderGold),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: AppColors.cardDark,
                    style: const TextStyle(color: AppColors.white, fontSize: 14),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Text('समस्या का विस्तृत विवरण *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.royalGold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                style: const TextStyle(color: AppColors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'समस्या का स्थान, संबंधित विवरण आदि लिखें...',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  fillColor: AppColors.cardDark,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderGold)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'कृपया समस्या का विवरण दर्ज करें' : null,
              ),

              const SizedBox(height: 16),

              // GPS and Photo Attachment Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _getGpsLocation,
                      icon: const Icon(Icons.my_location_rounded, size: 18),
                      label: Text(_gpsLocation == null ? 'GPS लोकेशन जोड़ें' : 'लोकेशन टैग की गई'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _attachPhoto,
                      icon: const Icon(Icons.add_a_photo_rounded, size: 18),
                      label: Text(_attachedFile == null ? 'फ़ोटो/दस्तावेज़' : 'फ़ोटो संलग्न'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Reference ID Preview
              if (_generatedRefId != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.royalNavy,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.royalGold),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('आपकी संदर्भ संख्या:', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      Text(_generatedRefId!, style: const TextStyle(color: AppColors.saffronAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitGrievance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.royalGold,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: AppColors.royalNavy)
                      : const Text('टीम गोपालसिंह के पास दर्ज करें', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(color: AppColors.borderGold),
              const SizedBox(height: 10),

              // Official Sampark Portal Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    SamparkLauncher.launchSamparkPortal();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.saffronAccent, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.launch_rounded, color: AppColors.saffronAccent),
                  label: Text(
                    AppStrings.get('sampark_portal_btn'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.saffronAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
