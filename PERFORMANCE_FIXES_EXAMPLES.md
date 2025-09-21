# Performance Fix Examples - Ready to Implement

## 1. Fix Memory Leaks - TextEditingController Disposal

### ❌ Current Code (Memory Leak)
```dart
// lib/featurs/auth/register/widgets/register_form.dart
class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController countryKeyController = TextEditingController();
    // These controllers are NEVER disposed!
```

### ✅ Fixed Code (No Memory Leak)
```dart
// lib/features/auth/register/widgets/register_form.dart
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});
  
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passController;
  late final TextEditingController _phoneController;
  late final TextEditingController _countryKeyController;
  late final GlobalKey<FormState> _registerKey;
  
  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _phoneController = TextEditingController();
    _countryKeyController = TextEditingController(text: '+971');
    _registerKey = GlobalKey<FormState>();
  }
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _phoneController.dispose();
    _countryKeyController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerKey,
      // ... rest of the form
    );
  }
}
```

## 2. Fix Unnecessary Rebuilds

### ❌ Current Code (Excessive Rebuilds)
```dart
// lib/featurs/home_screen/home_screen.dart
BlocProvider(
  create: (context) => OpinionsCubit()..getOpinions(), // New instance every rebuild!
  child: BlocConsumer<OpinionsCubit, OpinionsState>(
    listener: (context, state) {},
    builder: (context, state) {
      return const OpinonBulider();
    },
  ),
),
```

### ✅ Fixed Code (Single Instance)
```dart
// lib/features/home/presentation/pages/home_screen.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OpinionsCubit()..getOpinions(),
        ),
        BlocProvider(
          create: (_) => BannersCubit()..getAllBanners(),
        ),
        BlocProvider(
          create: (_) => TeamsCubit()..getTeamMembers(),
        ),
      ],
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            _HomeHeader(),
            _BannersSection(),
            _IconsSection(),
            _ClinicsSection(),
            _OpinionsSection(), // Uses BlocBuilder internally
            _TeamsSection(),
          ],
        ),
      ),
    );
  }
}

class _OpinionsSection extends StatelessWidget {
  const _OpinionsSection();
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpinionsCubit, OpinionsState>(
      builder: (context, state) {
        if (state is GetOpinionsloading) {
          return const CircularProgressIndicator();
        }
        if (state is GetOpinionsSuccess) {
          return const OpinonBulider();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

## 3. Optimize List Rendering

### ❌ Current Code (Inefficient)
```dart
// lib/featurs/home_screen/opinions/all_opinions.dart
CarouselSlider(
  items: [
    for (int i = 0; i < cubit.listofOpinion.length; i++)
      CustomerOpinions(model: cubit.listofOpinion[i]), // All widgets created at once
  ],
  // ...
)
```

### ✅ Fixed Code (Optimized with Builder)
```dart
// lib/features/home/presentation/widgets/opinions_carousel.dart
class OpinionsCarousel extends StatefulWidget {
  final List<Opinion> opinions;
  
  const OpinionsCarousel({
    super.key,
    required this.opinions,
  });
  
  @override
  State<OpinionsCarousel> createState() => _OpinionsCarouselState();
}

class _OpinionsCarouselState extends State<OpinionsCarousel> {
  int _currentIndex = 0;
  late final PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.opinions.isEmpty) {
      return const AddYourOpinion();
    }
    
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.opinions.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CustomerOpinion(
                key: ValueKey(widget.opinions[index].id),
                model: widget.opinions[index],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.opinions.length,
          effect: ScrollingDotsEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            activeDotColor: AppColors.primary,
            dotColor: Colors.grey,
          ),
          onDotClicked: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}
```

## 4. Add Const Widgets

### ❌ Current Code (Non-const)
```dart
// Throughout the codebase
Container()
SizedBox(height: 10.h)
SizedBox(width: 5.w)
CircularProgressIndicator()
Text('Some text')
Icon(Icons.edit)
```

### ✅ Fixed Code (Const optimized)
```dart
// Create a constants file
// lib/core/constants/widget_constants.dart
class WidgetConstants {
  WidgetConstants._();
  
  // Spacing
  static const emptyWidget = SizedBox.shrink();
  static const vSpace5 = SizedBox(height: 5);
  static const vSpace10 = SizedBox(height: 10);
  static const vSpace15 = SizedBox(height: 15);
  static const vSpace20 = SizedBox(height: 20);
  
  static const hSpace5 = SizedBox(width: 5);
  static const hSpace10 = SizedBox(width: 10);
  static const hSpace15 = SizedBox(width: 15);
  static const hSpace20 = SizedBox(width: 20);
  
