# Onboarding Architecture

## Обзор
Система onboarding управляет потоком новых пользователей:
- **Первый запуск**: Показывает onboarding → регистрация/логин → приложение
- **Последующие запуски**: Прямой переход на логин → приложение

## Компоненты

### 1. OnboardingScreen (`lib/screens/onboarding_screen.dart`)
- **PageView** с 3 экранами (слайдами)
- Каждый экран раскрывает ценность приложения:
  1. 🎮 "Учи слова в игровой форме"
  2. 🎬 "Смотри видео в оригинале"
  3. 📈 "Отслеживай свой прогресс"

#### Особенности:
- **Анимация**: Масштабирование иконок, плавное появление текста
- **Page Indicator**: Скругленные индикаторы внизу с плавной анимацией
- **Кнопка "Начать"**: На последнем слайде, меняет текст "Далее" на "Начать"
- **Цветовые градиенты**: Каждый экран с уникальным цветом

### 2. Main.dart (обновлен)
```dart
// Проверка onboarding при старте приложения
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('onboarding_seen') ?? false;
  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}
```

#### Логика навигации:
- `hasSeenOnboarding = true` → `/login`
- `hasSeenOnboarding = false` → `/onboarding`

### 3. SharedPreferences
После завершения onboarding сохраняется флаг:
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('onboarding_seen', true);
```

## Дизайн

### Цветовая схема
- **Primary**: `#6C63FF` (фиолетовый) - основной цвет приложения
- **Secondary**: `#00C9A7` (зелёный), `#FFA502` (оранжевый) - для вариации экранов

### Стиль (Modern Clean Design)
- Белый фон
- Мягкие округлые углы (borderRadius: 14-20)
- Градиентные иконки в контейнерах
- Чистая типография (Roboto, fontWeight: w700-w800 для заголовков)
- Минимум визуального шума

## Flow Диаграмма
```
┌──────────────────┐
│   App Started    │
└────────┬─────────┘
         │
    ┌────▼─────┐
    │ Check     │
    │ onboarding│
    │ _seen flag│
    └─┬───────┬─┘
      │       │
   NO │       │ YES
      ▼       ▼
┌────────┐ ┌──────┐
│Onboarding│ │Login │
└────┬─────┘ └──────┘
     │           │
     ▼           ▼
  ┌──────┐  ┌──────┐
  │Login │  │Login │
  └──┬───┘  └──┬───┘
     │        │
     └────┬───┘
          ▼
       ┌──────┐
       │Home  │
       │(App) │
       └──────┘
```

## Использование

### Для пользователя:
1. Видит 3 слайда с информацией о приложении
2. Свайпает (или нажимает "Далее") между слайдами
3. На последнем слайде нажимает "Начать"
4. Автоматически переходит на экран логина
5. При следующих запусках видит только логин

### Для разработчика:
- Для тестирования первого запуска: удалить флаг `onboarding_seen` из SharedPreferences
- Экраны легко модифицировать в `onboarding_screen.dart` (массив `pages`)
- Анимации контролируются `AnimationController`
