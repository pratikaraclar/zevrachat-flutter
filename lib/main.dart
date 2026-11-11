
import 'package:flutter/material.dart';

void main() => runApp(const ZevraChat());

const gold = Color(0xFFD6AE55);
const purple = Color(0xFF24113D);
const dark = Color(0xFF090711);
const panel = Color(0xFF191322);

class ZevraChat extends StatelessWidget {
  const ZevraChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZevraChat',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.graphic_eq, color: gold, size: 75),
              const SizedBox(height: 12),
              const Text(
                'ZevraChat',
                style: TextStyle(
                  color: gold,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Sesinle kendini ifade et'),
              const SizedBox(height: 35),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı adın',
                  filled: true,
                  fillColor: panel,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              GoldButton(
                text: 'Giriş Yap',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainPage(
                        username: name.text.trim().isEmpty
                            ? 'Zevra Üyesi'
                            : name.text.trim(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const GoldButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: dark,
          padding: const EdgeInsets.all(15),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final String username;

  const MainPage({super.key, required this.username});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selected = 0;
  int coins = 5000;
  String username = '';
  final List<Map<String, dynamic>> rooms = [
    {'name': 'Gece Muhabbeti', 'category': 'Sohbet', 'users': 12},
    {'name': 'Müzik Dünyası', 'category': 'Müzik', 'users': 8},
    {'name': 'Yeni Arkadaşlar', 'category': 'Tanışma', 'users': 15},
    {'name': 'VIP Lounge', 'category': 'VIP', 'users': 6},
  ];

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  void openRoom(Map<String, dynamic> room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoomPage(
          roomName: room['name'],
          username: username,
          onGift: (amount) {
            setState(() => coins += amount);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      roomsPage(),
      messagesPage(),
      vipPage(),
      profilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark,
        title: const Text(
          'ZevraChat',
          style: TextStyle(color: gold, fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Text(
              '🪙 $coins  ',
              style: const TextStyle(color: gold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: gold),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: pages[selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: panel,
        selectedItemColor: gold,
        unselectedItemColor: Colors.white54,
        onTap: (value) => setState(() => selected = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Odalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium),
            label: 'VIP',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Hoş geldin!',
          style: TextStyle(fontSize: 25, color: gold),
        ),
        const SizedBox(height: 8),
        Text('$username, ZevraChat dünyasına hoş geldin.'),
        const SizedBox(height: 22),
        section('ÖNE ÇIKAN SES ODASI'),
        roomCard(rooms[0]),
        const SizedBox(height: 20),
        section('POPÜLER ODALAR'),
        ...rooms.take(3).map(roomCard),
        const SizedBox(height: 20),
        section('ÇEVRİMİÇİ ARKADAŞLAR'),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Friend(name: 'Mira', color: Colors.pink),
            Friend(name: 'Aras', color: Colors.blue),
            Friend(name: 'Luna', color: Colors.purple),
            Friend(name: 'Efe', color: Colors.green),
          ],
        ),
      ],
    );
  }

  Widget roomsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        section('SES SOHBET ODALARI'),
        GoldButton(
          text: '+ Yeni Oda Oluştur',
          onTap: createRoom,
        ),
        const SizedBox(height: 15),
        ...rooms.map(roomCard),
      ],
    );
  }

  Widget roomCard(Map<String, dynamic> room) {
    return Card(
      color: panel,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: purple,
          child: Icon(Icons.graphic_eq, color: gold),
        ),
        title: Text(
          room['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${room['category']} • ${room['users']} kişi çevrimiçi',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: gold),
        onTap: () => openRoom(room),
      ),
    );
  }

  Widget messagesPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        section('ÖZEL MESAJLAR'),
        for (final person in ['Mira', 'Aras', 'Luna', 'Efe'])
          Card(
            color: panel,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(person),
              subtitle: const Text('Sohbete başlamak için dokun'),
              trailing: const Icon(Icons.chat, color: gold),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrivateChatPage(name: person),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget vipPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Icon(Icons.workspace_premium, color: gold, size: 90),
        const Center(
          child: Text(
            'ZEVRACHAT VIP',
            style: TextStyle(
              color: gold,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Feature('Özel VIP rozeti'),
        const Feature('VIP kullanıcı görünümü'),
        const Feature('Özel profil teması'),
        const Feature('VIP oda erişimi tasarımı'),
        const SizedBox(height: 25),
        GoldButton(
          text: 'VIP Özelliklerini İncele',
          onTap: () => notice(context, 'VIP demo alanı açıldı.'),
        ),
        const SizedBox(height: 12),
        const Text(
          'Bu bölüm yalnızca demo gösterimidir. Gerçek ödeme alınmaz.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget profilePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(
          radius: 48,
          backgroundColor: purple,
          child: Icon(Icons.person, color: gold, size: 55),
        ),
        const SizedBox(height: 15),
        Center(
          child: Text(
            username,
            style: const TextStyle(color: gold, fontSize: 23),
          ),
        ),
        const SizedBox(height: 20),
        GoldButton(
          text: 'Profili Düzenle',
          onTap: editProfile,
        ),
        const SizedBox(height: 12),
        Card(
          color: panel,
          child: ListTile(
            leading: const Icon(Icons.monetization_on, color: gold),
            title: const Text('Demo jeton bakiyesi'),
            subtitle: Text('$coins jeton'),
          ),
        ),
      ],
    );
  }

  Widget section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: gold,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  void createRoom() {
    final controller = TextEditingController();
    String category = 'Sohbet';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: panel,
          title: const Text('Yeni Oda Oluştur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Oda adı',
                ),
              ),
              DropdownButton<String>(
                value: category,
                isExpanded: true,
                items: ['Sohbet', 'Müzik', 'Tanışma', 'VIP']
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => category = value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    rooms.insert(0, {
                      'name': controller.text.trim(),
                      'category': category,
                      'users': 1,
                    });
                  });
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Oluştur'),
            ),
          ],
        ),
      ),
    );
  }

  void editProfile() {
    final controller = TextEditingController(text: username);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: panel,
        title: const Text('Profil Düzenle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Kullanıcı adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => username = controller.text.trim());
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

class Friend extends StatelessWidget {
  final String name;
  final Color color;

  const Friend({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(name),
        const Text(
          'Çevrimiçi',
          style: TextStyle(color: Colors.green, fontSize: 11),
        ),
      ],
    );
  }
}

class Feature extends StatelessWidget {
  final String text;

  const Feature(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: gold),
      title: Text(text),
    );
  }
}

