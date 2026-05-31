# Тестовое

Мобильное Flutter-приложение с paywall-онбордингом, стеклянным (glassmorphism) UI и тёмной темой.

---

## Архитектура

Приложение строится на трёх слоях:

```
UI (screens / widgets)
      ↓
State (Riverpod providers)
      ↓
Data (StorageService / SharedPreferences)
```

### Управление состоянием — Riverpod

| Provider | Тип | Отвечает за |
|---|---|---|
| `storageServiceProvider` | `Provider<StorageService>` | DI-контейнер, инжектируется через `ProviderScope` в `main.dart` |
| `subscriptionProvider` | `StateNotifierProvider<SubscriptionNotifier, bool>` | Статус подписки; читается из SharedPreferences при старте, пишется при покупке / сбросе |
| `routerProvider` | `Provider<GoRouter>` | Строит роутер с учётом текущего статуса подписки |

### Навигация — GoRouter

Маршрут при старте определяется состоянием подписки:

```
isSubscribed == false  →  /onboarding1 → /onboarding2 → /paywall → /home
isSubscribed == true   →  /home
```

Переходы между экранами — кастомная анимация: слайд снизу + fade-in + лёгкое масштабирование предыдущего экрана (iOS-стиль sheet).

### Персистентность

`StorageService` — тонкая обёртка над `SharedPreferences`. Единственный ключ — `is_subscribed`. Инициализируется синхронно до `runApp`, чтобы роутер мог сразу выбрать начальный экран.

---

## Структура проекта

```
lib/
├── main.dart                        # Точка входа; инит SharedPreferences, ProviderScope
│
├── constants.dart                   # Barrel-экспорт всех конфигов и темы
│
├── theme/
│   ├── app_colors.dart              # Все цвета приложения
│   ├── app_gradients.dart           # Линейные градиенты (primary, warm, teal, cool, greetingCard)
│   └── app_dimensions.dart          # Отступы, радиусы, высоты
│
├── config/
│   ├── app_strings.dart             # Все строки UI (тексты, лейблы, ключи)
│   ├── app_routes.dart              # Пути маршрутов
│   └── app_content.dart             # Контентные данные: списки фич, категорий, popular-items
│
├── router/
│   └── app_router.dart              # GoRouter + кастомные page transitions
│
├── providers/
│   └── subscription_provider.dart   # SubscriptionNotifier + storageServiceProvider
│
├── services/
│   └── storage_service.dart         # Обёртка SharedPreferences
│
├── screens/
│   ├── onboarding/
│   │   ├── onboarding_screen_1.dart # Экран 1: приветствие
│   │   └── onboarding_screen_2.dart # Экран 2: ценностное предложение
│   ├── paywall/
│   │   └── paywall_screen.dart      # Выбор плана, оформление подписки
│   └── home/
│       └── home_screen.dart         # 3 вкладки: Главная, Каталог, Профиль
│
├── widgets/
│   ├── glass_card.dart              # Переиспользуемая стеклянная карточка
│   ├── primary_button.dart          # Кнопка с анимацией нажатия (scale)
│   ├── subscription_card.dart       # Карточка тарифного плана
│   └── animated_entrance.dart       # Fade + slide при появлении виджета
│
└── assets/
    ├── image.png                    # Изображение категории 1
    ├── image1.png                   # Изображение категории 2
    ├── image2.png                   # Изображение категории 3
    └── image3.png                   # Изображение категории 4
```

---

## Запуск

```bash
flutter pub get
flutter run
```

Требования: Flutter SDK ≥ 3.10, Dart SDK ≥ 3.0.

---

## Что улучшил бы при большем времени

### Архитектура и код

- **Реальная покупка** — интеграция `revenue_cat` или `in_app_purchase`; сейчас подписка имитируется булевым флагом в SharedPreferences.
- **Слой доменных моделей** — выделить сущности (`Plan`, `Category`, `ContentItem`) вместо анонимных Record-типов `(IconData, String, Color)` в `AppContent`. С моделями проще добавлять поля, тестировать и документировать.
- **Репозиторий** — добавить `SubscriptionRepository` между `StorageService` и провайдером, чтобы источник данных можно было легко подменить (API, RevenueCat и т.д.).
- **Обработка ошибок** — `subscribe()`/`unsubscribe()` сейчас не обрабатывают исключения; нужны `AsyncNotifier` + UI-индикатор ошибки.

### Тесты

- **Unit-тесты** для `SubscriptionNotifier` и `StorageService`.
- **Widget-тесты** для `GlassCard`, `PrimaryButton`, `SubscriptionCard`.
- **Golden-тесты** для онбординга и пейвола — защита от регрессий UI.

### UX и UI

- **Локализация** — строки уже вынесены в `AppStrings`, следующий шаг — `flutter_localizations` + `intl` для поддержки нескольких языков.
- **Тема** — подключить `ThemeData` через `MaterialApp` полноценно, чтобы цвета из `AppColors` работали через `Theme.of(context)`, а не хардкодились в стилях.
- **Доступность** — добавить `Semantics` к кнопкам и интерактивным элементам, поддержку динамического размера шрифта.
- **Skeleton-загрузка** — shimmer-заглушки на местах контента вместо пустого экрана.

### DevOps

- **CI/CD** — GitHub Actions: `flutter analyze`, `flutter test`, сборка APK/IPA по тегу.
- **Crashlytics** — сбор ошибок в проде.
- **Feature flags** — управление контентом и тарифами без релиза приложения.
