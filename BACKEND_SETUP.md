# Backend Setup for OTP Email

## Option 1: Node.js Backend (Recommended)

### 1. Install Dependencies
```bash
npm init -y
npm install express nodemailer cors dotenv
```

### 2. Create server.js
```javascript
const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// Store OTPs (use Redis/Database in production)
const otpStore = new Map();

// Email configuration
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD
  }
});

// Send OTP endpoint
app.post('/api/auth/send-otp', async (req, res) => {
  try {
    const { email } = req.body;
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const expiryTime = Date.now() + 5 * 60 * 1000; // 5 minutes

    // Store OTP
    otpStore.set(email, { otp, expiryTime });

    // Send email
    await transporter.sendMail({
      from: 'SmartLink <noreply@smartlink.ng>',
      to: email,
      subject: 'Your SmartLink Verification Code',
      html: `
        <div style="font-family: Arial, sans-serif; padding: 20px;">
          <h2 style="color: #F88F3A;">SmartLink Email Verification</h2>
          <p>Your verification code is:</p>
          <h1 style="color: #F88F3A; font-size: 32px; letter-spacing: 5px;">${otp}</h1>
          <p>This code will expire in 5 minutes.</p>
          <p style="color: #666; font-size: 12px;">If you didn't request this code, please ignore this email.</p>
        </div>
      `
    });

    res.json({ success: true, message: 'OTP sent successfully' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ success: false, message: 'Failed to send OTP' });
  }
});

// Verify OTP endpoint
app.post('/api/auth/verify-otp', (req, res) => {
  try {
    const { email, otp } = req.body;
    const stored = otpStore.get(email);

    if (!stored) {
      return res.status(400).json({ success: false, message: 'OTP not found' });
    }

    if (Date.now() > stored.expiryTime) {
      otpStore.delete(email);
      return res.status(400).json({ success: false, message: 'OTP expired' });
    }

    if (stored.otp === otp) {
      otpStore.delete(email);
      return res.json({ success: true, message: 'OTP verified' });
    }

    res.status(400).json({ success: false, message: 'Invalid OTP' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ success: false, message: 'Verification failed' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

### 3. Create .env file
```
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password
PORT=3000
```

### 4. Get Gmail App Password
1. Go to Google Account settings
2. Enable 2-Factor Authentication
3. Go to Security > App passwords
4. Generate password for "Mail"
5. Use this password in .env

### 5. Run Server
```bash
node server.js
```

### 6. Update Flutter App
In `lib/services/otp_service.dart`, change:
```dart
static const String baseUrl = 'http://localhost:3000'; // For local testing
// OR
static const String baseUrl = 'https://your-domain.com'; // For production
```

---

## Option 2: Using Email Service APIs

### SendGrid (Recommended for Production)
```javascript
const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

await sgMail.send({
  to: email,
  from: 'noreply@smartlink.ng',
  subject: 'Your SmartLink Verification Code',
  html: `<h1>${otp}</h1>`
});
```

### Mailgun
```javascript
const mailgun = require('mailgun-js')({
  apiKey: process.env.MAILGUN_API_KEY,
  domain: process.env.MAILGUN_DOMAIN
});

await mailgun.messages().send({
  from: 'SmartLink <noreply@smartlink.ng>',
  to: email,
  subject: 'Your Verification Code',
  html: `<h1>${otp}</h1>`
});
```

---

## Option 3: Deploy Backend

### Deploy to Heroku
```bash
heroku create smartlink-api
git push heroku main
heroku config:set EMAIL_USER=your-email@gmail.com
heroku config:set EMAIL_PASSWORD=your-app-password
```

### Deploy to Railway
1. Connect GitHub repo
2. Add environment variables
3. Deploy automatically

### Deploy to Render
1. Create new Web Service
2. Connect repository
3. Add environment variables
4. Deploy

---

## Testing

### Test Send OTP
```bash
curl -X POST http://localhost:3000/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'
```

### Test Verify OTP
```bash
curl -X POST http://localhost:3000/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","otp":"123456"}'
```

---

## Security Best Practices

1. **Rate Limiting**: Limit OTP requests per email
2. **HTTPS Only**: Use SSL certificates
3. **Environment Variables**: Never commit credentials
4. **Database**: Store OTPs in Redis/MongoDB, not in-memory
5. **Logging**: Log all OTP attempts for security
6. **Validation**: Validate email format before sending

---

## Production Checklist

- [ ] Set up email service (Gmail/SendGrid/Mailgun)
- [ ] Deploy backend to cloud (Heroku/Railway/Render)
- [ ] Update baseUrl in Flutter app
- [ ] Add rate limiting
- [ ] Set up HTTPS
- [ ] Configure CORS properly
- [ ] Add error logging
- [ ] Test with real emails
