const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
// Optional: load environment variables if using a .env file
try { require('dotenv').config(); } catch (_) {}

// Email transport
let nodemailer;
try { nodemailer = require('nodemailer'); } catch (_) { nodemailer = null; }

const app = express();

const PORT = process.env.PORT || 3001;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/server';
const JWT_SECRET = process.env.JWT_SECRET || 'SECRET_KEY';
// Defaults configured for Gmail sender you requested. Override via ENV in production.
const EMAIL_FROM = process.env.EMAIL_FROM || 'bolatulyolzhas@gmail.com';
const SMTP_HOST = process.env.SMTP_HOST || 'smtp.gmail.com';
const SMTP_PORT = Number(process.env.SMTP_PORT || 465);
const SMTP_USER = process.env.SMTP_USER || 'bolatulyolzhas@gmail.com';
const SMTP_PASS = process.env.SMTP_PASS || 'mcnq gvca nkso vtdg';
const NEWS_API_KEY = process.env.NEWS_API_KEY || '';
const NEWS_API_COUNTRY = process.env.NEWS_API_COUNTRY || 'us';
const NEWS_API_CATEGORY = process.env.NEWS_API_CATEGORY || 'general';
const NEWS_API_PAGE_SIZE = Number(process.env.NEWS_API_PAGE_SIZE || 10);

app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());

