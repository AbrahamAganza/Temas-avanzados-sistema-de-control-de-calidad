import 'package:tads/core/network/json_service.dart';
import 'package:tads/core/routes.dart';
import 'package:tads/features/auth/data_sources/auth_local_data_source.dart';
import 'package:tads/features/auth/data_sources/auth_remote_data_source.dart';
import 'package:tads/features/auth/repositories/auth_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:tads/shared/theme/colors.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  static const String routeName = Routes.analyticsPage;

  @override
  State<AnalyticsPage> createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  final ScrollController _scrollController = ScrollController();
  AuthRepositoryImpl authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(JsonService()),
    localDataSource: AuthLocalDataSourceImpl(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),

      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aquí van las estadísticas o como se quieran manejar'),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: TADSColors.highlight,
      title: Text('Estadísticas'),
      centerTitle: false,
    );
  }
}
