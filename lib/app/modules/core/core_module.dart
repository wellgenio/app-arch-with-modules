import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'client_http/dio/rest_client_dio_impl.dart';
import 'client_http/i_rest_client.dart';

List<SingleChildWidget> get coreModuleProviders {
  return [
    Provider(create: (context) => DioFactory.dio()),
    Provider(create: (context) => RestClientDioImpl(dio: context.read()) as IRestClient),
  ];
}