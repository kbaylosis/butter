
class RouteConverter {

  static int routeToIndex(String route) {
    switch (route) {
        case '/home/functionA':
          return 1;
        case '/home/functionB':
          return 2;
        case '/home/newsfeed':
          return 0;
        default:
          return 3;
      }
  }

  static String indexToRoute(int index) {
    switch (index) {
      case 0:
        return '/home/newsfeed';
      case 1:
        return '/home/functionA';
      case 2:
        return '/home/functionB';
      default:
        return null;
    }
  }
}