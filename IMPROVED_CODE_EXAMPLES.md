# Improved Code Examples

## 1. Simplified Repository Implementation

### Before (Current Implementation in `opinions_cubit.dart`):
```dart
class OpinionsCubit extends Cubit<OpinionsState> {
  Dio dio = Dio();  // Direct Dio instance
  
  Future getOpinions() async {
    emit(GetOpinionsloading());
    await dio.get('${baseUrl}UserReview/GetAllReview').then((v) {
      if (v.statusCode == 200) {
        List<dynamic> data = v.data;
        List<Map<String, dynamic>> mapList = 
            List<Map<String, dynamic>>.from(data);
        listofOpinion = mapList.map((json) => Opinions.fromJson(json)).toList();
        emit(GetOpinionsSuccess(message: 'All Opinions Retrieved Successfully'));
      } else {
        emit(GetOpinionsFailed(message: 'Failed with status code: ${v.statusCode}'));
      }
    }).catchError((e) {
      emit(GetOpinionsFailed(message: 'Error: ${e.toString()}'));
      log('Error: $e');
    });
  }
}
```

### After (Clean Architecture):
```dart
// lib/features/opinions/data/datasources/opinion_remote_datasource.dart
abstract class OpinionRemoteDataSource {
  Future<List<OpinionModel>> getAllOpinions();
  Future<OpinionModel> addOpinion({required String title, required String description});
  Future<void> deleteOpinion(int id);
}

class OpinionRemoteDataSourceImpl implements OpinionRemoteDataSource {
  final ApiClient apiClient;
  
  OpinionRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<OpinionModel>> getAllOpinions() async {
    try {
      final response = await apiClient.get(ApiEndpoints.getAllOpinions);
      return (response.data as List)
          .map((json) => OpinionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch opinions');
    }
  }
  
  @override
  Future<OpinionModel> addOpinion({
    required String title, 
    required String description,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.addOpinion,
        data: {
          'Titel': title,
          'Description': description,
          'UsersId': await apiClient.getUserId(), // Get from secure storage
        },
      );
      return OpinionModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: 'Failed to add opinion');
    }
  }
}
```

## 2. Simplified State Management

### Before (Global Variables):
```dart
// lib/constants/cached_constants/cached_constants.dart
bool? lang;
bool? isArabic = false;
String? userID;
String? token;
String? name;
String? username;
bool? isAdmin;

// Usage anywhere in the app
if (isAdmin!) {
  // Show admin features
}
```

### After (Riverpod State Management):
```dart
// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    _loadStoredAuth();
    return const AuthState.initial();
  }
  
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    
    final result = await ref.read(loginUseCaseProvider).call(
      LoginParams(email: email, password: password),
    );
    
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) {
        _saveAuthData(user);
        state = AuthState.authenticated(user: user);
      },
    );
  }
  
  void logout() {
    _clearAuthData();
    state = const AuthState.unauthenticated();
  }
  
  Future<void> _loadStoredAuth() async {
    final user = await ref.read(authLocalDataSourceProvider).getStoredUser();
    if (user != null) {
      state = AuthState.authenticated(user: user);
    } else {
      state = const AuthState.unauthenticated();
    }
  }
}

// Usage in widgets
class AdminFeature extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return authState.maybeWhen(
      authenticated: (user) {
        if (user.isAdmin) {
          return AdminPanel();
        }
        return RegularUserView();
      },
      orElse: () => const LoginPrompt(),
    );
  }
}
```

## 3. Simplified Navigation

### Before (String-based routing):
```dart
// Navigation with string routes
Navigator.pushNamed(context, Routes.loginRoute);
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => EditOpinion(opinionModel: model),
  ),
);
```

### After (Type-safe AutoRoute):
```dart
// lib/core/router/app_router.dart
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: EditOpinionRoute.page),
  ];
}

// Usage in widgets
@RoutePage()
class LoginPage extends StatelessWidget {
  // ...
}

// Navigation
context.router.push(LoginRoute());
context.router.push(EditOpinionRoute(opinion: opinion));
```

## 4. Simplified Widget Structure

### Before (Complex nested widget):
```dart
class CustomTextFeild extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  String? hint;
  final bool isPassword;
  final IconData iconPre;
  final TextInputType type;
  bool? disabled = true;
  Function? fun;
  
  // 140+ lines of widget code with repeated border definitions
}
```

### After (Clean reusable widget):
```dart
// lib/core/widgets/app_text_field.dart
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint ?? label,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      style: theme.textTheme.bodyLarge,
    );
  }
}
```

## 5. Simplified API Client

### Before (DioHelper with static methods):
```dart
class DioHelper {
  static Dio? dio;
  
  static void init() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://petfinder-sub.ae.pet-finder.ae/api/',
      receiveDataWhenStatusError: true,
    ));
  }
  
  static Future<Response> post({
    required String url,
    FormData? data,
    Map<String, dynamic>? query,
  }) async {
    return await dio!.post(url, data: data, queryParameters: query);
  }
}
```

