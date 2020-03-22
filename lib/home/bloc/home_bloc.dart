import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/api/category_client.dart';
import 'package:outfit_shop_client/api/offer_client.dart';
import 'package:outfit_shop_client/home/bloc/home_event.dart';
import 'package:outfit_shop_client/home/bloc/home_state.dart';

///BLoC для домашней страницы
class HomeBloc extends Bloc<HomeStateEvent, HomeState> {
  ///Исходное состояние BLoC.
  @override
  HomeState get initialState => HomeStateLoading();
  final OfferClient offerClient;
  final CategoryClient categoryClient;

  HomeBloc(this.offerClient, this.categoryClient);

  ///Привязка события к состояниям.
  @override
  Stream<HomeState> mapEventToState(HomeStateEvent event) async*{
    yield HomeStateLoading();
    try {
      final crossCategory = await categoryClient.getCategoryFromId(225);
      final crossOffers = await offerClient.getOffersByCategory(crossCategory);
      final pantCategory = await categoryClient.getCategoryFromId(991);
      final pantsOffers = await offerClient.getOffersByCategory(pantCategory);
      final jacketCategory = await categoryClient.getCategoryFromId(5871);
      final jacketsOffers = await offerClient.getOffersByCategory(
          jacketCategory);
      yield HomeStateSuccess(crossOffers: crossOffers,
          pantsOffers: pantsOffers,
          jacketsOffers: jacketsOffers);
    }catch(error){
      yield HomeStateError(error: error.message);
    }
  }

  ///Вывод изменения состояния.
  @override
  void onTransition(Transition<HomeStateEvent, HomeState> transition) {
    print(transition);
  }
}