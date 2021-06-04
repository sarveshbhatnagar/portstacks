import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/services/myportfolio_service.dart';

part 'myportfolio_event.dart';
part 'myportfolio_state.dart';

class MyportfolioBloc extends Bloc<MyportfolioEvent, MyportfolioState> {
  MyportfolioBloc() : super(MyportfolioInitial());

  MyPortfolioService service = MyPortfolioService();

  @override
  Stream<MyportfolioState> mapEventToState(
    MyportfolioEvent event,
  ) async* {
    if (event is MyportfolioFetchAll) {
      yield MyportfolioLoading();
      try {
        List<PortfolioModel> portfolios =
            await service.getPortfolios(event.userid);

        yield MyportfolioLoaded(portfolios: portfolios);
      } catch (e) {
        yield MyportfolioError(message: e.toString());
      }
    } else if (event is MyportfolioNew) {
      yield MyportfolioUploading(
          portfolio: event.portfolio, userid: event.userid);
      try {
        bool uploaded =
            await service.addPortfolio(event.userid, event.portfolio);
        if (uploaded) {
          yield MyportfolioUploaded();
        } else {
          yield MyportfolioError(message: "Some error occured while uploading");
        }
      } catch (e) {
        yield MyportfolioError(message: e.toString());
      }
    } else if (event is MyportfolioUpdate) {
      yield MyportfolioUploading(
          portfolio: event.portfolio, userid: event.userid);
      try {
        bool uploaded =
            await service.updatePortfolio(event.userid, event.portfolio);
        if (uploaded) {
          yield MyportfolioUploaded();
        } else {
          yield MyportfolioError(
              message: "Some error occured while updating your portfolio");
        }
      } catch (e) {
        yield MyportfolioError(message: e.toString());
      }
    } else if (event is MyportfolioDelete) {
      bool deleted =
          await service.deletePortfolio(event.userid, event.portfolioId);
      if (deleted) {
        event.portfolios
            .removeWhere((element) => element.id == event.portfolioId);
        yield MyportfolioLoaded(portfolios: event.portfolios);
      } else {
        yield MyportfolioError(message: "Unable to delete for some reason");
      }
    } else {
      yield MyportfolioError(message: "Invalid Event/Event not implemented");
    }
  }
}
