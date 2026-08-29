import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ═══════════════════════════════
          // PHOTO DE PROFIL
          // ═══════════════════════════════
          const Center(
            child: CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 55),
            ),
          ),

          const SizedBox(height: 16),

          // ═══════════════════════════════
          // NOM UTILISATEUR
          // ═══════════════════════════════
          const Center(
            child: Text(
              'Utilisateur EMA Shop',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 6),

          // ═══════════════════════════════
          // EMAIL
          // ═══════════════════════════════
          const Center(
            child: Text(
              'email@exemple.com',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          const SizedBox(height: 30),

          // ═══════════════════════════════
          // INFORMATIONS PERSONNELLES
          // ═══════════════════════════════
          _ProfileItem(
            icon: Icons.person_outline,
            title: 'Informations personnelles',
            onTap: () {
              _showMessage(context, 'Modification du profil prochainement.');
            },
          ),

          _ProfileItem(
            icon: Icons.email_outlined,
            title: 'Adresse email',
            onTap: () {
              _showMessage(context, 'Gestion de l\'email prochainement.');
            },
          ),

          _ProfileItem(
            icon: Icons.phone_outlined,
            title: 'Numéro de téléphone',
            onTap: () {
              _showMessage(context, 'Gestion du téléphone prochainement.');
            },
          ),

          const SizedBox(height: 12),

          // ═══════════════════════════════
          // COMMANDES
          // ═══════════════════════════════
          _ProfileItem(
            icon: Icons.receipt_long_outlined,
            title: 'Mes commandes',
            onTap: () {
              _showMessage(context, 'Historique des commandes prochainement.');
            },
          ),

          // ═══════════════════════════════
          // PARAMÈTRES
          // ═══════════════════════════════
          _ProfileItem(
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () {
              _showMessage(context, 'Paramètres prochainement.');
            },
          ),

          const SizedBox(height: 24),

          // ═══════════════════════════════
          // DÉCONNEXION
          // ═══════════════════════════════
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════
  // MESSAGE
  // ═══════════════════════════════

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ═══════════════════════════════
  // DIALOGUE DE DÉCONNEXION
  // ═══════════════════════════════

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                _showMessage(context, 'Déconnexion prochainement.');
              },
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════
// WIDGET : ÉLÉMENT DU PROFIL
// ═══════════════════════════════════════

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
