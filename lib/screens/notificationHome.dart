import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';

class NotificationHome extends StatefulWidget {
  const NotificationHome({super.key});

  @override
  State<NotificationHome> createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  String activeFilter = "Tous";

  final filters = ["Tous", "Système", "Commandes", "Fans", "Promotions"];

  List<Map<String, dynamic>> notifs = [
    {
      "title": "Votre commande est en préparation",
      "body":
          "L’équipe logistique prépare votre colis. Merci pour votre achat.",
      "type": "Commandes",
      "date": "Il y a 3 min",
      "read": false,
    },
    {
      "title": "But incroyable de Sadio Mané !",
      "body": "Temps réel IA : xG très élevé détecté juste avant la frappe.",
      "type": "Fans",
      "date": "Il y a 10 min",
      "read": false,
    },
    {
      "title": "Mise à jour du système réussie",
      "body":
          "Votre application tourne désormais avec l’IA FanIntelligence 2.0.",
      "type": "Système",
      "date": "Il y a 25 min",
      "read": true,
    },
    {
      "title": "Promo exclusive",
      "body": "-20% sur les maillots officiels aujourd’hui seulement.",
      "type": "Promotions",
      "date": "Hier",
      "read": true,
    },
  ];

  IconData _iconForType(String type) {
    switch (type) {
      case "Commandes":
        return Icons.shopping_bag_rounded;
      case "Fans":
        return Icons.sports_soccer_rounded;
      case "Promotions":
        return Icons.local_offer_rounded;
      case "Système":
        return Icons.settings_suggest_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case "Commandes":
        return gaindeGreen;
      case "Fans":
        return gaindeGold;
      case "Promotions":
        return gaindeRed;
      case "Système":
        return gaindeInk.withOpacity(.8);
      default:
        return gaindeGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = activeFilter == "Tous"
        ? notifs
        : notifs.where((n) => n["type"] == activeFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in notifs) {
                  n["read"] = true;
                }
              });
            },
            child: const Text(
              "Tout marquer comme lu",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // FILTRES
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: filters.length,
              itemBuilder: (_, i) {
                final f = filters[i];
                final selected = f == activeFilter;

                return ChoiceChip(
                  label: Text(f),
                  selected: selected,
                  onSelected: (_) {
                    setState(() => activeFilter = f);
                  },
                  selectedColor: gaindeGreenSoft,
                  side: BorderSide(
                    color: selected ? gaindeGreen : gaindeInk.withOpacity(.20),
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: selected ? gaindeGreen : gaindeInk,
                  ),
                );
              },
            ),
          ),

          // LISTE
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final n = filtered[i];

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: n["read"]
                        ? Colors.white.withOpacity(.6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: _colorForType(n["type"]).withOpacity(.25),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: _colorForType(
                        n["type"],
                      ).withOpacity(.15),
                      child: Icon(
                        _iconForType(n["type"]),
                        color: _colorForType(n["type"]),
                      ),
                    ),
                    title: Text(
                      n["title"],
                      style: TextStyle(
                        fontWeight: n["read"]
                            ? FontWeight.w600
                            : FontWeight.w900,
                      ),
                    ),
                    subtitle: Text(
                      n["body"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          n["date"],
                          style: TextStyle(
                            fontSize: 12,
                            color: gaindeInk.withOpacity(.5),
                          ),
                        ),
                        if (!n["read"])
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: _colorForType(n["type"]),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      setState(() => n["read"] = true);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