function estimateReadingMinutes(text) {
  const wordCount = (text.match(/\b[\w'-]+\b/g) || []).length;
  return Math.max(1, Math.round(wordCount / 180));
}

function buildNewsText(article) {
  const parts = [
    article.title,
    article.description,
    typeof article.content === 'string'
      ? article.content.replace(/\s*\[\+\d+\schars\]\s*$/i, '').trim()
      : '',
  ].filter(Boolean);

  return parts.join('\n\n').trim();
}

app.get('/reading/news', async (req, res) => {
  if (!NEWS_API_KEY) {
    return res.status(500).json({
      message: 'NEWS_API_KEY is not configured on the server.',
    });
  }

  try {
    const params = new URLSearchParams({
      country: (req.query.country || NEWS_API_COUNTRY).toString(),
      category: (req.query.category || NEWS_API_CATEGORY).toString(),
      pageSize: (req.query.pageSize || NEWS_API_PAGE_SIZE).toString(),
    });

    if (req.query.q) {
      params.set('q', req.query.q.toString());
    }

    const response = await fetch(`https://newsapi.org/v2/top-headlines?${params.toString()}`, {
      headers: {
        'X-Api-Key': NEWS_API_KEY,
      },
    });

    const payload = await response.json();
    if (!response.ok) {
      return res.status(response.status).json({
        message: payload.message || 'Failed to fetch news.',
      });
    }

    const items = Array.isArray(payload.articles)
      ? payload.articles
          .map((article, index) => {
            const text = buildNewsText(article);
            return {
              id: `${article.url || article.title || 'news'}_${index}`,
              title: article.title || 'Untitled',
              category: 'news',
              level: 'intermediate',
              author: article.author || article.source?.name || 'News source',
              sourceName: article.source?.name || '',
              minutes: estimateReadingMinutes(text),
              summary: article.description || 'No summary available.',
              content: text,
              imageUrl: article.urlToImage || '',
              publishedAt: article.publishedAt || '',
            };
          })
          .filter((article) => article.content)
      : [];

    return res.json({ items });
  } catch (err) {
    console.error('News fetch error:', err);
    return res.status(500).json({ message: 'Failed to fetch news.' });
  }
});

mongoose.connect(MONGO_URI)
  .then(() => {
    console.log('✅ Connected to MongoDB Atlas');
    app.listen(PORT, 'localhost', () => {
      console.log(`🚀 Backend server is running on http://localhost:${PORT}`);
    });
  })
  .catch(err => {
    console.error('❌ Failed to connect to MongoDB:', err.message);
    process.exit(1);
  });

const UserSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  level: { type: String },           
  learningFormat: { type: String },
  studyTime: { type: String },       
  isDailyStudy: { type: Boolean },   
  topics: { type: [String] },
  // Password reset fields
  resetCodeHash: { type: String },
  resetCodeExpires: { type: Date },
}, { timestamps: true });

const User = mongoose.model('User', UserSchema);


app.post('/register', async (req, res) => {
  try {
    const { name, email, password } = req.body;
    if (!email || !password || !name) {
      return res.status(400).json({ message: 'Please fill in all fields' });
    }

    const exists = await User.findOne({ email });
    if (exists) {
      return res.status(400).json({ message: 'Email is already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      name,
      email,
      password: hashedPassword,
    });

    await newUser.save();

    return res.json({ message: 'Registration successful' });
  } catch (err) {
    console.error('Register error:', err);
    if (err.code === 11000) {
      return res.status(400).json({ message: 'Email is already registered' });
    }
    return res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// Маршрут для сохранения предпочтений пользователя
app.post('/savePreferences', authMiddleware, async (req, res) => {
  try {
    const { level, learningFormat, studyTime, isDailyStudy, topics } = req.body;
    
    if (!level || !learningFormat || !studyTime || isDailyStudy == null || !topics) {
      return res.status(400).json({ message: 'Please provide all preferences' });
    }

    // Обновление данных пользователя
    const updatedUser = await User.findByIdAndUpdate(
      req.user.id, // Используем ID из токена
      { level, learningFormat, studyTime, isDailyStudy, topics },
      { new: true } // Возвращаем обновленный объект
    );

    if (!updatedUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    return res.json({ message: 'Preferences updated successfully' });
  } catch (err) {
    console.error('Error updating preferences:', err);
    return res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// Middleware для авторизации
function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).json({ message: 'Authorization header missing' });

  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') return res.status(401).json({ message: 'Invalid token format' });

  const token = parts[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    req.user = payload; // Добавляем информацию о пользователе в запрос
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
}

// Роут для получения профиля пользователя
app.get('/profile', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (!user) return res.status(404).json({ message: 'User not found' });
    return res.json({ user });
  } catch (err) {
    console.error('Profile error:', err);
    return res.status(500).json({ message: 'Server error' });
  }
});

app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: 'Please fill in all fields' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    // Генерируем токен
    const token = jwt.sign({ id: user._id }, JWT_SECRET, { expiresIn: '7d' });

    return res.json({
      message: 'Login successful',
      token,
      name: user.name,
      email: user.email,
    });
  } catch (err) {
    console.error('Login error:', err);
    return res.status(500).json({ message: 'Server error' });
  }
});

// Create mail transporter if nodemailer is available and configured
let mailer = null;
if (nodemailer && SMTP_HOST && SMTP_USER && SMTP_PASS) {
  mailer = nodemailer.createTransport({
    host: SMTP_HOST,
    port: SMTP_PORT,
    secure: SMTP_PORT === 465,
    auth: { user: SMTP_USER, pass: SMTP_PASS },
  });
}

// Request password reset code
app.post('/forgot-password', async (req, res) => {
  try {
    const { email } = req.body || {};
    if (!email) return res.status(400).json({ message: 'Email is required' });

    const user = await User.findOne({ email });
    // Always respond the same to avoid email enumeration
    const genericResponse = { message: 'If this email exists, we sent instructions' };
    if (!user) return res.json(genericResponse);

    // Generate 6-digit code and store its hash
    const code = (Math.floor(100000 + Math.random() * 900000)).toString();
    const hash = crypto.createHash('sha256').update(code).digest('hex');
    const expires = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes

    user.resetCodeHash = hash;
    user.resetCodeExpires = expires;
    await user.save();

    if (!mailer) {
      console.warn('Mailer not configured. Code for testing:', code);
      return res.json(genericResponse);
    }

    await mailer.sendMail({
      from: EMAIL_FROM,
      to: email,
      subject: 'Password reset code',
      text: `Ваш код для восстановления: ${code}\nДействует 15 минут.`,
    });

    return res.json(genericResponse);
  } catch (err) {
    console.error('Forgot password error:', err);
    return res.status(500).json({ message: 'Server error' });
  }
});

// Verify code and set new password
app.post('/reset-password', async (req, res) => {
  try {
    const { email, code, newPassword } = req.body || {};
    if (!email || !code || !newPassword) {
      return res.status(400).json({ message: 'Please provide email, code and newPassword' });
    }

    const user = await User.findOne({ email });
    if (!user || !user.resetCodeHash || !user.resetCodeExpires) {
      return res.status(400).json({ message: 'Invalid or expired code' });
    }

    if (user.resetCodeExpires.getTime() < Date.now()) {
      return res.status(400).json({ message: 'Invalid or expired code' });
    }

    const hash = crypto.createHash('sha256').update(code).digest('hex');
    if (hash !== user.resetCodeHash) {
      return res.status(400).json({ message: 'Invalid or expired code' });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    user.resetCodeHash = undefined;
    user.resetCodeExpires = undefined;
    await user.save();

    return res.json({ message: 'Password updated successfully' });
  } catch (err) {
    console.error('Reset password error:', err);
    return res.status(500).json({ message: 'Server error' });
  }
});
