# VeoUI

> A comprehensive, customizable, and production-ready SwiftUI components library designed for building modern applications with ease

![](https://img.shields.io/badge/license-Apache--2.0-blue)
![](https://img.shields.io/badge/version-0.9.1-green)

<div align="center">
    <img src="logo.png" width="300" height="300">
</div>

## Features

- 🎨 **40+ Pre-built Components**
- 📱 **Fully SwiftUI Native**
- 🔧 **Highly Customizable**
- ♿️ **Accessibility First**
- 🌍 **RTL Support**
- 📦 **Swift Package Manager**
- 🎯 **iOS 15+**

## Installation

### Swift Package Manager

Add VeoUI to your project through Xcode:

1. File > Add Package Dependencies...
2. Enter package URL: `https://github.com/VeoUI/VeoUISwift.git`
3. Select the version you want to use (Latest version is recommended)

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/VeoUI/VeoUISwift.git", from: "0.9.1")
]
```

## Example App

Check out the [Example](Example) directory for a fully functional demo app showcasing all components and features.

## Configuration

Before using VeoUI Library components, you need to configure it with your custom settings:

```swift
import SwiftUI
import VeoUI

@main
struct VeoUIApp: App {

    init() {
    VeoUI.configure(
            primaryColor: Color(hex: "#e74c3c"),
            primaryDarkColor: Color(hex: "#c0392b"),
            infoColor: Color(hex: "#2ecc71"),
            warningColor: Color(hex: "#f1c40f"),
            dangerColor: Color(hex: "#e74c3c"),
            isRTL: true,
            mainFont: "Rubik-Bold")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

## Usage

### Basic Example

```swift
import SwiftUI
import VeoUI

struct ContentView: View {
    var body: some View {

    VeoButton(title: "Custom Gradient + Shape",
              shape: .rounded,
              elevation: 4,
              gradientColors: (Color(hex: "#16a085"), Color(hex: "#2ecc71")),
              action: {
                print("Button tapped")
              })
    }
}
```

## Components

### Screens

#### VeoSplash

<table>
<thead>
<tr>
<th colspan="2">Code</th>
</tr>
</thead>
<tr>
<td colspan="2">

```swift
import SwiftUI
import VeoUI

struct SplashView: View {
    @State private var isSplash = true

    var body: some View {
        if isSplash {
            VeoSplash(
     title: "VeoUI App",
     appLogo: "logo")
     .onAppear {
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             isSplash = false
         }
     }
        } else {
            OnboardingView()
        }
    }
}
```
</td>
</tr>
<tr>
<th>Screenshot (LTR)</th>
<th>Screenshot (RTL)</th>
</tr>
<tr>
<td>
<img src="Screenshots/Screenshot1.png">
</td>
<td>
<img src="Screenshots/Screenshot2.png">
</td>
</tr>
</table>

#### VeoOnboarding

<table>
<thead>
<tr>
<th colspan="2">Code</th>
</tr>
</thead>
<tr>
<td colspan="2">

```swift
VeoOnboarding(
      items: [
      .init(
          title: "This is the first onboarding item title",
          description: "This is a long description for the first onboarding item to describe it in more detail!",
          image: "onboarding1"),
      .init(
          title: "This is the second onboarding item title",
          description: "This is a long description for the second onboarding item to describe it in more detail!",
          image: "onboarding2"),
      .init(
          title: "This is the third onboarding item title",
          description: "This is a long description for the third onboarding item to describe it in more detail!",
          image: "onboarding3"),
      .init(
          title: "This is the fourth onboarding item title",
          description: "This is a long description for the fourth onboarding item to describe it in more detail!",
          image: "onboarding4")
      ],
      skipButtonText: "Skip",
      nextButtonText: "Next",
      getStartedButtonText: "Start Now",
      onFinish: { })
```
</td>
</tr>
<tr>
<th>Screenshot (LTR)</th>
<th>Screenshot (RTL)</th>
</tr>
<tr>
<td>
<img src="Screenshots/Screenshot5.png">
</td>
<td>
<img src="Screenshots/Screenshot6.png">
</td>
</tr>
</table>

#### VeoLogin

<table>
<thead>
<tr>
<th colspan="2">Code</th>
</tr>
</thead>
<tr>
<td colspan="2">

```swift
VeoLogin(
     appName: "VeoUI App",
     appLogo: "logo",
     title: "Sign In",
     emailPlaceholder: "Your email",
     passwordPlaceholder: "Your Password",
     loginButtonTitle: "Login",
     forgotPasswordButtonTitle: "You forgot your password ?",
     dontHaveAccountButtonTitle: "You don't have an account ? Create one now !",
     showToast: true,
     pleaseFillInAllFieldsToastMessage: "Please fill in all fields !",
     onLoginTapped: { email, password in },
     onRegisterTapped: { },
     onForgotPasswordTapped: { },
     onLoginSuccess: { },
     onLoginError: { error in })
```
</td>
</tr>
<tr>
<th>Screenshot (LTR)</th>
<th>Screenshot (RTL)</th>
</tr>
<tr>
<td>
<img src="Screenshots/Screenshot3.png">
</td>
<td>
<img src="Screenshots/Screenshot4.png">
</td>
</tr>
</table>

#### VeoRegister

<table>
<thead>
<tr>
<th colspan="2">Code</th>
</tr>
</thead>
<tr>
<td colspan="2">

```swift
VeoRegister(
            appName: "App Name",
            appLogo: "logo",
            title: "Create Account",
            fullNamePlaceholder: "Full Name",
            emailPlaceholder: "Email",
            passwordPlaceholder: "Password",
            confirmPasswordPlaceholder: "Confirm Password",
            registerButtonTitle: "Register",
            alreadyHaveAccountButtonTitle: "Already have an account? Login now",
            showToast: true,
            pleaseFillInAllFieldsToastMessage: "Please fill in all required fields!",
            passwordsDontMatchMessage: "Passwords don't match!",
            onRegisterTapped: { fullName, email, password in },
            onLoginTapped: { },
            onRegisterSuccess: { },
            onRegisterError: { error in }
        )
        .navigationBarBackButtonHidden(true)
```
</td>
</tr>
<tr>
<th>Screenshot (LTR)</th>
<th>Screenshot (RTL)</th>
</tr>
<tr>
<td>
<img src="Screenshots/Screenshot7.png">
</td>
<td>
<img src="Screenshots/Screenshot8.png">
</td>
</tr>
</table>

#### VeoResetPassword

<table>
<thead>
<tr>
<th colspan="2">Code</th>
</tr>
</thead>
<tr>
<td colspan="2">

```swift
VeoResetPassword(
            appName: "App Name",
            appLogo: "logo",
            title: "Reset Password",
            subtitle: "Enter your email and we'll send you a password reset link",
            emailPlaceholder: "Email",
            resetButtonTitle: "Send Reset Link",
            backToLoginButtonTitle: "Back to Login",
            showToast: true,
            pleaseFillEmailMessage: "Please enter your email!",
            onResetTapped: { email in },
            onBackToLoginTapped: { },
            onResetSuccess: { },
            onResetError: { error in }
        )
        .navigationBarBackButtonHidden(true)
```
</td>
</tr>
<tr>
<th>Screenshot (LTR)</th>
<th>Screenshot (RTL)</th>
</tr>
<tr>
<td>
<img src="Screenshots/Screenshot9.png">
</td>
<td>
<img src="Screenshots/Screenshot10.png">
</td>
</tr>
</table>

### Data Display

#### VeoText

```swift
VeoText("Login", style: .subtitle, color: .white)
```

### Buttons

### VeoButton

```swift
VeoButton(title: "Rounded Button",
          style: .info,
          shape: .rounded,
          action: {
            print("Button tapped")
                })
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Support

For issues and feature requests, please file an issue on GitHub.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.