import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

void main() {
  runApp(const NewsApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        cardTheme: CardThemeData(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.blueGrey[800]!, width: 1.5),
          ),
          color: Colors.grey[850],
          shadowColor: Colors.black.withOpacity(0.5),
          margin: EdgeInsets.all(8),
        ),
      ),
      home: const HorizontalPagerScreen(),
    );
  }
}

class HorizontalPagerScreen extends StatefulWidget {
  const HorizontalPagerScreen({super.key});

  @override
  State<HorizontalPagerScreen> createState() => _HorizontalPagerScreenState();
}

class _HorizontalPagerScreenState extends State<HorizontalPagerScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<NewsItem> _savedArticles = []; // List to store saved articles

  final List<NewsPageContent> pages = [
    NewsPageContent(
      title: "Hot",
      newsItems: [
        NewsItem(
          title: "Krisis Hukum",
          description:
              "Beberapa waktu yang lalu terdapat suatu negara dengan krisis hukum yang cukup rusak",
          imageUrl:
              "https://awsimages.detik.net.id/community/media/visual/2023/05/14/kilas-balik-perjuangan-reformasi-25-tahun-lalu-2_169.jpeg?w=1200",
          articleUrl:
              "https://www.detik.com/sulsel/berita/d-6729948/sejarah-hari-peringatan-reformasi-kerusuhan-1998-hingga-lengsernya-soeharto",
        ),
      ],
      icon: Icons.local_fire_department,
    ),
    NewsPageContent(
      title: "Teknologi AGC-11",
      newsItems: [
        NewsItem(
          title: "Apollo Guidance Computer - 11",
          description:
              "Sebuah model computer klasik tingkat lanjut dengan instruksi mesin assembly AGC yang mampu mengubah suatu era ke revolusioner",
          imageUrl:
              "https://www.nasa.gov/wp-content/uploads/static/history/afj/pics/dsky.jpg",
          articleUrl: "https://en.wikipedia.org/wiki/Apollo_Guidance_Computer",
        ),
      ],
      icon: Icons.computer,
    ),
    NewsPageContent(
      title: "Science",
      newsItems: [
        NewsItem(
          title: "Rumus Kalkulus",
          description:
              "Kalkulus adalah suatu konsep yang pada intinya mempelajari suatu limitasi dengan integral dan derivatif",
          imageUrl:
              "https://miro.medium.com/v2/resize:fit:1400/1*yXBeXMG-Td2h1DQqZBkHcw.jpeg",
          articleUrl: "https://www.khanacademy.org/math/calculus-1",
        ),
      ],
      icon: Icons.science,
    ),
    NewsPageContent(
      title: "Saved Articles", // New page for saved articles
      newsItems: [], // Initially empty, will be populated dynamically
      icon: Icons.bookmark, // Icon for saved articles
    ),
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        _scaffoldKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi Nguawor'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.newspaper, size: 48, color: Colors.blue),
            SizedBox(height: 16),
            Text('Nguawor lho ya v1.0'),
            SizedBox(height: 8),
            Text('© 2025 Vinzsan'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _saveArticle(NewsItem item) {
    setState(() {
      if (!_savedArticles.contains(item)) {
        _savedArticles.add(item);
        pages[3].newsItems.add(item); // Add to saved articles page
      }
    });
  }

  void _toggleLike(NewsItem item) {
    setState(() {
      item.isLiked = !item.isLiked; // Toggle the like status
    });
  }

  void _shareArticle(String url) {
    Share.share(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: pages.map(_buildPage).toList(),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey[900]!, Colors.indigo[900]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  'News Reader',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text('Artikel Tersimpan'),
            onTap: () {
              // Navigate to saved articles page
              _pageController.jumpToPage(3); // Jump to saved articles page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.green),
            title: const Text('History'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: const Text('Notifikasi'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: const Text('Tentang'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Keluar'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(pages[_currentPage].icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            pages[_currentPage].title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildPage(NewsPageContent page) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.black54, Colors.grey[850]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: page.newsItems.map((item) => _buildNewsCard(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildNewsCard(NewsItem item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _launchURL(item.articleUrl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '2 jam lalu',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          item.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: item.isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          _toggleLike(item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          _shareArticle(item.articleUrl);
                        },
                        color: Colors.blue,
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () {
                          _saveArticle(item);
                        },
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class NewsPageContent {
  final String title;
  final List<NewsItem> newsItems;
  final IconData icon;

  NewsPageContent({
    required this.title,
    required this.newsItems,
    required this.icon,
  });
}

class NewsItem {
  final String title;
  final String description;
  final String imageUrl;
  final String articleUrl;
  bool isLiked; // Track like status

  NewsItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.articleUrl,
    this.isLiked = false, // Default to not liked
  });
}
