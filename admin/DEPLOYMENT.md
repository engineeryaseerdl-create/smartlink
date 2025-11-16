# 🚀 SmartLink Admin - Deployment Guide

## Quick Deploy Options

### 1. Vercel (Recommended) ⚡

**Why Vercel?**
- Zero configuration
- Automatic HTTPS
- Global CDN
- Free tier available
- Built for Next.js

**Deploy in 2 Minutes:**

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
cd admin
vercel
```

**Or use GitHub:**
1. Push code to GitHub
2. Go to [vercel.com](https://vercel.com)
3. Click "Import Project"
4. Select your repo
5. Click "Deploy"

**Done!** Your dashboard is live! 🎉

### 2. Netlify 🌐

```bash
# Install Netlify CLI
npm i -g netlify-cli

# Login
netlify login

# Deploy
cd admin
netlify deploy --prod
```

### 3. AWS Amplify ☁️

```bash
# Install Amplify CLI
npm i -g @aws-amplify/cli

# Configure
amplify configure

# Deploy
amplify init
amplify add hosting
amplify publish
```

### 4. Docker 🐳

```dockerfile
# Dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/next.config.ts ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
CMD ["npm", "start"]
```

**Build and Run:**
```bash
docker build -t smartlink-admin .
docker run -p 3000:3000 smartlink-admin
```

### 5. Traditional Server (VPS) 🖥️

**Requirements:**
- Node.js 18+
- PM2 (process manager)
- Nginx (reverse proxy)

**Setup:**
```bash
# Install PM2
npm i -g pm2

# Build
npm run build

# Start with PM2
pm2 start npm --name "smartlink-admin" -- start

# Save PM2 config
pm2 save
pm2 startup
```

**Nginx Config:**
```nginx
server {
    listen 80;
    server_name admin.smartlink.ng;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Environment Variables

### Create `.env.local`

```bash
# App
NEXT_PUBLIC_APP_URL=https://admin.smartlink.ng
NEXT_PUBLIC_API_URL=https://api.smartlink.ng

# Analytics
NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX

# Feature Flags
NEXT_PUBLIC_ENABLE_ANALYTICS=true
NEXT_PUBLIC_ENABLE_NOTIFICATIONS=true
```

### Production Variables

```bash
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1
```

## Build Optimization

### 1. Analyze Bundle

```bash
# Install analyzer
npm i @next/bundle-analyzer

# Add to next.config.ts
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
})

module.exports = withBundleAnalyzer({
  // your config
})

# Run analysis
ANALYZE=true npm run build
```

### 2. Image Optimization

```typescript
// next.config.ts
module.exports = {
  images: {
    domains: ['your-cdn.com'],
    formats: ['image/avif', 'image/webp'],
  },
}
```

### 3. Compression

```bash
# Install compression
npm i compression

# Enable in production
```

## Performance Checklist

### Before Deploy
- [ ] Run `npm run build` successfully
- [ ] Test production build locally
- [ ] Check bundle size
- [ ] Optimize images
- [ ] Enable compression
- [ ] Set up CDN
- [ ] Configure caching
- [ ] Add error tracking

### After Deploy
- [ ] Test all pages
- [ ] Check mobile responsiveness
- [ ] Verify API connections
- [ ] Test dark/light mode
- [ ] Check loading times
- [ ] Monitor errors
- [ ] Set up analytics
- [ ] Configure backups

## Security Checklist

### Essential
- [ ] HTTPS enabled
- [ ] Environment variables secured
- [ ] API keys protected
- [ ] CORS configured
- [ ] Rate limiting enabled
- [ ] Input validation
- [ ] XSS protection
- [ ] CSRF tokens

### Headers
```typescript
// next.config.ts
module.exports = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
        ],
      },
    ]
  },
}
```

## Monitoring

### 1. Error Tracking

**Sentry:**
```bash
npm i @sentry/nextjs

# Initialize
npx @sentry/wizard -i nextjs
```

### 2. Analytics

**Google Analytics:**
```typescript
// Add to layout.tsx
import { GoogleAnalytics } from '@next/third-parties/google'

export default function RootLayout({ children }) {
  return (
    <html>
      <body>{children}</body>
      <GoogleAnalytics gaId="G-XXXXXXXXXX" />
    </html>
  )
}
```

### 3. Performance

**Vercel Analytics:**
```bash
npm i @vercel/analytics

# Add to layout.tsx
import { Analytics } from '@vercel/analytics/react'

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  )
}
```

## Custom Domain

### Vercel
1. Go to project settings
2. Click "Domains"
3. Add your domain
4. Update DNS records
5. Wait for SSL certificate

### DNS Records
```
Type: A
Name: admin
Value: 76.76.21.21 (Vercel IP)

Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

## CI/CD Pipeline

### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run build
      - run: npm run test
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
```

## Backup Strategy

### Database
```bash
# Daily backups
0 2 * * * /usr/bin/pg_dump smartlink > /backups/db-$(date +\%Y\%m\%d).sql
```

### Files
```bash
# Weekly backups
0 3 * * 0 tar -czf /backups/files-$(date +\%Y\%m\%d).tar.gz /var/www/smartlink
```

### Automated
- Use AWS S3 for storage
- Enable versioning
- Set lifecycle policies
- Test restore process

## Scaling

### Horizontal Scaling
- Use load balancer
- Multiple server instances
- Session management
- Database replication

### Vertical Scaling
- Upgrade server resources
- Optimize database
- Enable caching
- Use CDN

### Caching Strategy
```typescript
// next.config.ts
module.exports = {
  async headers() {
    return [
      {
        source: '/static/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ]
  },
}
```

## Troubleshooting

### Build Fails
```bash
# Clear cache
rm -rf .next node_modules
npm install
npm run build
```

### Slow Performance
- Check bundle size
- Optimize images
- Enable compression
- Use CDN
- Implement caching

### Memory Issues
```bash
# Increase Node memory
NODE_OPTIONS=--max_old_space_size=4096 npm run build
```

## Maintenance

### Regular Tasks
- [ ] Update dependencies monthly
- [ ] Review error logs weekly
- [ ] Check performance metrics
- [ ] Test backups quarterly
- [ ] Security audit annually
- [ ] Update documentation

### Updates
```bash
# Check outdated packages
npm outdated

# Update safely
npm update

# Major updates
npm i package@latest
```

## Support

### Resources
- 📖 [Next.js Docs](https://nextjs.org/docs)
- 🚀 [Vercel Docs](https://vercel.com/docs)
- 💬 [Discord Community](https://discord.gg/smartlink)
- 📧 [Email Support](mailto:admin@smartlink.ng)

### Emergency
- 🚨 Critical issues: Call +234-XXX-XXXX
- 📧 Non-urgent: admin@smartlink.ng
- 💬 Chat: https://smartlink.ng/support

---

**Built with ❤️ for SmartLink Nigeria**

*Deploy with confidence!* 🚀
