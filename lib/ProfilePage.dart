import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  final String userRole; // Roles: 'customer', 'admin', 'guest'
  final String initialName;
  final String initialEmail;
  final List<Map<String, dynamic>> orders; // Receives dynamic checkout orders from MainPage
  final VoidCallback? onLogout;

  const Profilepage({
    super.key,
    this.userRole = 'customer',
    this.initialName = 'Thim Sitha',
    this.initialEmail = 'sitha@example.com',
    this.orders = const [],
    this.onLogout,
  });

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late String userName;
  late String userEmail;

  // Selected state for address & payment
  String _selectedAddress = 'Home (Phnom Penh, Cambodia)';
  String _selectedPaymentMethod = 'ABA PAY';

  // Saved delivery addresses
  final List<Map<String, String>> _addresses = [
    {
      'title': 'Home',
      'details': 'St. 271, Sen Sok, Phnom Penh, Cambodia',
    },
    {
      'title': 'Office',
      'details': 'Vattanac Capital Tower, Daun Penh, Phnom Penh',
    },
    {
      'title': 'University Campus',
      'details': 'RUPP Campus 1, Toul Kork, Phnom Penh',
    },
  ];

  // Saved payment options
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'ABA PAY',
      'icon': Icons.account_balance_wallet,
      'subtitle': 'Fast Scan QR',
    },
    {
      'name': 'Credit / Debit Card',
      'icon': Icons.credit_card,
      'subtitle': 'Visa •••• 4242',
    },
    {
      'name': 'Cash on Delivery',
      'icon': Icons.payments_outlined,
      'subtitle': 'Pay with cash upon arrival',
    },
  ];

  @override
  void initState() {
    super.initState();
    userName = widget.initialName;
    userEmail = widget.initialEmail;
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedName = prefs.getString('profile_name');
    final String? savedEmail = prefs.getString('profile_email');
    final String? savedAddress = prefs.getString('selected_address');
    final String? savedPayment = prefs.getString('selected_payment');

    if (!mounted) return;
    setState(() {
      if (savedName != null) userName = savedName;
      if (savedEmail != null) userEmail = savedEmail;
      if (savedAddress != null) _selectedAddress = savedAddress;
      if (savedPayment != null) _selectedPaymentMethod = savedPayment;
    });
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person, color: Colors.brown),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.brown),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              onPressed: () async {
                final newName = nameController.text.trim();
                final newEmail = emailController.text.trim();

                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('profile_name', newName);
                await prefs.setString('profile_email', newEmail);

                if (!context.mounted) return;
                setState(() {
                  userName = newName;
                  userEmail = newEmail;
                });
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 1. MY ORDERS SHEET (Reads live orders from MainPage checkout)
  void _showMyOrdersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'My Orders History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: widget.orders.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'No past orders placed yet.',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      controller: scrollController,
                      itemCount: widget.orders.length,
                      itemBuilder: (context, index) {
                        final order = widget.orders[index];
                        final items = (order['items'] as List<dynamic>?) ?? [];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order['id'] ?? 'ORD-0000',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.brown[50],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        order['status'] ?? 'Processing',
                                        style: TextStyle(
                                          color: Colors.brown[700],
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Date: ${order['date'] ?? ''}',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                const Divider(height: 16),
                                const Text(
                                  'Items:',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                ...items.map((item) => Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                                  child: Text(
                                    '• $item',
                                    style: TextStyle(color: Colors.grey[800], fontSize: 13),
                                  ),
                                )),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Total: \$${(order['total'] as num?)?.toStringAsFixed(2) ?? "0.00"}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 2. SHIPPING ADDRESS SELECTOR
  void _showShippingAddressSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Shipping Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._addresses.map((address) {
                    final fullAddress = '${address['title']} (${address['details']})';
                    return RadioListTile<String>(
                      activeColor: Colors.brown,
                      value: fullAddress,
                      groupValue: _selectedAddress,
                      title: Text(
                        address['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(address['details']!),
                      onChanged: (val) async {
                        if (val != null) {
                          setModalState(() => _selectedAddress = val);
                          setState(() => _selectedAddress = val);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('selected_address', val);
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 3. PAYMENT METHODS SELECTOR
  void _showPaymentMethodsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._paymentMethods.map((method) {
                    final name = method['name'] as String;
                    final isSelected = _selectedPaymentMethod == name;
                    return ListTile(
                      leading: Icon(
                        method['icon'] as IconData,
                        color: isSelected ? Colors.brown : Colors.grey,
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(method['subtitle'] as String),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.brown)
                          : null,
                      onTap: () async {
                        setModalState(() => _selectedPaymentMethod = name);
                        setState(() => _selectedPaymentMethod = name);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('selected_payment', name);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvatarImage() {
    return ClipOval(
      child: Image.asset(
        'assets/images/Photos.jpg',
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 72,
          height: 72,
          color: Colors.brown[100],
          child: const Icon(Icons.person, size: 40, color: Colors.brown),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  _buildAvatarImage(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (widget.userRole == 'admin') ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.brown,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'ADMIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.userRole == 'guest' ? 'Logged in as Guest' : userEmail,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.userRole != 'guest')
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.brown),
                      onPressed: _showEditProfileDialog,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Account Settings Section
            if (widget.userRole != 'guest') ...[
              _buildSectionHeader('Account Settings'),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildProfileTile(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      subtitle: '${widget.orders.length} previous orders recorded',
                      onTap: _showMyOrdersSheet,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildProfileTile(
                      icon: Icons.location_on_outlined,
                      title: 'Shipping Address',
                      subtitle: _selectedAddress,
                      onTap: _showShippingAddressSheet,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildProfileTile(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      subtitle: _selectedPaymentMethod,
                      onTap: _showPaymentMethodsSheet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Preferences Section
            _buildSectionHeader('Preferences'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifications',
                    subtitle: 'Promotions & updates',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildProfileTile(
                    icon: Icons.security_outlined,
                    title: 'Privacy & Security',
                    subtitle: 'Password & account security',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildProfileTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'FAQs & customer service',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout / Sign In Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onLogout ?? () {},
                  icon: Icon(
                    widget.userRole == 'guest' ? Icons.login : Icons.logout,
                    color: widget.userRole == 'guest'
                        ? Colors.brown
                        : Colors.red,
                  ),
                  label: Text(
                    widget.userRole == 'guest' ? 'Sign In' : 'Log Out',
                    style: TextStyle(
                      color: widget.userRole == 'guest'
                          ? Colors.brown
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: widget.userRole == 'guest'
                          ? Colors.brown
                          : Colors.red,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}