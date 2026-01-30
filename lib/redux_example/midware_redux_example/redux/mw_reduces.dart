import 'package:state_manager/redux_example/midware_redux_example/redux/mw_actions.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/mw_app_state.dart';

MWAppState appReducer(MWAppState state, dynamic action) {
  if (action is ActionLogin) {
    return state.copyWith(loggedIn: true);
  } else if (action is ActionLogout) {
    return state.copyWith(loggedIn: false);
  } else if (action is ActionLikeRequest) {
    return state.copyWith(isLiking: true);
  } else if (action is ActionLikeSuccess) {
    return state.copyWith(isLiking: false, likeCount: state.likeCount + 1);
  } else if (action is ActionLikeFailed) {
    return state.copyWith(isLiking: false);
  }
  return state;
}
