# Zenly - iOS App 结构

```
ios/
├── Zenly/
│   ├── App/
│   │   ├── ZenlyApp.swift          # App 入口
│   │   └── ContentView.swift       # 根视图
│   │
│   ├── Features/
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   ├── HomeViewModel.swift
│   │   │   └── Components/
│   │   │       ├── CheckInCard.swift
│   │   │       └── StressSlider.swift
│   │   │
│   │   ├── Chat/
│   │   │   ├── ChatView.swift
│   │   │   ├── ChatViewModel.swift
│   │   │   └── Components/
│   │   │       ├── MessageBubble.swift
│   │   │       └── ChatInput.swift
│   │   │
│   │   ├── Meditation/
│   │   │   ├── MeditationView.swift
│   │   │   ├── MeditationViewModel.swift
│   │   │   └── Components/
│   │   │       ├── MeditationCard.swift
│   │   │       └── PlayerView.swift
│   │   │
│   │   ├── Trends/
│   │   │   ├── TrendsView.swift
│   │   │   ├── TrendsViewModel.swift
│   │   │   └── Components/
│   │   │       ├── StressChart.swift
│   │   │       └── InsightCard.swift
│   │   │
│   │   └── Profile/
│   │       ├── ProfileView.swift
│   │       └── ProfileViewModel.swift
│   │
│   ├── Core/
│   │   ├── Theme/
│   │   │   ├── Colors.swift
│   │   │   ├── Typography.swift
│   │   │   └── Spacing.swift
│   │   │
│   │   ├── Services/
│   │   │   ├── FirebaseService.swift
│   │   │   ├── AIService.swift
│   │   │   └── SubscriptionService.swift
│   │   │
│   │   ├── Models/
│   │   │   ├── User.swift
│   │   │   ├── CheckIn.swift
│   │   │   ├── Conversation.swift
│   │   │   └── Message.swift
│   │   │
│   │   └── Extensions/
│   │       ├── View+Extensions.swift
│   │       └── Date+Extensions.swift
│   │
│   ├── Resources/
│   │   ├── Assets.xcassets/
│   │   └── MeditationAudio/
│   │
│   └── Preview Content/
│
├── Zenly.xcworkspace
├── Podfile (if needed)
└── project.yml
```

---

# Zenly - Android App 结构

```
android/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/zenly/
│   │       │   ├── ZenlyApp.kt
│   │       │   ├── MainActivity.kt
│   │       │   │
│   │       │   ├── features/
│   │       │   │   ├── home/
│   │       │   │   │   ├── HomeScreen.kt
│   │       │   │   │   └── HomeViewModel.kt
│   │       │   │   ├── chat/
│   │       │   │   │   ├── ChatScreen.kt
│   │       │   │   │   └── ChatViewModel.kt
│   │       │   │   ├── meditation/
│   │       │   │   │   ├── MeditationScreen.kt
│   │       │   │   │   └── MeditationViewModel.kt
│   │       │   │   ├── trends/
│   │       │   │   │   ├── TrendsScreen.kt
│   │       │   │   │   └── TrendsViewModel.kt
│   │       │   │   └── profile/
│   │       │   │       ├── ProfileScreen.kt
│   │       │   │       └── ProfileViewModel.kt
│   │       │   │
│   │       │   ├── theme/
│   │       │   │   ├── Color.kt
│   │       │   │   ├── Type.kt
│   │       │   │   └── Theme.kt
│   │       │   │
│   │       │   ├── service/
│   │       │   │   ├── FirebaseService.kt
│   │       │   │   ├── AIService.kt
│   │       │   │   └── SubscriptionService.kt
│   │       │   │
│   │       │   └── model/
│   │       │       ├── User.kt
│   │       │       ├── CheckIn.kt
│   │       │       └── Message.kt
│   │       │
│   │       └── res/
│   │           ├── values/
│   │           ├── drawable/
│   │           └── raw/  (meditation audio)
│   │
│   ├── build.gradle.kts
│   └── proguard-rules.pro
│
└── gradle/
```

---

# Zenly - 共享模块结构

```
shared/
├── build.gradle.kts
├── src/
│   └── commonMain/
│       ├── kotlin/
│       │   └── com/
│       │       └── zenly/
│       │           └── shared/
│       │               ├── model/
│       │               │   ├── User.kt
│       │               │   ├── CheckIn.kt
│       │               │   └── Message.kt
│       │               │
│       │               ├── repository/
│       │               │   ├── UserRepository.kt
│       │               │   └── CheckInRepository.kt
│       │               │
│       │               └── util/
│       │                   └── DateUtils.kt
│       │
│       └── appleMain/
│       └── androidMain/
│
└── src/
```

---

# API 端点 (Firebase Cloud Functions)

```
POST /ai/chat
- Body: { message: String, context: ConversationContext }
- Response: { reply: String }

POST /subscription/validate
- Body: { receipt: String, platform: "ios" | "android" }
- Response: { valid: Boolean, expiresAt: Date }

GET /user/{userId}
PUT /user/{userId}

GET /checkins/{userId}
POST /checkins
DELETE /checkins/{id}
```

---

# 设计资源

```
design/
├── figma/
│   ├── Zenly-Design.fig
│   └── Zenly-Components.fig
│
├── icons/
│   ├── app-icon/
│   │   ├── 1024.png
│   │   ├── 512.png
│   │   └── ...
│   │
│   └── tab-icons/
│       ├── home.svg
│       ├── chat.svg
│       ├── meditation.svg
│       ├── trends.svg
│       └── profile.svg
│
├── splash/
│   └── splash.png
│
└── mockups/
    └── devices/
```
