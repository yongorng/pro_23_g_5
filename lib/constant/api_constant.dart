/// Every URL the app talks to, in one place.
///
/// The app uses the shared HTTPS backend so the same APK works on real phones.
class ApiConstant {
  const ApiConstant._();

  static const String baseUrl = 'https://flutter-api.janrent.com';

  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  static const String users = '/api/users';
  static const String currentUser = '/api/users/me';

  static String userById(int id) => '/api/users/$id';
  static String userEnabled(int id) => '/api/users/$id/enabled';
  static String userImage(int id) => '/api/users/$id/image';

  static const String posts = '/api/posts';
  static String postById(int id) => '/api/posts/$id';
  static String postImage(int id) => '/api/posts/$id/image';

  static const String sliders = '/api/sliders';
  static const String slidersManage = '/api/sliders/manage';

  static String fileUrl(String imagePath) => '$baseUrl$imagePath';

  static String sseSubscribe(String token) =>
      '$baseUrl/api/sse/subscribe?access_token=$token';
}
