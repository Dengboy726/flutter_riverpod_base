import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'Flutter 企业级脚手架'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In zh, this message translates to:
  /// **'筛选'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get sort;

  /// No description provided for @refresh.
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @back.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get back;

  /// No description provided for @next.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In zh, this message translates to:
  /// **'上一步'**
  String get previous;

  /// No description provided for @finish.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get finish;

  /// No description provided for @skip.
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get skip;

  /// No description provided for @networkError.
  ///
  /// In zh, this message translates to:
  /// **'网络连接失败，请检查网络设置'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In zh, this message translates to:
  /// **'服务器错误，请稍后重试'**
  String get serverError;

  /// No description provided for @unknownError.
  ///
  /// In zh, this message translates to:
  /// **'未知错误，请稍后重试'**
  String get unknownError;

  /// No description provided for @timeoutError.
  ///
  /// In zh, this message translates to:
  /// **'请求超时，请检查网络连接'**
  String get timeoutError;

  /// No description provided for @unauthorizedError.
  ///
  /// In zh, this message translates to:
  /// **'登录已过期，请重新登录'**
  String get unauthorizedError;

  /// No description provided for @forbiddenError.
  ///
  /// In zh, this message translates to:
  /// **'没有权限访问此资源'**
  String get forbiddenError;

  /// No description provided for @notFoundError.
  ///
  /// In zh, this message translates to:
  /// **'请求的资源不存在'**
  String get notFoundError;

  /// No description provided for @validationError.
  ///
  /// In zh, this message translates to:
  /// **'输入信息有误，请检查后重试'**
  String get validationError;

  /// No description provided for @login.
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get login;

  /// No description provided for @register.
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In zh, this message translates to:
  /// **'邮箱'**
  String get email;

  /// No description provided for @password.
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In zh, this message translates to:
  /// **'确认密码'**
  String get confirmPassword;

  /// No description provided for @username.
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get username;

  /// No description provided for @phone.
  ///
  /// In zh, this message translates to:
  /// **'手机号'**
  String get phone;

  /// No description provided for @forgotPassword.
  ///
  /// In zh, this message translates to:
  /// **'忘记密码？'**
  String get forgotPassword;

  /// No description provided for @rememberMe.
  ///
  /// In zh, this message translates to:
  /// **'记住我'**
  String get rememberMe;

  /// No description provided for @loginSuccess.
  ///
  /// In zh, this message translates to:
  /// **'登录成功'**
  String get loginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In zh, this message translates to:
  /// **'注册成功'**
  String get registerSuccess;

  /// No description provided for @logoutSuccess.
  ///
  /// In zh, this message translates to:
  /// **'退出成功'**
  String get logoutSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In zh, this message translates to:
  /// **'登录失败'**
  String get loginFailed;

  /// No description provided for @registerFailed.
  ///
  /// In zh, this message translates to:
  /// **'注册失败'**
  String get registerFailed;

  /// No description provided for @createNewAccount.
  ///
  /// In zh, this message translates to:
  /// **'创建新账户'**
  String get createNewAccount;

  /// No description provided for @fillInfoToRegister.
  ///
  /// In zh, this message translates to:
  /// **'请填写以下信息完成注册'**
  String get fillInfoToRegister;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In zh, this message translates to:
  /// **'已有账户？'**
  String get alreadyHaveAccount;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In zh, this message translates to:
  /// **'请输入用户名'**
  String get pleaseEnterUsername;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In zh, this message translates to:
  /// **'请输入邮箱地址'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In zh, this message translates to:
  /// **'请输入密码'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseReEnterPassword.
  ///
  /// In zh, this message translates to:
  /// **'请再次输入密码'**
  String get pleaseReEnterPassword;

  /// No description provided for @firstName.
  ///
  /// In zh, this message translates to:
  /// **'名字'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In zh, this message translates to:
  /// **'姓氏'**
  String get lastName;

  /// No description provided for @pleaseEnterFirstName.
  ///
  /// In zh, this message translates to:
  /// **'请输入名字'**
  String get pleaseEnterFirstName;

  /// No description provided for @pleaseEnterLastName.
  ///
  /// In zh, this message translates to:
  /// **'请输入姓氏'**
  String get pleaseEnterLastName;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In zh, this message translates to:
  /// **'请输入手机号'**
  String get pleaseEnterPhone;

  /// No description provided for @emailRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入邮箱'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In zh, this message translates to:
  /// **'邮箱格式不正确'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入密码'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In zh, this message translates to:
  /// **'密码长度不能少于8位'**
  String get passwordTooShort;

  /// No description provided for @passwordTooLong.
  ///
  /// In zh, this message translates to:
  /// **'密码长度不能超过128位'**
  String get passwordTooLong;

  /// No description provided for @passwordMismatch.
  ///
  /// In zh, this message translates to:
  /// **'两次输入的密码不一致'**
  String get passwordMismatch;

  /// No description provided for @usernameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入用户名'**
  String get usernameRequired;

  /// No description provided for @usernameTooShort.
  ///
  /// In zh, this message translates to:
  /// **'用户名长度不能少于3位'**
  String get usernameTooShort;

  /// No description provided for @usernameTooLong.
  ///
  /// In zh, this message translates to:
  /// **'用户名长度不能超过50位'**
  String get usernameTooLong;

  /// No description provided for @phoneRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入手机号'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In zh, this message translates to:
  /// **'手机号格式不正确'**
  String get phoneInvalid;

  /// No description provided for @lightTheme.
  ///
  /// In zh, this message translates to:
  /// **'浅色主题'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In zh, this message translates to:
  /// **'深色主题'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get systemTheme;

  /// No description provided for @themeSettings.
  ///
  /// In zh, this message translates to:
  /// **'主题设置'**
  String get themeSettings;

  /// No description provided for @languageSettings.
  ///
  /// In zh, this message translates to:
  /// **'语言设置'**
  String get languageSettings;

  /// No description provided for @chinese.
  ///
  /// In zh, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @english.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @languageChanged.
  ///
  /// In zh, this message translates to:
  /// **'语言已切换'**
  String get languageChanged;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In zh, this message translates to:
  /// **'账户'**
  String get account;

  /// No description provided for @privacy.
  ///
  /// In zh, this message translates to:
  /// **'隐私'**
  String get privacy;

  /// No description provided for @about.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get about;

  /// No description provided for @version.
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get version;

  /// No description provided for @feedback.
  ///
  /// In zh, this message translates to:
  /// **'反馈'**
  String get feedback;

  /// No description provided for @help.
  ///
  /// In zh, this message translates to:
  /// **'帮助'**
  String get help;

  /// No description provided for @networkConnected.
  ///
  /// In zh, this message translates to:
  /// **'网络已连接'**
  String get networkConnected;

  /// No description provided for @networkDisconnected.
  ///
  /// In zh, this message translates to:
  /// **'网络已断开'**
  String get networkDisconnected;

  /// No description provided for @networkSlow.
  ///
  /// In zh, this message translates to:
  /// **'网络较慢，请稍后重试'**
  String get networkSlow;

  /// No description provided for @uploadSuccess.
  ///
  /// In zh, this message translates to:
  /// **'上传成功'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In zh, this message translates to:
  /// **'上传失败'**
  String get uploadFailed;

  /// No description provided for @downloadSuccess.
  ///
  /// In zh, this message translates to:
  /// **'下载成功'**
  String get downloadSuccess;

  /// No description provided for @downloadFailed.
  ///
  /// In zh, this message translates to:
  /// **'下载失败'**
  String get downloadFailed;

  /// No description provided for @fileNotFound.
  ///
  /// In zh, this message translates to:
  /// **'文件不存在'**
  String get fileNotFound;

  /// No description provided for @fileTooLarge.
  ///
  /// In zh, this message translates to:
  /// **'文件过大'**
  String get fileTooLarge;

  /// No description provided for @fileTypeNotSupported.
  ///
  /// In zh, this message translates to:
  /// **'文件类型不支持'**
  String get fileTypeNotSupported;

  /// No description provided for @pageNotFound.
  ///
  /// In zh, this message translates to:
  /// **'页面未找到'**
  String get pageNotFound;

  /// No description provided for @errorCode.
  ///
  /// In zh, this message translates to:
  /// **'错误代码'**
  String get errorCode;

  /// No description provided for @backToHome.
  ///
  /// In zh, this message translates to:
  /// **'返回首页'**
  String get backToHome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
