import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const NewsApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        // gunakan base.cardTheme.copyWith => kompatibel di banyak versi Flutter
        cardTheme: base.cardTheme.copyWith(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.blueGrey[800]!, width: 1.5),
          ),
          color: Colors.grey[850],
          shadowColor: Colors.black.withOpacity(0.5),
          margin: const EdgeInsets.all(8),
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
  final List<NewsItem> _savedArticles = [];
  XFile? _profileImage; // foto profil sementara

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _profileImage = image);
      }
    } catch (e) {
      // ignore errors on platforms without gallery access (desktop)
    }
  }

  final List<NewsPageContent> pages = [];

  @override
void initState() {
  super.initState();
  pages.addAll([
    NewsPageContent(
      title: "Hot",
      newsItems: [
        NewsItem(
          title: "Krisis Hukum",
          description: "Krisis hukum besar melanda negara tertentu...",
          localImage: "assets/logo_hot.jpeg",
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
          title: "Apollo Guidance Computer",
          description: "Komputer klasik revolusioner dengan instruksi mesin AGC.",
          localImage: "assets/logo_tekno.jpeg",
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
          description: "Kalkulus mempelajari limitasi dengan integral & derivatif.",
          localImage: "assets/logo_science.png",
          articleUrl: "https://www.khanacademy.org/math/calculus-1",
        ),
      ],
      icon: Icons.science,
    ),
    NewsPageContent(
      title: "Sports",
      newsItems: [
        NewsItem(
          title: "Final Sepak Bola",
          description: "Pertandingan seru terjadi di kejuaraan dunia...",
          localImage: "assets/logo_sports.jpeg",
          articleUrl: "https://www.antaranews.com/tag/final-sepakbola",
        ),
      ],
      icon: Icons.sports_soccer,
    ),
    NewsPageContent(
      title: "Health",
      newsItems: [
        NewsItem(
          title: "Tips Hidup Sehat",
          description: "Menjaga pola makan dan olahraga teratur.",
          localImage: "assets/logo_health.jpeg",
          articleUrl:
              "https://www.aia-financial.co.id/id/health-and-wellness/aia-content-club/physical-wellness/7-tips-pola-hidup-sehat-agar-tidak-mudah-sakit",
        ),
      ],
      icon: Icons.health_and_safety,
    ),
    NewsPageContent(
      title: "Business",
      newsItems: [
        NewsItem(
          title: "Pasar Saham",
          description: "Indeks saham naik drastis hari ini.",
          localImage: "assets/logo_business.jpeg",
          articleUrl: "https://www.cnbc.com/finance/",
        ),
      ],
      icon: Icons.business,
    ),
    NewsPageContent(
      title: "Entertainment",
      newsItems: [
        NewsItem(
          title: "Film Baru Rilis",
          description: "Film/Anime action terbaru ramai diperbincangkan di gadang gadang bisa menjadi anime overrated awoakwaok",
          localImage: "assets/logo_film.jpeg",
          articleUrl: "https://www.imdb.com/",
        ),
      ],
      icon: Icons.movie,
    ),
    NewsPageContent(
      title: "Saved Articles",
      newsItems: [],
      icon: Icons.bookmark,
    ),
  ]);
}
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final ctx = _scaffoldKey.currentContext;
      if (ctx != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
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
        pages.last.newsItems.add(item); // simpan ke "Saved Articles"
      }
    });
  }

  void _toggleLike(NewsItem item) {
    setState(() => item.isLiked = !item.isLiked);
  }

  void _shareArticle(String url) {
    Share.share(url);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     key: _scaffoldKey,
  //     drawer: _buildDrawer(context),
  //     appBar: _buildAppBar(),
  //     body: PageView(
  //       controller: _pageController,
  //       onPageChanged: (index) => setState(() => _currentPage = index),
  //       children: pages.map(_buildPage).toList(),
  //     ),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    key: _scaffoldKey,
    drawer: _buildDrawer(context),
    appBar: _buildAppBar(),
    body: Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: pages.map(_buildPage).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: pages.length,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 6,
              activeDotColor: Colors.blue,
              dotColor: Colors.grey.shade700,
            ),
          ),
        ),
      ],
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
            child: GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!.path))
                    : const AssetImage('assets/profile.png') as ImageProvider,
              ),
            ),
          ),
          ...List.generate(
            pages.length,
            (i) => ListTile(
              leading: Icon(pages[i].icon, color: Colors.white),
              title: Text(pages[i].title),
              onTap: () {
                _pageController.jumpToPage(i);
                Navigator.pop(context);
              },
            ),
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
          Text(pages[_currentPage].title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
          onPressed: () {
            showSearch(
              context: context,
              delegate: NewsSearchDelegate(
                  allNews: pages.expand((p) => p.newsItems).toList()),
            );
          },
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
        children: page.newsItems.isEmpty && page.title == "Saved Articles"
            ? [
                const SizedBox(height: 100),
                const Center(
                  child: Text(
                    "Tidak ada artikel yang disimpan",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ]
            : page.newsItems.map((item) => _buildNewsCard(item)).toList(),
      ),
    ),
  );
}
  Widget _buildNewsCard(NewsItem item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // Card sendiri sudah akan memakai ThemeData.cardTheme
      child: InkWell(
        onTap: () => _launchURL(item.articleUrl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item.localImage != null
                  ? Image.asset(item.localImage!, fit: BoxFit.cover)
                  : (item.imageUrl != null
                      ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Center(child: Icon(Icons.broken_image)),
                        )
                      : const Center(child: Icon(Icons.broken_image))),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(item.description,
                      style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('2 jam lalu',
                          style: TextStyle(color: Colors.grey[400])),
                      const Spacer(),
                      IconButton(
                        icon: Icon(item.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border),
                        color: item.isLiked ? Colors.red : Colors.grey,
                        onPressed: () => _toggleLike(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.blue),
                        onPressed: () => _shareArticle(item.articleUrl),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border,
                            color: Colors.amber),
                        onPressed: () => _saveArticle(item),
                      ),
                    ],
                  )
                ],
              ),
            )
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

class NewsSearchDelegate extends SearchDelegate {
  final List<NewsItem> allNews;
  NewsSearchDelegate({required this.allNews});

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(onPressed: () => close(context, null),
          icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    final results = allNews
        .where((item) =>
            item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: results
          .map((item) => ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
                onTap: () async {
                  final uri = Uri.parse(item.articleUrl);
                  if (await canLaunchUrl(uri)) launchUrl(uri);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}

class NewsPageContent {
  final String title;
  final List<NewsItem> newsItems;
  final IconData icon;
  NewsPageContent(
      {required this.title, required this.newsItems, required this.icon});
}

class NewsItem {
  final String title;
  final String description;
  final String? imageUrl;
  final String? localImage; // dukungan gambar lokal
  final String articleUrl;
  bool isLiked;
  NewsItem({
    required this.title,
    required this.description,
    this.imageUrl,
    this.localImage,
    required this.articleUrl,
    this.isLiked = false,
  });
}

