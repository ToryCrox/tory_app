


abstract class IComponent {

}


class ComponentManager {


  T put<T>(T impl) {
    final type = T.runtimeType;

    return impl;
  }
}