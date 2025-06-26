


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_mode_app/domain/cubits/theme_states.dart';

class ThemeCubits extends Cubit<ThemeStates>{
  ThemeCubits():super(LightThemeStates());


  toggletheme(){
    if(state is LightThemeStates){
      emit(DarkThemeStates());
    }
    else {
      emit(LightThemeStates());
    }
  }
}