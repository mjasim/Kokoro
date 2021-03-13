import 'package:stacked/stacked.dart';

class GlobalLocationItemViewModel extends BaseViewModel {
  bool isClicked = false;
  double zoom;

  void clicked(mapCallback) {
    isClicked = !isClicked;
    print('clicked${isClicked}, zoom:${zoom}');
    if(zoom < 5 && isClicked) {
      print('clicked Callback');
      mapCallback();
    }
    notifyListeners();
  }

  void setZoom(z) {
    zoom = z;
  }

  List<Map> getProfileData(location) {
    if (location == 'london') {
      return [
        {
          'url':
              'https://images.generated.photos/GSu8_sixsUgH4jB-mCj4z-f4y5Kwkm3tPkdM4GSATPE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1NzIzNjkuanBn.jpg'
        },
        {
          'url':
              'https://images.generated.photos/t6Cwgn49rAce87kTyib4THNE5wjDRTVgqSf82z91Iu4/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA4Njc4NDAuanBn.jpg'
        },
        {'url': 'https://images.generated.photos/cBPj2jwf01hckx8RPztNXMI1XVXgRNV5rxL4lTXlW5w/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/NzQ3NTguanBn.jpg'},
        {'url': 'https://images.generated.photos/n4UirWC7dJOJK9xvAEIB6VpAohLUKJ2gJA_UtIu7zK4/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yy/XzAzNDI3MDQuanBn.jpg'},
      ];
    } else if (location == 'new york') {
      return [
        {'url': 'https://images.generated.photos/GD7AXDUDCok62AJZv8pm-T6hu9OIjHQXyqcc9yyTzBA/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/NjY1MjYuanBn.jpg'},
        {'url': 'https://images.generated.photos/L5pDftmVrLSLV1UrocLeo0ruLwDueGw471aQL2nUtIo/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/Nzc3NzYuanBn.jpg'},
        {'url': 'https://images.generated.photos/mWwMMSKX5x8aEFm3pIfFvBWltaJSmiCO1Yv1R_-n4jg/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/NjM5MjQuanBn.jpg'},
        {'url': 'https://images.generated.photos/-exHS4E7Z8BNK7dG3TeqK1t00g0B2efVGMlh3stJ7wc/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yy/XzAzMTQ3NjcuanBn.jpg'},
        {'url': 'https://images.generated.photos/yhjh3wuNMi0qXZ82a3o9_EeJwtnScXZoYA_8-hBQQNk/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAy/NTEzOTguanBn.jpg'},
        {'url': 'https://images.generated.photos/K-196TLEtosA2Ia5X2eJXUXojQzkZQV45PVp_cebSm0/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yy/XzA4NjczMzUuanBn.jpg'},
        {'url': 'https://images.generated.photos/rS6IAXuwJ5RUHnyLTrdG83Z5f7sqLU6-IEUyMXez51U/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAzOTE1NTYuanBn.jpg'},
        {'url': 'https://images.generated.photos/vo27Tl8JtC5DCcOIYq5HZ-xnndBdJ_5nKs8Sg_P8rMw/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA2MjEyNzUuanBn.jpg'},
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
        {'url': 'https://images.generated.photos/2XDCc_OWQUeseL36yqdg_W2Z65O5bswsF-1s_sdb3Ys/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1OTA2OTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/lUQ-OKTXa75TTuDr7hKNDYZV1aihnZPpDNdUcjHAHFk/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA5OTgzOTcuanBn.jpg'},
      ];
    } else {
      return [
        {'url': 'https://images.generated.photos/rS6IAXuwJ5RUHnyLTrdG83Z5f7sqLU6-IEUyMXez51U/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAzOTE1NTYuanBn.jpg'},
        {'url': 'https://images.generated.photos/vo27Tl8JtC5DCcOIYq5HZ-xnndBdJ_5nKs8Sg_P8rMw/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA2MjEyNzUuanBn.jpg'},
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
        {'url': 'https://images.generated.photos/2XDCc_OWQUeseL36yqdg_W2Z65O5bswsF-1s_sdb3Ys/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1OTA2OTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/lUQ-OKTXa75TTuDr7hKNDYZV1aihnZPpDNdUcjHAHFk/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA5OTgzOTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/94ZfbZ1nzmpw68HwU8hEC67POM18U_--GUzcNVL1PlY/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3MTE1NTYuanBn.jpg'},
      ];
    }
  }
}
