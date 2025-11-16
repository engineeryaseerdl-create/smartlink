# Quick Start: Real OTP Email in 5 Minutes

## Step 1: Create Backend Folder
```bash
mkdir smartlink-backend
cd smartlink-backend
npm init -y
npm install express nodemailer cors dotenv
```

## Step 2: Create server.js
Copy this code into `server.js`:

```javascript
const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');
const app = express();

app.use(express.json());
app.use(cors());

const otpStore = new Map();

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'YOUR_EMAIL@gmail.com',  // CHANGE THIS
    pass: 'YOUR_APP_PASSWORD'       // CHANGE THIS
  }
});

app.post('/api/auth/send-otp', async (req, res) => {
  const { email } = req.body;
  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  otpStore.set(email, { otp, expiryTime: Date.now() + 300000 });

  await transporter.sendMail({
    from: 'SmartLink <noreply@smartlink.ng>',
    to: email,
    subject: 'SmartLink Verification Code',
    html: `<h1>Your code: ${otp}</h1><p>Expires in 5 minutes</p>`
  });

  res.json({ success: true });
});

app.post('/api/auth/verify-otp', (req, res) => {
  const { email, otp } = req.body;
  const stored = otpStore.get(email);

  if (!stored || Date.now() > stored.expiryTime) {
    return res.status(400).json({ success: false });
  }

  if (stored.otp === otp) {
    otpStore.delete(email);
    return res.json({ success: true });
  }

  res.status(400).json({ success: false });
});

app.listen(3000, () => console.log('Server on port 3000'));
```

## Step 3: Get Gmail App Password
1. Go to https://myaccount.google.com/security
2. Enable 2-Step Verification
3. Search "App passwords"
4. Select "Mail" and "Other"
5. Copy the 16-character password
6. Paste in server.js

## Step 4: Run Backend
```bash
node server.js
```

## Step 5: Update Flutter App
In `lib/services/otp_service.dart`, line 7:
```dart
static const String baseUrl = 'http://localhost:3000';
```

## Step 6: Test
1. Run Flutter app
2. Enter your email
3. Click "Verify Email with OTP"
4. Check your email inbox
5. Enter the 6-digit code

## Done! 🎉

Your OTP system now sends real emails!

---

## For Production (Deploy Backend)

### Option A: Railway (Free)
1. Go to railway.app
2. Click "New Project" > "Deploy from GitHub"
3. Add environment variables
4. Get deployment URL
5. Update Flutter: `baseUrl = 'https://your-app.railway.app'`

### Option B: Render (Free)
1. Go to render.com
2. New > Web Service
3. Connect GitHub
4. Add environment variables
5. Update Flutter with deployment URL

### Option C: Heroku
```bash
heroku create smartlink-api
git push heroku main
```

---

## Troubleshooting

**Email not sending?**
- Check Gmail App Password is correct
- Enable "Less secure app access" (if needed)
- Check spam folder

**CORS error?**
- Backend has `app.use(cors())`
- Check backend is running

**Connection refused?**
- Backend running on port 3000?
- Use correct IP (localhost or deployment URL)
