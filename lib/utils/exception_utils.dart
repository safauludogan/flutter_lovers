class ExceptionUtils {
  static String showException(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Bu mail adresi zaten kullanımda, lütfen giriş yapınız';
        case 'user-not-found':
        return 'Bu mail adresine ait bir kullanıcı bulunamadı, lütfen tekrar deneyiniz';
      default:
        return 'Bir hata oluştur';
    }
  }
}
