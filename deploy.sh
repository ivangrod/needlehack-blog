#!/bin/bash
set -e  # exit immediately if a command exits with a non-zero status

BRANCH_SOURCE="main"       # source branch with the website code
BRANCH_TARGET="gh-pages"   # target branch for deployment
BUILD_DIR="public"         # directory where rake generates the site
TEMP_DIR=$(mktemp -d)      # temporary directory to hold the build

# 1. Make sure we are on the source branch
git checkout $BRANCH_SOURCE

# 2. Build the site
echo "==> Building the site with Jekyll/Rake..."
bundle install
bundle exec rake generate

# 3. Check if build succeeded
if [ ! -d "$BUILD_DIR" ] || [ -z "$(ls -A $BUILD_DIR)" ]; then
  echo "❌ Build failed: $BUILD_DIR is missing or empty"
  exit 1
fi

# 4. Copy build output to a temporary directory
echo "==> Saving build output to $TEMP_DIR..."
cp -r $BUILD_DIR/. $TEMP_DIR

# 5. Create or update gh-pages branch
echo "==> Preparing branch $BRANCH_TARGET..."
git checkout $BRANCH_TARGET 2>/dev/null || git checkout --orphan $BRANCH_TARGET
git reset --hard
git clean -df

# 6. Copy from temp dir into repo root
echo "==> Copying files from temp build folder..."
cp -r $TEMP_DIR/. .

# 7. Prevent GitHub Pages from running Jekyll again
touch .nojekyll

# 8. Commit and push
echo "==> Publishing to $BRANCH_TARGET..."
git add .
git commit -m "Deploy site on $(date)" || echo "Nothing new to commit"
git push origin $BRANCH_TARGET --force

# 9. Go back to the source branch
echo "==> Switching back to $BRANCH_SOURCE..."
git checkout $BRANCH_SOURCE

# 10. Cleanup
rm -rf $TEMP_DIR

echo "✅ Deployment completed. Configure GitHub Pages to serve from $BRANCH_TARGET."

