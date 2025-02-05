import 'dart:convert';

import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/common_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/confirm_code_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/login_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/logout_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/password_confirm_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/password_forget_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/resend_code_response.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/api-request.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      String? email, String password, String loginBy) async {
    var post_body = jsonEncode({
      "email": "$email",
      "password": "$password",
      "identity_matrix": AppConfig.purchase_code,
      "login_by": loginBy,
      "temp_user_id": temp_user_id.$
    });

    String url = ("${AppConfig.BASE_URL}/auth/login");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Accept": "*/*",
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return loginResponseFromJson(response.body);
      } else {
        throw Exception("Failed to login. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getLoginResponse: $e");
      rethrow;
    }
  }

  Future<LoginResponse> verifyOtp(String phone, String otp) async {
    var post_body = jsonEncode({
      "phone": "$phone",
      "otp": "$otp",
      "identity_matrix": AppConfig.purchase_code,
      "temp_user_id": temp_user_id.$
    });

    String url = ("${AppConfig.BASE_URL}/auth/verify-otp");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Accept": "*/*",
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return loginResponseFromJson(response.body);
      } else {
        throw Exception("Failed to verify OTP. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in verifyOtp: $e");
      rethrow;
    }
  }

  Future<LoginResponse> getSocialLoginResponse(
      String social_provider,
      String? name,
      String? email,
      String? provider, {
        access_token = "",
        secret_token = "",
      }) async {
    email = email == ("null") ? "" : email;

    var post_body = jsonEncode({
      "name": name,
      "email": email,
      "provider": "$provider",
      "social_provider": "$social_provider",
      "access_token": "$access_token",
      "secret_token": "$secret_token"
    });

    String url = ("${AppConfig.BASE_URL}/auth/social-login");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return loginResponseFromJson(response.body);
      } else {
        throw Exception("Failed to social login. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getSocialLoginResponse: $e");
      rethrow;
    }
  }

  Future<LogoutResponse> getLogoutResponse() async {
    String url = ("${AppConfig.BASE_URL}/auth/logout");
    try {
      print("Sending GET request to: $url");

      final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return logoutResponseFromJson(response.body);
      } else {
        throw Exception("Failed to logout. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getLogoutResponse: $e");
      rethrow;
    }
  }

  Future<CommonResponse> getAccountDeleteResponse() async {
    String url = ("${AppConfig.BASE_URL}/auth/account-deletion");
    try {
      print("Sending GET request to: $url");

      final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return commonResponseFromJson(response.body);
      } else {
        throw Exception("Failed to delete account. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getAccountDeleteResponse: $e");
      rethrow;
    }
  }

  Future<LoginResponse> getSignupResponse(
      String name,
      String? email_or_phone,
      String password,
      String password_confirmation,
      String register_by,
      String captchaKey,
      ) async {
    var post_body = jsonEncode({
      "name": "$name",
      "email_or_phone": "$email_or_phone",
      "password": "$password",
      "password_confirmation": "$password_confirmation",
      "register_by": "$register_by",
      "g-recaptcha-response": "$captchaKey",
    });

    String url = ("${AppConfig.BASE_URL}/auth/signup");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return loginResponseFromJson(response.body);
      } else {
        throw Exception("Failed to signup. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getSignupResponse: $e");
      rethrow;
    }
  }

  Future<ResendCodeResponse> getResendCodeResponse() async {
    String url = ("${AppConfig.BASE_URL}/auth/resend_code");
    try {
      print("Sending GET request to: $url");

      final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
          "Authorization": "Bearer ${access_token.$}",
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return resendCodeResponseFromJson(response.body);
      } else {
        throw Exception("Failed to resend code. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getResendCodeResponse: $e");
      rethrow;
    }
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      String verification_code) async {
    var post_body = jsonEncode({"verification_code": "$verification_code"});

    String url = ("${AppConfig.BASE_URL}/auth/confirm_code");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
            "Authorization": "Bearer ${access_token.$}",
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return confirmCodeResponseFromJson(response.body);
      } else {
        throw Exception("Failed to confirm code. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getConfirmCodeResponse: $e");
      rethrow;
    }
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      String? email_or_phone, String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    String url = ("${AppConfig.BASE_URL}/auth/password/forget_request");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return passwordForgetResponseFromJson(response.body);
      } else {
        throw Exception("Failed to forget password. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getPasswordForgetResponse: $e");
      rethrow;
    }
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      String verification_code, String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    String url = ("${AppConfig.BASE_URL}/auth/password/confirm_reset");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return passwordConfirmResponseFromJson(response.body);
      } else {
        throw Exception("Failed to confirm password reset. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getPasswordConfirmResponse: $e");
      rethrow;
    }
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      String? email_or_code, String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    String url = ("${AppConfig.BASE_URL}/auth/password/resend_code");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return resendCodeResponseFromJson(response.body);
      } else {
        throw Exception("Failed to resend password reset code. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in getPasswordResendCodeResponse: $e");
      rethrow;
    }
  }

  Future<LoginResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});

    String url = ("${AppConfig.BASE_URL}/auth/info");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      if (access_token.$!.isNotEmpty) {
        final response = await ApiRequest.post(
            url: url,
            headers: {
              "Content-Type": "application/json",
              "App-Language": app_language.$!,
            },
            body: post_body);

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          return loginResponseFromJson(response.body);
        } else {
          throw Exception("Failed to get user by token. Error: ${response.body}");
        }
      }
      return LoginResponse();
    } catch (e) {
      print("Error in getUserByTokenResponse: $e");
      rethrow;
    }
  }

  Future<LoginResponse> sendOtp(String phone) async {
    var post_body = jsonEncode({
      "phone": "$phone",
    });

    String url = ("${AppConfig.BASE_URL}/auth/send-otp");
    try {
      print("Sending POST request to: $url");
      print("Request body: $post_body");

      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Accept": "*/*",
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return loginResponseFromJson(response.body);
      } else {
        throw Exception("Failed to send OTP. Error: ${response.body}");
      }
    } catch (e) {
      print("Error in sendOtp: $e");
      rethrow;
    }
  }
}