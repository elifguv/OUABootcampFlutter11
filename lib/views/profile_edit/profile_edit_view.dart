import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/bottom_navigation_bar.dart';
import 'profile_edit_viewmodel.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB71C1C)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<ProfileEditViewModel>(context, listen: false)
                  .updateUserData();
              Navigator.of(context).pop();
            },
            child: const Text('Done',
                style: TextStyle(color: Color(0xFFB71C1C), fontSize: 20)),
          )
        ],
        centerTitle: false,
      ),
      body: Consumer<ProfileEditViewModel>(
        builder: (context, viewModel, child) => Form(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              const SizedBox(height: 30),
              _buildTextField(viewModel.state.userName, 'Username',
                  onChanged: viewModel.updateUsername),
              const SizedBox(height: 30),
              _buildTextField(viewModel.state.email, 'Email',
                  onChanged: viewModel.updateEmail),
              const SizedBox(height: 30),
              _buildTextField(
                viewModel.state.location,
                'Location',
                onChanged: (value) => viewModel.state.location = value,
              ) //update locally,
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
      ),
    );
  }

  Widget _buildTextField(String initialValue, String labelText,
      {required Function(String) onChanged, int maxLines = 1}) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), //rounded corners
        ),
        labelText: labelText,
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
