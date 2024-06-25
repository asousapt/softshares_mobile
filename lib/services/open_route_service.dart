import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_route_service/open_route_service.dart';

class RotasGeocodingService {
  final apiKey = dotenv.env['API_KEY_ORS'];

  final OpenRouteService client = OpenRouteService(apiKey: 'apiKey');
}
