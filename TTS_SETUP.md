# Руководство по настройке качественного TTS (Text-to-Speech)

## 🎯 Вариант 1: Встроенные голоса (РЕКОМЕНДУЕТСЯ - БЕСПЛАТНО)

### Для Android:
1. Откройте Play Store на устройстве
2. Найдите **"Google Text-to-Speech"** или **"Google Assistant"**
3. Установите/обновите приложение
4. Перейдите в **Настройки → Специальные возможности → Text-to-Speech**
5. Выберите **Google** как TTS Engine
6. Нажмите на иконку ⚙️ рядом с Google TTS
7. Загрузите голоса для **English (US)**

### Для iOS:
1. Перейдите **Параметры → Специальные возможности → Произношение**
2. iOS использует встроенные качественные голоса Apple
3. Голоса уже установлены по умолчанию

### Для Windows:
1. **Параметры → Специальные возможности → Речь**
2. Выберите нужный голос из списка
3. Windows имеет встроенные качественные голоса

---

## 💰 Вариант 2: Google Cloud Text-to-Speech API (ПЛАТНЫЙ, ЛУЧШЕЕ КАЧЕСТВО)

### Этапы настройки:

#### 1. Создайте проект Google Cloud
- Перейдите на https://console.cloud.google.com/
- Создайте новый проект
- Активируйте API: **Cloud Text-to-Speech API**

#### 2. Создайте Service Account
- **IAM & Admin → Service Accounts**
- Нажмите **Create Service Account**
- Установите роль: **Editor** или **Cloud Text-to-Speech API Editor**
- Создайте JSON ключ и скачайте его

#### 3. Поместите ключ в проект
```bash
mkdir assets/keys
# Поместите downloaded-key.json в assets/keys/
```

#### 4. Обновите pubspec.yaml
```yaml
assets:
  - assets/keys/
```

#### 5. Используйте в коде
```dart
// Пример использования Google Cloud TTS
// В flashcards_block.dart можно добавить:

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> _speakWithGoogleCloud(String text) async {
  final response = await http.post(
    Uri.parse('https://texttospeech.googleapis.com/v1/text:synthesize?key=YOUR_API_KEY'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'input': {'text': text},
      'voice': {
        'languageCode': 'en-US',
        'name': 'en-US-Neural2-C', // Качественный женский голос
        // Другие варианты: 'en-US-Neural2-A', 'en-US-Neural2-D', 'en-US-Neural2-E'
      },
      'audioConfig': {'audioEncoding': 'MP3'}
    }),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    final audioContent = result['audioContent'];
    
    // Воспроизведите audio с помощью audioplayers
    // await _audioPlayer.playBytes(base64Decode(audioContent));
  }
}
```

---

## 🔊 Доступные Google Cloud голоса для English (US):

**Женские голоса (Neural2):**
- `en-US-Neural2-C` - естественный, ясный ✨ РЕКОМЕНДУЕТСЯ
- `en-US-Neural2-E` - дружелюбный, теплый

**Мужские голоса (Neural2):**
- `en-US-Neural2-A` - профессиональный
- `en-US-Neural2-D` - молодой, современный

**Standard голоса (быстрее, но хуже качество):**
- `en-US-Standard-B` - женский
- `en-US-Standard-D` - мужской

---

## 📊 Сравнение вариантов:

| Характеристика | Встроенные TTS | Google Cloud API |
|---|---|---|
| **Стоимость** | 🟢 Бесплатно | 🟡 $16 за 1M символов |
| **Качество** | 🟡 Хорошее | 🟢 Отличное |
| **Скорость** | 🟢 Быстро | 🟡 Зависит от интернета |
| **Интернет** | 🟢 Не требует | 🟡 Требует |
| **Легкость** | 🟢 Просто | 🟡 Требует API ключ |

---

## ✅ ИТОГ:

**Для быстрого старта:** используйте встроенные TTS голоса (уже настроены в коде)

**Для максимального качества:** интегрируйте Google Cloud Text-to-Speech API
