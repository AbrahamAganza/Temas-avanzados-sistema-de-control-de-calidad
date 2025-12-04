import 'package:tads/core/network/json_service.dart';

abstract class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final JsonService jsonService;

  DashboardRemoteDataSourceImpl(this.jsonService);

  @override
  Future<Map<String, dynamic>> getDashboardData() async {
    final data = await jsonService.get('assets/dashboard_data.json');
    return data as Map<String, dynamic>;
  }
}
