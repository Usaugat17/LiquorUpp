part of 'settings_cubit.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

// notification
class SettingStateNotificToggled extends SettingsState {}

class SettingStateNotifThresholdChanged extends SettingsState {}

// change password

class SettingStateChangePassword extends SettingsState {}

class SettingStatePasswordChanged extends SettingsState {}
