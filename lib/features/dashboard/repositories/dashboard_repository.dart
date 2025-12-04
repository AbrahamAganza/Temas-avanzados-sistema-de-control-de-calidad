import 'package:tads/features/dashboard/data_sources/dashboard_remote_data_source.dart';

abstract class DashboardRepository {
  Future<Map<String, dynamic>> getDashboardData();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getDashboardData() async {
    return await remoteDataSource.getDashboardData();
  }
}