class RoomPage extends StatefulWidget {
  final String roomName;
  final String username;
  final Function(int) onGift;

  const RoomPage({
    super.key,
    required this.roomName,
    required this.username,
    required this.onGift,
  });

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool micOn = false;
  final controller = TextEditingController();
  final List<String> chat = ['ZevraChat odasına hoş geldiniz!'];
  final List<String> members = [
    'Mira', 'Aras', 'Luna', 'Efe',
    'Deniz', 'Mert', 'Ada', 'Can',
    'Ela', 'Ali', 'Naz', 'Eylül',
    'Bora', 'Defne', 'Emir', 'Sena',
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark,
        title: Text(widget.roomName),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: gold),
            onPressed: roomOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: purple,
            child: const Text(
              '16 KİŞİLİK SES SAHNESİ',
              textAlign: TextAlign.center,
              style: TextStyle(color: gold, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 16,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          index == 0 ? gold : purple,
                      child: Icon(
                        index == 0 ? Icons.star : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      members[index],
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(color: gold),
          Expanded(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: chat.map(
                (message) => Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(message),
                ),
              ).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Mesaj yaz...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: gold),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
          Container(
            color: panel,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    micOn ? Icons.mic : Icons.mic_off,
                    color: gold,
                  ),
                  onPressed: () {
                    setState(() => micOn = !micOn);
                    notice(
                      context,
                      micOn ? 'Mikrofon demo olarak açıldı' : 'Mikrofon kapatıldı',
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.pan_tool, color: gold),
                  onPressed: () => notice(context, 'Söz isteğin gönderildi.'),
                ),
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: gold),
                  onPressed: giftMenu,
                ),
                IconButton(
                  icon: const Icon(Icons.people, color: gold),
                  onPressed: showMembers,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      chat.add('${widget.username}: ${controller.text.trim()}');
      controller.clear();
    });
  }

  void giftMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: panel,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'SANAL HEDİYELER',
              style: TextStyle(color: gold, fontSize: 18),
            ),
          ),
          for (final gift in ['🌹 Gül', '❤️ Kalp', '👑 Taç', '💎 Elmas'])
            ListTile(
              title: Text(gift),
              trailing: const Icon(Icons.card_giftcard, color: gold),
              onTap: ()