  // Loading
  static const loader = CircularProgressIndicator();
  static const smallLoader = SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(strokeWidth: 2),
  );
}

// Usage
import 'package:app/core/constants/widget_constants.dart';

// Instead of: Container()
WidgetConstants.emptyWidget

// Instead of: SizedBox(height: 10.h)
WidgetConstants.vSpace10

// Instead of: CircularProgressIndicator()
WidgetConstants.loader
```

## 5. Singleton API Client

### ❌ Current Code (Multiple Dio Instances)
```dart
// Every cubit creates its own Dio instance
class OpinionsCubit extends Cubit<OpinionsState> {
  Dio dio = Dio(); // New instance!
}

class BannersCubit extends Cubit<BannersState> {
  Dio dio = Dio(); // Another new instance!
}
```

### ✅ Fixed Code (Singleton Pattern)
```dart
// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio dio;
  
  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ));
    }
    
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthService().token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle token refresh or logout
            AuthService().logout();
          }
          handler.next(error);
        },
      ),
    );
  }
  
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }
  
  // Convenient methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) {
    return dio.get(path, queryParameters: queryParams);
  }
  
  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }
  
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParams}) {
    return dio.put(path, data: data, queryParameters: queryParams);
  }
  
  Future<Response> delete(String path, {Map<String, dynamic>? queryParams}) {
    return dio.delete(path, queryParameters: queryParams);
  }
}

// Usage in Cubits
class OpinionsCubit extends Cubit<OpinionsState> {
  final ApiClient _apiClient = ApiClient.instance; // Singleton!
  
  Future<void> getOpinions() async {
    emit(GetOpinionsloading());
    try {
      final response = await _apiClient.get(ApiEndpoints.opinions.getAll);
      // ... handle response
    } catch (e) {
      // ... handle error
    }
  }
}
```

## 6. Implement Caching

### ✅ Simple In-Memory Cache
```dart
// lib/core/cache/memory_cache.dart
class MemoryCache {
  static final MemoryCache _instance = MemoryCache._internal();
  factory MemoryCache() => _instance;
  MemoryCache._internal();
  
  final Map<String, CacheEntry> _cache = {};
  
  void set(String key, dynamic data, {Duration ttl = const Duration(minutes: 5)}) {
    _cache[key] = CacheEntry(
      data: data,
      expiry: DateTime.now().add(ttl),
    );
  }
  
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null || entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.data as T?;
  }
  
  void clear() {
    _cache.clear();
  }
  
  void remove(String key) {
    _cache.remove(key);
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime expiry;
  
  CacheEntry({required this.data, required this.expiry});
  
  bool get isExpired => DateTime.now().isAfter(expiry);
}

// Usage in Repository
class OpinionRepository {
  final ApiClient _apiClient = ApiClient.instance;
  final MemoryCache _cache = MemoryCache();
  
  Future<List<Opinion>> getOpinions({bool forceRefresh = false}) async {
    const cacheKey = 'opinions_list';
    
    if (!forceRefresh) {
      final cached = _cache.get<List<Opinion>>(cacheKey);
      if (cached != null) {
        return cached;
      }
    }
    
    final response = await _apiClient.get(ApiEndpoints.opinions.getAll);
    final opinions = (response.data as List)
        .map((json) => Opinion.fromJson(json))
        .toList();
    
    _cache.set(cacheKey, opinions);
    return opinions;
  }
}
```

## 7. Optimize Image Loading

### ✅ Optimized Image Widget
```dart
// lib/core/widgets/app_network_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;
  
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => errorWidget ?? 
        Icon(
          Icons.error_outline,
          size: width != null ? width! * 0.5 : 40,
          color: Colors.grey,
        ),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
    );
  }
}

// Usage
AppNetworkImage(
  imageUrl: '${ApiConstants.imageBaseUrl}${user.image}',
  width: 50.w,
  height: 50.w,
  errorWidget: const Icon(Icons.person),
)
```

## Implementation Checklist

- [ ] Fix all TextEditingController memory leaks (19 instances)
- [ ] Convert widgets with controllers to StatefulWidgets
- [ ] Add dispose() methods to all StatefulWidgets
- [ ] Replace Container() with SizedBox.shrink()
- [ ] Add const to all static widgets
- [ ] Implement singleton ApiClient
- [ ] Add memory caching for API responses
- [ ] Replace CarouselSlider with PageView.builder
- [ ] Add keys to all list items
- [ ] Optimize image loading with CachedNetworkImage
- [ ] Move BlocProviders to parent widgets
- [ ] Implement pagination for large lists
