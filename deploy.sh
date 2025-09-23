#!/bin/bash
set -e  # exit immediately if a command exits with a non-zero status

BRANCH_SOURCE="main"       # source branch with the website code
BRANCH_TARGET="gh-pages"   # target branch for deployment
BUILD_DIR="public"          # directory where rake generates the site

# 1. Build the site
echo "==> Building the site with Jekyll/Rake..."
bundle install
bundle exec rake generate

# 2. Create or update gh-pages branch
echo "==> Preparing branch $BRANCH_TARGET..."
git checkout $BRANCH_TARGET 2>/dev/null || git checkout --orphan $BRANCH_TARGET
git reset --hard
git clean -df

# 3. Copy the build output
echo "==> Copying files from $BUILD_DIR..."
cp -r $BUILD_DIR/* .

# 4. Prevent GitHub Pages from running Jekyll again
touch .nojekyll

# 5. Commit and push
echo "==> Publishing to $BRANCH_TARGET..."
git add .
git commit -m "Deploy site on $(date)" || echo "Nothing new to commit"
git push origin $BRANCH_TARGET --force

# 6. Go back to the source branch
echo "==> Switching back to $BRANCH_SOURCE..."
git checkout $BRANCH_SOURCE

echo "✅ Deployment completed. Configure GitHub Pages to serve from $BRANCH_TARGET."

