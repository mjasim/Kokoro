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
        {'url': 'https://images.generated.photos/GSu8_sixsUgH4jB-mCj4z-f4y5Kwkm3tPkdM4GSATPE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1NzIzNjkuanBn.jpg'},
        {'url': 'https://images.generated.photos/t6Cwgn49rAce87kTyib4THNE5wjDRTVgqSf82z91Iu4/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA4Njc4NDAuanBn.jpg'},
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
    } else if (location == 'dallas') {
      return [
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
        {'url': 'https://images.generated.photos/LbjZ5w11UAJBQE8OS1_peMKAkknRVfKbriE1-9E5n64/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA2NDc5MTIuanBn.jpg'},
        {'url': 'https://images.generated.photos/yC8azgP1dFu2PxAnDAzWt98EyCjXacAD6kvuHzfDB6c/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAzMjIyMTcuanBn.jpg'},
      ];
    } else if (location == 'shanghai') {
      return [
        {'url': 'https://images.generated.photos/GD7AXDUDCok62AJZv8pm-T6hu9OIjHQXyqcc9yyTzBA/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/NjY1MjYuanBn.jpg'},
        {'url': 'https://images.generated.photos/yhjh3wuNMi0qXZ82a3o9_EeJwtnScXZoYA_8-hBQQNk/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAy/NTEzOTguanBn.jpg'},
        {'url': 'https://images.generated.photos/K-196TLEtosA2Ia5X2eJXUXojQzkZQV45PVp_cebSm0/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yy/XzA4NjczMzUuanBn.jpg'},
        {'url': 'https://images.generated.photos/rS6IAXuwJ5RUHnyLTrdG83Z5f7sqLU6-IEUyMXez51U/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAzOTE1NTYuanBn.jpg'},
      ];
    } else if (location == 'tokyo') {
      return [
        {'url': 'https://images.generated.photos/L5pDftmVrLSLV1UrocLeo0ruLwDueGw471aQL2nUtIo/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/Nzc3NzYuanBn.jpg'},
      ];
    } else if (location == 'sydney') {
      return [
        {'url': 'https://images.generated.photos/VEfde-5Trkasv2jViAs0VdPZwIFDgy2ratCTI-TgMwA/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3MjcyNTIuanBn.jpg'},
        {'url': 'https://images.generated.photos/2XDCc_OWQUeseL36yqdg_W2Z65O5bswsF-1s_sdb3Ys/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1OTA2OTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/6LklDWeevtcifFR2jIA-jlyWAyPM6yHTWvlC7WVrZ0Y/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1NDA4OTEuanBn.jpg'},
      ];
    } else if (location == 'los angeles') {
      return [
        {'url': 'https://images.generated.photos/yhjh3wuNMi0qXZ82a3o9_EeJwtnScXZoYA_8-hBQQNk/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAy/NTEzOTguanBn.jpg'},
        {'url': 'https://images.generated.photos/aYfFtlJ_qPgC_4yE8m7SqbWn0MQlnvAY6f-awNslSMY/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA0MjY5OTQuanBn.jpg'},
        {'url': 'https://images.generated.photos/BukLfFZY5lo0ELYQ4pgVYLYvZ62n6r_0t7cylj3-_Tc/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA0OTQ2MjMuanBn.jpg'},
      ];
    } else if (location == 'sao paulo') {
      return [
        {'url': 'https://images.generated.photos/nKM4vjwYnTfI9Ff83jpt-X-V2KQm_wIzIDJL6nMmKOY/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAwNzcxNzIuanBn.jpg'},
        {'url': 'https://images.generated.photos/qX0b3dlWjCUcP6AN_peBntJElkShhW4UFj2b_gmAzQA/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAzNTc5ODYuanBn.jpg'},
      ];
    } else if (location == 'mexico city') {
      return [
        {'url': 'https://images.generated.photos/GD7AXDUDCok62AJZv8pm-T6hu9OIjHQXyqcc9yyTzBA/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/NjY1MjYuanBn.jpg'},
        {'url': 'https://images.generated.photos/pJlczUCeqTDqkq62o1CnpA2EGtG-m_3WUuQzFyCLVkU/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA4MDc1MTYuanBn.jpg'},
      ];
    } else if (location == 'cairo') {
      return [
        {'url': 'https://images.generated.photos/cdfxoQOK0ADRdYaDjAsIXNyKBTGRMXH2rFptLS3yJfE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA4Mzg0MTAuanBn.jpg'},
        {'url': 'https://images.generated.photos/B1j3nv_rXJdYYvn8kqod8mInsTIZNkaDWff1uDxjTRI/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAwNTY1ODMuanBn.jpg'},
        {'url': 'https://images.generated.photos/lUQ-OKTXa75TTuDr7hKNDYZV1aihnZPpDNdUcjHAHFk/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA5OTgzOTcuanBn.jpg'},
      ];
    } else if (location == 'paris') {
      return [
        {'url': 'https://images.generated.photos/53dHPR2r9KP4PPiSuGoPaMKMPYN_13V2o8N9WXMiTtQ/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAxMTc2NDcuanBn.jpg'},
        {'url': 'https://images.generated.photos/2XDCc_OWQUeseL36yqdg_W2Z65O5bswsF-1s_sdb3Ys/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1OTA2OTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
        {'url': 'https://images.generated.photos/JN6F3U-CGqEbEM4Er2sIWmsgeLF6D2qoHVfmR9jj6gg/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA4NzQ5OTAuanBn.jpg'},
      ];
    } else if (location == 'berlin') {
      return [
        {'url': 'https://images.generated.photos/GD7AXDUDCok62AJZv8pm-T6hu9OIjHQXyqcc9yyTzBA/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/NjY1MjYuanBn.jpg'},
        {'url': 'https://images.generated.photos/2XDCc_OWQUeseL36yqdg_W2Z65O5bswsF-1s_sdb3Ys/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1OTA2OTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/n9l16k6K9z1GuDFdhH6lPbJJAnow9vkVtfeWi1s8Of8/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAwNTY4ODAuanBn.jpg'},
      ];
    } else if (location == 'lagos') {
      return [
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
        {'url': 'https://images.generated.photos/2XDCc_OWQUeseL36yqdg_W2Z65O5bswsF-1s_sdb3Ys/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1OTA2OTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/lUQ-OKTXa75TTuDr7hKNDYZV1aihnZPpDNdUcjHAHFk/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA5OTgzOTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/W1Jgje-SrRBHvVoM-ZvI1M-y0TCjDPrGfXJPPfXl5DE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA4NzgyNzQuanBn.jpg'},
      ];
    } else if (location == 'caracas') {
      return [
        {'url': 'https://images.generated.photos/cdfxoQOK0ADRdYaDjAsIXNyKBTGRMXH2rFptLS3yJfE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA4Mzg0MTAuanBn.jpg'},
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
        {'url': 'https://images.generated.photos/n3eb_5kuIS7WWCErDdmoCy9G8Pl7fkXpulYaQZWU6q0/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAxNzk0MTguanBn.jpg'},
        {'url': 'https://images.generated.photos/mWwMMSKX5x8aEFm3pIfFvBWltaJSmiCO1Yv1R_-n4jg/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zLzAx/NjM5MjQuanBn.jpg'},
        {'url': 'https://images.generated.photos/-exHS4E7Z8BNK7dG3TeqK1t00g0B2efVGMlh3stJ7wc/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yy/XzAzMTQ3NjcuanBn.jpg'},
      ];
    } else if (location == 'honolulu') {
      return [
        {'url': 'https://images.generated.photos/KClZhUhz6waX80tCPYKCO_pENnhoO9WKBMxXa2zomSE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAyMzMwODQuanBn.jpg'},
        {'url': 'https://images.generated.photos/lUQ-OKTXa75TTuDr7hKNDYZV1aihnZPpDNdUcjHAHFk/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA5OTgzOTcuanBn.jpg'},
      ];
    } else if (location == 'auckland') {
      return [
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
        {'url': 'https://images.generated.photos/vK0phkLowQ3Loz4D835TencKgrOLxijmyPnTBZlg--Y/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA5Mjk2NTIuanBn.jpg'},
      ];
    } else if (location == 'quito') {
      return [
        {'url': 'https://images.generated.photos/vi5HL6u4W9wwGq8YnVMFTxSB_okIaMNOPlO7SVrZeWc/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAxNDE1NDYuanBn.jpg'},
        {'url': 'https://images.generated.photos/Mts36P8Xdys15muC7nzyn1WK_6ZJTea1qWJJSzYjsqg/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAwNTQ2NDkuanBn.jpg'},
        {'url': 'https://images.generated.photos/94ZfbZ1nzmpw68HwU8hEC67POM18U_--GUzcNVL1PlY/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3MTE1NTYuanBn.jpg'},
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
      ];
    } else if (location == 'new delhi') {
      return [
        {'url': 'https://images.generated.photos/2XDCc_OWQUeseL36yqdg_W2Z65O5bswsF-1s_sdb3Ys/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1OTA2OTcuanBn.jpg'},
        {'url': 'https://images.generated.photos/vo27Tl8JtC5DCcOIYq5HZ-xnndBdJ_5nKs8Sg_P8rMw/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA2MjEyNzUuanBn.jpg'},
        {'url': 'https://images.generated.photos/S-fC6QLZLT6KeuFaxddRtz43NKkzg8idZlHrmu0cJjE/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA1ODMwMzkuanBn.jpg'},
        {'url': 'https://images.generated.photos/H8UMxDalFfe3ETD5-5ca9jFYam-ESRxWF1CY0M5ey6U/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA4MjAwODIuanBn.jpg'},
      ];
    } else if (location == 'carson city') {
      return [
        {'url': 'https://images.generated.photos/feo3j7loqVPrz_vWvY4xZrnhLb36Ocqt5cMufLVSqDI/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA5MTQ5NTcuanBn.jpg'},
      ];
    } else if (location == 'lima') {
      return [
        {'url': 'https://images.generated.photos/DEinUMVSJ2RYOPnbDGw4fEn1ImaEMzEpNzKNICBU9r4/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAwNTc5MzIuanBn.jpg'},
        {'url': 'https://images.generated.photos/fiPKvbbeHDkWzd2Hl3KtlHvaXjr1MyVxHNEOmLsDAlM/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA5NzM5ODAuanBn.jpg'},
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
