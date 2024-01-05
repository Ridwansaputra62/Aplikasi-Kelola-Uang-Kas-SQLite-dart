import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'login_page.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  // Menambah variabel untuk menyimpan status show/hide password
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;

  Future<bool> updatePassword() async {
    return await DataHelper().updatePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text('Pengaturan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: const AssetImage('assets/cashbook_logo.png'),
                ),
                const SizedBox(height: 10),
                const Text(
                  '@kelompokjingga',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Ganti Password',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text('Password Saat ini'),
            TextField(
              controller: _currentPasswordController,
              obscureText: !_showCurrentPassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_showCurrentPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showCurrentPassword = !_showCurrentPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Password Baru'),
            TextField(
              controller: _newPasswordController,
              obscureText: !_showNewPassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_showNewPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                (_currentPasswordController.text == "" || _newPasswordController.text == "")
                    ? showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Field tidak boleh kosong'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      )
                    : updatePassword().then(
                        (value) {
                          if (value) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text('Password berhasil diubah'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Password gagal diubah, cek password saat ini'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      );
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text('Yakin ingin keluar?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: const Text('Ya'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
