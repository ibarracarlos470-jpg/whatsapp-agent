# RENDER FRONTEND DEPLOYMENT GUIDE

## Status: READY FOR DEPLOYMENT

### Frontend Configuration
- **Service Name**: whatsapp-agent-frontend
- **Repository**: https://github.com/ibarracarlos470/whatsapp-agent
- **Branch**: main
- **Root Directory**: frontend
- **Build Command**: npm install && npm run build
- **Publish Directory**: dist
- **Framework**: React + Vite

## DEPLOYMENT METHOD 1: RENDER DASHBOARD (RECOMMENDED)

### Step 1: Connect to Render Dashboard
1. Go to: https://dashboard.render.com
2. Sign in with your account (agente)

### Step 2: Create Static Site
1. Click **"New +"** button
2. Select **"Static Site"**
3. Connect your GitHub repository:
   - Repository: `https://github.com/ibarracarlos470/whatsapp-agent`
   - Branch: `main`

### Step 3: Configure Build Settings
1. **Name**: `whatsapp-agent-frontend`
2. **Root Directory**: `frontend`
3. **Build Command**: `npm install && npm run build`
4. **Publish Directory**: `dist`
5. **Auto Deploy**: Enable

### Step 4: Create and Deploy
1. Click **"Create Static Site"**
2. Render will automatically:
   - Build the frontend
   - Deploy to production
   - Provide deployment URL

### Expected Result
- **Frontend URL**: https://whatsapp-agent-frontend.onrender.com
- **Build Time**: 2-5 minutes
- **Status**: Check dashboard for build logs

---

## DEPLOYMENT METHOD 2: RENDER API (AUTOMATIC)

### Prerequisites
- Render API Token: `rnd_KbJsvNw8JFPgPjU1rHGpGGhPZ8GF`
- GitHub repository must be public
- Owner ID: `tea-dbsjgve1egvs73e1sjk0`

### Script: deploy-frontend-render.ps1
PowerShell script for automated deployment via API.

**Usage:**
```powershell
cd C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent
.\deploy-frontend-render.ps1
```

### Current Status: API TROUBLESHOOTING NEEDED

**Issue**: Repository appears inaccessible to Render API
**Error**: "repository URL is invalid or unfetchable"

**Solutions**:
1. Verify repository is public
2. Verify GitHub repository URL is correct
3. Use dashboard method instead (Method 1 above)
4. Contact GitHub/Render support if persistent

---

## QUICK START: MANUAL DEPLOYMENT

If you prefer not to use scripts, follow these quick steps:

### 1. Prepare Frontend (Already Done)
```bash
cd C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent\frontend
npm install
npm run build
```

### 2. Push to GitHub
```bash
git add .
git commit -m "Prepare frontend for Render deployment"
git push origin main
```

### 3. Deploy on Render
1. Visit: https://dashboard.render.com
2. Click "New +" > "Static Site"
3. Select your repository
4. Fill in configuration:
   - Root Directory: `frontend`
   - Build Command: `npm install && npm run build`
   - Publish Directory: `dist`
5. Click "Create"

### 4. Monitor Deployment
- Check dashboard for build logs
- Deployment URL: https://whatsapp-agent-frontend.onrender.com
- Build typically completes in 2-5 minutes

---

## ENVIRONMENT VARIABLES

If you need to configure the frontend with backend URLs:

### Create .env in frontend directory
```env
VITE_API_URL=https://whatsapp-agent-backend.onrender.com
```

### Update vite.config.js if needed
```javascript
export default defineConfig({
  plugins: [react()],
  define: {
    'process.env.VITE_API_URL': JSON.stringify(process.env.VITE_API_URL)
  }
})
```

---

## TROUBLESHOOTING

### Build Fails
- Check build logs in dashboard
- Verify `npm install && npm run build` works locally
- Check for missing dependencies

### Repository Not Found
- Ensure repository is public
- Verify URL is correct
- Check GitHub access permissions

### Build Timeout
- Static sites have 45-minute build limit
- Optimize build process if exceeds
- Check for large dependencies

---

## NEXT STEPS

1. **Option A (Recommended)**: Use Render Dashboard (Method 1)
   - Simpler and more reliable
   - No API token management
   - Direct integration with GitHub

2. **Option B**: Use API once repo is accessible
   - Run: `.\deploy-frontend-render.ps1`
   - Fully automated

3. **Option C**: Manual Git Integration
   - Push code to GitHub
   - Deploy via Render dashboard
   - Monitor in real-time

---

## ENDPOINTS AFTER DEPLOYMENT

### Frontend
- URL: https://whatsapp-agent-frontend.onrender.com
- Status: Check dashboard

### Backend
- URL: https://whatsapp-agent-backend.onrender.com (if deployed)
- Update frontend .env with backend URL

---

## SUPPORT RESOURCES

- **Render Docs**: https://render.com/docs
- **Static Site Guide**: https://render.com/docs/static-sites
- **GitHub Integration**: https://render.com/docs/github
- **Build Environment**: https://render.com/docs/build-environment

---

Generated: 2026-11-15
Status: Ready for deployment
