import 'package:flutter/material.dart';
import 'DatabaseService.dart'; // Ensure this import matches your actual file naming
import 'auth_service.dart';

class ManageProfilePage extends StatefulWidget {
  final String username;

  ManageProfilePage({required this.username});

  @override
  _ManageProfilePageState createState() => _ManageProfilePageState();
}

class _ManageProfilePageState extends State<ManageProfilePage> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _referenceCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController(); // Added field

  String? _selectedDistrict;
  String? _selectedState;

  final List<String> _states = [
    'Johor', 'Kedah', 'Kelantan', 'Malacca', 'Negeri Sembilan', 'Pahang',
    'Penang', 'Perak', 'Perlis', 'Sabah', 'Sarawak', 'Selangor', 'Terengganu'
  ];

  final Map<String, List<String>> _districts = {
    'Johor': ['Johor Bahru', 'Kulai', 'Muar', 'Pontian', 'Segamat'],
    'Kedah': ['Alor Setar', 'Kuala Kedah', 'Kota Setar', 'Langkawi'],
    'Kelantan': ['Kota Bharu', 'Pasir Mas', 'Tumpat'],
    'Malacca': ['Melaka Tengah', 'Jasin', 'Alor Gajah'],
    'Negeri Sembilan': ['Seremban', 'Port Dickson', 'Kuala Pilah'],
    'Pahang': ['Kuantan', 'Temerloh', 'Pekan'],
    'Penang': ['George Town', 'Butterworth'],
    'Perak': ['Ipoh', 'Taiping', 'Parit Buntar'],
    'Perlis': ['Kangar'],
    'Sabah': ['Kota Kinabalu', 'Sandakan', 'Tawau'],
    'Sarawak': ['Kuching', 'Sibu', 'Miri'],
    'Selangor': ['Shah Alam', 'Petaling Jaya', 'Subang Jaya'],
    'Terengganu': ['Kuala Terengganu', 'Dungun', 'Kemaman'],
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _databaseService.getUserData(widget.username);
    if (userData.isNotEmpty) {
      setState(() {
        _fullNameController.text = userData['fullName'] ?? '';
        _streetNumberController.text = userData['streetNumber'] ?? '';
        _streetNameController.text = userData['streetName'] ?? '';
        _ageController.text = userData['age'] ?? '';
        _genderController.text = userData['gender'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneNumberController.text = userData['phoneNumber'] ?? ''; // Added field
        _selectedState = userData['state'];
        _selectedDistrict = userData['district'];
      });
    }
  }

  Future<void> _updateProfile() async {
    final updated = await _databaseService.updateUserProfile(
      widget.username,
      _emailController.text.trim(),
      _fullNameController.text.trim(),
      _phoneNumberController.text.trim(), // Added field
      _streetNumberController.text.trim(),
      _streetNameController.text.trim(),
      int.tryParse(_ageController.text.trim()) ?? 0, // Convert to int
      _genderController.text.trim(),
      _referenceCodeController.text.trim(),
      _selectedState ?? '',
      _selectedDistrict ?? '',
    );

    if (updated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headlineStyle = Theme.of(context).textTheme.headlineSmall ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium ?? TextStyle(fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Personal Information', style: headlineStyle),
              SizedBox(height: 16),
              _buildTextField(_fullNameController, 'Full Name', bodyStyle),
              SizedBox(height: 16),
              _buildTextField(_emailController, 'Email', bodyStyle),
              SizedBox(height: 16),
              _buildTextField(_phoneNumberController, 'Phone Number', bodyStyle), // Added field
              SizedBox(height: 16),
              _buildTextField(_ageController, 'Age', bodyStyle),
              SizedBox(height: 16),
              _buildDropdownField('Gender', _genderController.text, ['Male', 'Female', 'Other'], (value) {
                setState(() {
                  _genderController.text = value!;
                });
              }, bodyStyle),
              SizedBox(height: 16),
              Text('Address', style: headlineStyle),
              SizedBox(height: 16),
              _buildTextField(_streetNumberController, 'Street Number', bodyStyle),
              SizedBox(height: 16),
              _buildTextField(_streetNameController, 'Street Name', bodyStyle),
              SizedBox(height: 16),
              _buildDropdownField('State', _selectedState, _states, (value) {
                setState(() {
                  _selectedState = value;
                  _selectedDistrict = null; // Reset district when state changes
                });
              }, bodyStyle),
              SizedBox(height: 16),
              _buildDropdownField('District', _selectedDistrict, _districts[_selectedState], (value) {
                setState(() {
                  _selectedDistrict = value;
                });
              }, bodyStyle),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextStyle style, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your $label',
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue, List<String>? items, ValueChanged<String?> onChanged, TextStyle style) {
    final String? validSelectedValue = items?.contains(selectedValue) == true ? selectedValue : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style),
        DropdownButtonFormField<String>(
          value: validSelectedValue,
          hint: Text('Select $label'),
          items: items?.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
