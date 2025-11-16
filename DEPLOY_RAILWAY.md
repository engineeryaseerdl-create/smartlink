# Deploy OTP Backend to Railway (5 Minutes)

## Step 1: Create Backend Files

Create folder `smartlink-backend` with these files:

### package.json
```json
{
  "name": "smartlink-otp-api",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "nodemailer": "^6.9.7",
    "cors": "^2.8.5"
  }
}
```

### server.js
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
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

app.post('/api/auth/send-otp', async (req, res) => {
  try {
    const { email } = req.body;
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    otpStore.set(email, { otp, expiryTime: Date.now() + 300000 });

    await transporter.sendMail({
      from: 'SmartLink <noreply@smartlink.ng>',
      to: email,
      subject: 'SmartLink Verification Code',
      html: `
        <div style="font-family: Arial; padding: 20px;">
          <h2 style="color: #F88F3A;">SmartLink</h2>
          <p>Your verification code is:</p>
          <h1 style="color: #F88F3A; font-size: 36px;">${otp}</h1>
          <p>Expires in 5 minutes</p>
        </div>
      `
    });

    res.json({ success: true });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false });
  }
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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server on ${PORT}`));
```

## Step 2: Push to GitHub

```bash
cd smartlink-backend
git init
git add .
git commit -m "OTP backend"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/smartlink-backend.git
git push -u origin main
```

## Step 3: Deploy to Railway

1. Go to **https://railway.app**
2. Click **"Start a New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose **smartlink-backend** repository
5. Click **"Deploy Now"**

## Step 4: Add Environment Variables

In Railway dashboard:
1. Click **"Variables"** tab
2. Add these variables:
   - `EMAIL_USER` = your-email@gmail.com
   - `EMAIL_PASS` = your-gmail-app-password
3. Click **"Save"**

## Step 5: Get Your API URL

1. Click **"Settings"** tab
2. Click **"Generate Domain"**
3. Copy URL (e.g., `smartlink-otp.railway.app`)

## Step 6: Update Flutter App

In `lib/services/otp_service.dart`:
```dart
static const String baseUrl = 'https://smartlink-otp.railway.app';
```

## Done! 🎉

Your OTP backend is live and sending real emails!

---

## Test Your Deployment

```bash
curl -X POST https://smartlink-otp.railway.app/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"your-email@gmail.com"}'
```

Check your email for the OTP!

---

## Monitoring

Railway dashboard shows:
- ✅ Deployment status
- 📊 Request logs
- 💰 Usage metrics
- 🔄 Auto-redeploys on git push

---

## Cost

- **Free**: $5 credits/month (≈ 10,000 OTP emails)
- **Paid**: $5/month for unlimited

Perfect for SmartLink! 🚀
