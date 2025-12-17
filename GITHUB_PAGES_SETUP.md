# GitHub Pages Setup Guide

This guide explains how to enable GitHub Pages for the web deployment workflow.

## Prerequisites

- Repository owner or admin access
- Web workflow file already in `.github/workflows/web.yml`

## Steps to Enable GitHub Pages

### 1. Navigate to Repository Settings

1. Go to your repository: https://github.com/Asion001/Ics-sync-example
2. Click on **Settings** (gear icon in the top menu)

### 2. Enable GitHub Pages

1. In the left sidebar, scroll down to **Pages** (under "Code and automation")
2. Click on **Pages**

### 3. Configure Source

Under "Build and deployment":
1. **Source**: Select **GitHub Actions** from the dropdown
   - NOT "Deploy from a branch"
   - Select the "GitHub Actions" option
2. Click **Save** if prompted

### 4. Verify Configuration

After saving, you should see:
- A message indicating GitHub Pages is enabled
- Your site will be published at: `https://asion001.github.io/Ics-sync-example/`

### 5. Trigger First Deployment

To trigger the first deployment, you have two options:

**Option A: Push to Main Branch**
```bash
# If changes are merged to main
git checkout main
git pull
# Workflow will run automatically
```

**Option B: Manual Trigger**
1. Go to **Actions** tab
2. Click on **Build and Deploy Web** workflow
3. Click **Run workflow** button
4. Select `main` branch
5. Click **Run workflow**

### 6. Monitor Deployment

1. Go to **Actions** tab
2. Click on the running workflow
3. Monitor the `build` and `deploy` jobs
4. First deployment takes 2-5 minutes

### 7. Access Your Web App

Once deployment completes (green checkmark):
1. Visit: https://asion001.github.io/Ics-sync-example/
2. Or go to **Settings** → **Pages** to see the deployment URL

## Troubleshooting

### Issue: "Deploy to GitHub Pages" step fails

**Solution**: Verify permissions
1. Go to **Settings** → **Actions** → **General**
2. Scroll to "Workflow permissions"
3. Ensure **Read and write permissions** is selected
4. Check **Allow GitHub Actions to create and approve pull requests**
5. Click **Save**

### Issue: 404 Error on deployed site

**Solution**: Check base-href configuration
1. Open `.github/workflows/web.yml`
2. Verify line 36: `--base-href "/Ics-sync-example/"`
3. Repository name must match (case-sensitive)

### Issue: Workflow doesn't trigger

**Solution**: Check workflow file location
1. File must be at: `.github/workflows/web.yml`
2. File must be on `main` branch
3. Push changes to main to trigger

### Issue: Permission denied during deploy

**Solution**: Grant Pages permissions
1. Go to **Settings** → **Actions** → **General**
2. Under "Workflow permissions"
3. Ensure permissions include `pages: write`
4. This is already configured in `web.yml`

## Workflow Details

The web deployment workflow:
1. **Triggers**: Push to main, PR, or manual
2. **Build Job**: 
   - Installs Flutter
   - Builds web app with proper base-href
   - Uploads build artifact
3. **Deploy Job**: 
   - Only runs on main branch pushes
   - Deploys to GitHub Pages
   - Updates live site

## Custom Domain (Optional)

To use a custom domain:
1. Go to **Settings** → **Pages**
2. Under "Custom domain", enter your domain
3. Click **Save**
4. Configure DNS records at your domain provider:
   - Add CNAME record pointing to `asion001.github.io`
5. Wait for DNS propagation (up to 48 hours)

## Security

- HTTPS is automatically enabled
- Enforce HTTPS option available in Pages settings
- Content Security Policy can be added via headers

## Automatic Updates

Once set up:
- Every push to `main` triggers rebuild
- Site updates automatically in 2-5 minutes
- No manual intervention needed
- Previous deployment rolled back on failure

## Verification Checklist

After setup, verify:
- [ ] Pages is enabled with "GitHub Actions" source
- [ ] Workflow runs successfully on push to main
- [ ] Site is accessible at https://asion001.github.io/Ics-sync-example/
- [ ] App loads and functions correctly
- [ ] No console errors in browser DevTools
- [ ] ICS calendar fetch works (CORS configured)

## Notes

- Web app works in all modern browsers
- Mobile responsive design
- Can be installed as PWA
- Service worker for offline capability (once visited)
- No server-side code needed