### After (Injectable API Client):
```dart
// lib/core/network/api_client.dart
@injectable
class ApiClient {
  final Dio _dio;
  final AuthLocalDataSource _authStorage;
  
  ApiClient(
    @Named('BaseUrl') String baseUrl,
    this._authStorage,
  ) : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle token refresh or logout
            _handleUnauthorized();
          }
          handler.next(error);
        },
      ),
    );
    
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }
  
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }
  
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters);
  }
}
```

## 6. Simplified Error Handling

### Before (Basic try-catch):
```dart
Future Register({required String fullName, ...}) async {
  emit(RegisterLoading());
  FormData formData = FormData.fromMap({...});
  
  await dio.post('$baseUrl$registerEndPoint', data: formData)
    .then((value) {
      if (value.statusCode == 200) {
        userModel = AuthUser.fromJson(value.data);
        if (userModel!.isAuthenticated!) {
          emit(RegisteSuccess(message: userModel!.message!));
        } else {
          emit(RegisterFailed(message: userModel!.message!));
        }
      }
    }).catchError((e) {
      log(e.toString());
      emit(RegisterFailed(message: 'Email or UserName is already registered'));
    });
}
```

### After (Clean error handling with Result type):
```dart
// lib/features/auth/domain/usecases/register_usecase.dart
class RegisterUseCase {
  final AuthRepository repository;
  
  RegisterUseCase(this.repository);
  
  Future<Either<Failure, User>> call(RegisterParams params) async {
    // Validation
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }
    
    if (!_isValidEmail(params.email)) {
      return const Left(ValidationFailure('Invalid email format'));
    }
    
    if (params.password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }
    
    // Execute registration
    return await repository.register(params);
  }
}

// Usage in Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    
    final result = await registerUseCase(RegisterParams(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
      // ... other params
    ));
    
    result.fold(
      (failure) => emit(AuthState.error(_getErrorMessage(failure))),
      (user) => emit(AuthState.authenticated(user)),
    );
  }
  
  String _getErrorMessage(Failure failure) {
    return failure.when(
      server: (msg) => msg,
      validation: (msg) => msg,
      network: () => 'Please check your internet connection',
      authentication: (msg) => msg,
      unknown: () => 'An unexpected error occurred. Please try again.',
    );
  }
}
```

## 7. Simplified Feature Module Structure

### Complete Feature Example - Opinions Module:

```dart
// lib/features/opinions/opinions_module.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/opinion_remote_datasource.dart';
import 'data/repositories/opinion_repository_impl.dart';
import 'domain/repositories/opinion_repository.dart';
import 'domain/usecases/get_opinions_usecase.dart';
import 'presentation/providers/opinions_provider.dart';

// Data Sources
final opinionRemoteDataSourceProvider = Provider<OpinionRemoteDataSource>((ref) {
  return OpinionRemoteDataSourceImpl(apiClient: ref.read(apiClientProvider));
});

// Repositories
final opinionRepositoryProvider = Provider<OpinionRepository>((ref) {
  return OpinionRepositoryImpl(
    remoteDataSource: ref.read(opinionRemoteDataSourceProvider),
  );
});

// Use Cases
final getOpinionsUseCaseProvider = Provider<GetOpinionsUseCase>((ref) {
  return GetOpinionsUseCase(ref.read(opinionRepositoryProvider));
});

// State Management
final opinionsProvider = StateNotifierProvider<OpinionsNotifier, OpinionsState>((ref) {
  return OpinionsNotifier(
    getOpinions: ref.read(getOpinionsUseCaseProvider),
    addOpinion: ref.read(addOpinionUseCaseProvider),
    deleteOpinion: ref.read(deleteOpinionUseCaseProvider),
  );
});
```

## 8. Main App Initialization

### Before:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  
  DioHelper.init();
  await cacheHelper.init();
  lang = cacheHelper.getData('lang') ?? false;
  await config.LoadLanguage(lang!);
  userID = cacheHelper.getData('userID');
  token = cacheHelper.getData('token');
  // ... many more global variables
  
  runApp(const AmnaApp());
}
```

### After:
```dart
// lib/main.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await configureDependencies();
  
  // Initialize screen utils
  await ScreenUtil.ensureScreenSize();
  
  runApp(
    ProviderScope(
      child: AmnaApp(),
    ),
  );
}

class AmnaApp extends ConsumerWidget {
  final _appRouter = AppRouter();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Amna App',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _appRouter.config(),
        );
      },
    );
  }
}
```

## Summary of Improvements

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Injection**: No more static methods or global variables
3. **Type Safety**: Compile-time checking for navigation and state
4. **Error Handling**: Consistent error handling across the app
5. **Testability**: Each component can be tested in isolation
6. **Maintainability**: Clear structure makes it easy to find and modify code
7. **Reusability**: Common widgets and utilities can be shared
8. **Performance**: Better state management reduces unnecessary rebuilds
