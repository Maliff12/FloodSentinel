import 'package:flutter/material.dart';
import 'auth_service.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController(); // New Field
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _referenceCodeController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isCommunityUser = true; // Default to community user registration

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

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final TextStyle headlineStyle = Theme.of(context).textTheme.headlineSmall ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium ?? TextStyle(fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _buildPersonalInfoPage(headlineStyle, bodyStyle),
          _buildAddressPage(headlineStyle, bodyStyle),
          _buildAccountDetailsPage(headlineStyle, bodyStyle),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage(TextStyle headlineStyle, TextStyle bodyStyle) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Information', style: headlineStyle),
            SizedBox(height: 16),
            _buildTextField(_fullNameController, 'Full Name', bodyStyle),
            SizedBox(height: 16),
            _buildTextField(_phoneNumberController, 'Phone Number', bodyStyle), // New Field
            SizedBox(height: 16),
            _buildTextField(_ageController, 'Age', bodyStyle),
            SizedBox(height: 16),
            _buildDropdownField('Gender', _genderController.text, ['Male', 'Female', 'Other'], (value) {
              setState(() {
                _genderController.text = value!;
              });
            }, bodyStyle),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_validatePersonalInfo()) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressPage(TextStyle headlineStyle, TextStyle bodyStyle) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              onPressed: () {
                if (_validateAddress()) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetailsPage(TextStyle headlineStyle, TextStyle bodyStyle) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Details', style: headlineStyle),
            SizedBox(height: 16),
            Text('Register As', style: bodyStyle),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Community', style: bodyStyle),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: _isCommunityUser,
                      onChanged: (value) {
                        setState(() {
                          _isCommunityUser = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Authority', style: bodyStyle),
                    leading: Radio<bool>(
                      value: false,
                      groupValue: _isCommunityUser,
                      onChanged: (value) {
                        setState(() {
                          _isCommunityUser = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (!_isCommunityUser) ...[
              SizedBox(height: 16),
              _buildTextField(_referenceCodeController, 'Reference Code', bodyStyle),
            ],
            SizedBox(height: 16),
            _buildTextField(_usernameController, 'Username', bodyStyle),
            SizedBox(height: 16),
            _buildTextField(_emailController, 'Email', bodyStyle),
            SizedBox(height: 16),
            _buildTextField(_passwordController, 'Password', bodyStyle, obscureText: true),
            SizedBox(height: 16),
            _buildTextField(_confirmPasswordController, 'Confirm Password', bodyStyle, obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
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

  bool _validatePersonalInfo() {
    if (_fullNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty || // Added validation
        _ageController.text.isEmpty ||
        _genderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required personal information fields')),
      );
      return false;
    }
    return true;
  }

  bool _validateAddress() {
    if (_streetNumberController.text.isEmpty ||
        _streetNameController.text.isEmpty ||
        _selectedState == null ||
        _selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required address fields')),
      );
      return false;
    }
    return true;
  }

  Future<void> _register() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String fullName = _fullNameController.text;
    String phoneNumber = _phoneNumberController.text; // Added
    String streetNumber = _streetNumberController.text;
    String streetName = _streetNameController.text;
    String age = _ageController.text;
    String gender = _genderController.text;
    String district = _selectedDistrict ?? '';
    String state = _selectedState ?? '';
    String referenceCode = _referenceCodeController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    bool success;
    if (_isCommunityUser) {
      success = await _authService.registerCommunity(
        username,
        email,
        password,
        fullName,
        phoneNumber, // Added
        streetNumber,
        streetName,
        district,
        state,
        age,
        gender,
      );
    } else {
      success = await _authService.registerAsAuthority(
        username,
        email,
        password,
        referenceCode,
        fullName,
        phoneNumber, // Added
        streetNumber,
        streetName,
        district,
        state,
        age,
        gender,
      );
    }

    if (success) {
      Navigator.of(context).pop(); // Navigate back or show success message
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed')),
      );
    }
  }
}
