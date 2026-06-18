import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/features/client/search/data/models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultModel>> search(String query, {String type = 'all'});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  // The server has no `searchAll` endpoint (type=all throws server-side), so
  // the "all" tab is implemented client-side by firing one request per real
  // type (freelancer, service, work) in parallel and concatenating the
  // results. Each call degrades to [] on failure so one bad type doesn't sink
  // the whole merge.
  @override
  Future<List<SearchResultModel>> search(
    String query, {
    String type = 'all',
  }) async {
    if (type == 'all') {
      final results = await Future.wait([
        _searchOne(query, 'freelancer'),
        _searchOne(query, 'service'),
        _searchOne(query, 'work'),
      ]);
      // freelancers, then services, then works
      return [...results[0], ...results[1], ...results[2]];
    }
    return _searchOne(query, type);
  }

  /// Performs a single typed search request and tolerantly parses its body.
  /// Degrades to [] on any error.
  Future<List<SearchResultModel>> _searchOne(String query, String type) async {
    try {
      final response = await dioClient.get(
        ApiConstants.search,
        queryParameters: {'key': query, 'type': type},
      );

      if (response.statusCode != 200) return [];

      final body = response.data;
      final root = (body is Map) ? (body['data'] ?? body) : body;

      // Flat list of items of this type.
      if (root is List) {
        return root
            .whereType<Map>()
            .map(
              (e) => SearchResultModel.fromJson(
                Map<String, dynamic>.from(e),
                type: type,
              ),
            )
            .toList();
      }

      // Grouped map: pull each known group key with its own type.
      if (root is Map) {
        final results = <SearchResultModel>[];
        results.addAll(
          _mapGroup(root, const ['freelancers', 'freelancer', 'users'], 'freelancer'),
        );
        results.addAll(
          _mapGroup(
            root,
            const ['services', 'advertisements', 'service'],
            'service',
          ),
        );
        results.addAll(
          _mapGroup(
            root,
            const ['works', 'our_works', 'ourWorks', 'work'],
            'work',
          ),
        );
        return results;
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Reads the first present list under [keys] from [root] and maps each item
  /// to a model with the given [type].
  List<SearchResultModel> _mapGroup(
    Map root,
    List<String> keys,
    String type,
  ) {
    for (final key in keys) {
      final value = root[key];
      if (value is List) {
        return value
            .whereType<Map>()
            .map(
              (e) => SearchResultModel.fromJson(
                Map<String, dynamic>.from(e),
                type: type,
              ),
            )
            .toList();
      }
    }
    return [];
  }
}
