# 🧸 **𝑳𝑶𝑮𝑰𝑵 𝑾𝑰𝑻𝑯 𝑨𝑵𝑰𝑴𝑨𝑻𝑰𝑶𝑵 – 𝑩𝑬𝑨𝑹 𝑬𝑫𝑰𝑻𝑰𝑶𝑵**

> ✨ A creative Flutter project made for the Computer Graphics course.

---

## 🎯 𝑷𝒓𝒐𝒋𝒆𝒄𝒕 𝑫𝒆𝒔𝒄𝒓𝒊𝒑𝒕𝒊𝒐𝒏

Login with Animation is an interactive Flutter app featuring an animated bear 🐻 that reacts to the user’s actions.  
When you type your email or password, the bear displays different emotions and movements, making the login screen feel fun, alive, and expressive 💫.

---

## 💡 𝑴𝒂𝒊𝒏 𝑭𝒖𝒏𝒄𝒕𝒊𝒐𝒏𝒂𝒍𝒊𝒕𝒊𝒆𝒔

🧠 The bear can:
- 👀 Look around while you type your email.  
- 🙈 Cover its eyes when typing your password.  
- 😄 Smile when the login is successful.  
- 😞 Look sad when the credentials are incorrect.  

All of this is powered by Rive animations, controlled through a State Machine Controller inside Flutter.

---

## 🎨 𝑾𝒉𝒂𝒕 𝒊𝒔 𝑹𝒊𝒗𝒆?

[Rive](https://rive.app) is a real-time interactive animation tool that allows developers to design, animate, and integrate vector graphics directly into apps and games.  
It blends art and code, enabling animations to respond dynamically to user interactions.

---

## ⚙️ 𝑾𝒉𝒂𝒕 𝒊𝒔 𝒂 𝑺𝒕𝒂𝒕𝒆 𝑴𝒂𝒄𝒉𝒊𝒏𝒆?

A State Machine in Rive is a system that defines how an animation reacts to certain inputs or conditions, such as typing, clicking, or gestures.  
In Flutter, it is controlled with logic like this:

```dart
StateMachineController controller;
SMIBool? isChecking;
SMIBool? isHandsUp;
SMIBool? trigSuccess;
SMIBool? trigFail;
SMINumber? numLook;
```
Each variable represents an emotional state or action of the bear 🐻 (for example: covering eyes, looking, smiling, or failing).

## 🧩 𝑻𝒆𝒄𝒉𝒏𝒐𝒍𝒐𝒈𝒊𝒆𝒔 𝑼𝒔𝒆𝒅
| 🔧 Technology               | 💬 Description                                  |
| --------------------------- | ----------------------------------------------- |
| 🧱 Flutter                  | Main framework for building the user interface. |
| 🎨 Rive                     | Tool for creating interactive 2D animations.    |
| ⚙️ Dart                     | Programming language that powers the app logic. |
| 💡 State Machine Controller | Manages transitions between animation states.   |

## 🗂️ 𝑩𝒂𝒔𝒊𝒄 𝑷𝒓𝒐𝒋𝒆𝒄𝒕 𝑺𝒕𝒓𝒖𝒄𝒕𝒖𝒓𝒆

A quick overview of the main files inside the lib/ folder:
```
lib/
│
├── main.dart               # Main entry point of the app
├── screens/
│   └── login_screen.dart   # Main screen with the animated bear
├── assets/
│   └── bear_login.riv      # Rive animation file
└── widgets/
    └── custom_input.dart   # Reusable text fields (email & password)
```

## 🎥 𝑫𝒆𝒎𝒐

🎬 Full demo showcasing the bear’s behavior:
- Reacting while typing
- Success and error login animations

<p align="center">
      💤 <strong>𝑰𝒏𝒊𝒕𝒊𝒂𝒍 𝒔𝒄𝒓𝒆𝒆𝒏</strong><br>
  <img src="assets/1.gif" width="400">
</p>

<p align="center">
      👀 <strong>𝑩𝒆𝒂𝒓 𝒍𝒐𝒐𝒌𝒔 𝒘𝒉𝒊𝒍𝒆 𝒕𝒚𝒑𝒊𝒏𝒈 𝒆𝒎𝒂𝒊𝒍</strong><br>
  <img src="assets/2.gif" width="400">
      🙈 <strong>𝑩𝒆𝒂𝒓 𝒄𝒐𝒗𝒆𝒓𝒔 𝒊𝒕𝒔 𝒆𝒚𝒆𝒔 𝒘𝒉𝒊𝒍𝒆 𝒕𝒚𝒑𝒊𝒏𝒈 𝒑𝒂𝒔𝒔𝒘𝒐𝒓𝒅</strong><br>
  <img src="assets/3.gif" width="400">
</p>

<p align="center">
      😄 <strong>𝑩𝒆𝒂𝒓 𝒔𝒎𝒊𝒍𝒆𝒔 𝒂𝒇𝒕𝒆𝒓 𝒔𝒖𝒄𝒄𝒆𝒔𝒔𝒇𝒖𝒍 𝒍𝒐𝒈𝒊𝒏</strong><br>
  <img src="assets/4.gif" width="400">
      😞 <strong>𝑩𝒆𝒂𝒓 𝒍𝒐𝒐𝒌𝒔 𝒔𝒂𝒅 𝒂𝒇𝒕𝒆𝒓 𝒇𝒂𝒊𝒍𝒆𝒅 𝒍𝒐𝒈𝒊𝒏</strong><br>
  <img src="assets/5.gif" width="400">
</p>


## 📚 𝑨𝒄𝒂𝒅𝒆𝒎𝒊𝒄 𝑰𝒏𝒇𝒐𝒓𝒎𝒂𝒕𝒊𝒐𝒏

🧮 Subject: Computer Graphics

🧑‍🏫 Professor: Rodrigo Fidel Gaxiola Sosa

🧑‍💻 Student: Odalys Margely Silva Colli

🏫 Institution: Instituto Tecnológico de Mérida

## 🖋️ 𝑪𝒓𝒆𝒅𝒊𝒕𝒔
🧸 Bear animation created by: [Bear Trial – Rive Marketplace](https://rive.app/marketplace/2735-5610-bear-trial/)

💻 Project developed for: Computer Graphics course, Instituto Tecnológico de Mérida
