#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# -------------------------
# CONFIGURATION
# -------------------------
BRANCH_SOURCE="main"        # branch with the source code
BRANCH_TARGET="gh-pages"    # branch where the site will be deployed
BUILD_DIR="public"          # directory where rake generates the site
TEMP_DIR=$(mktemp -d)       # temporary directory to hold the build

# -------------------------
# 1. Checkout source branch
# -------------------------
git checkout $BRANCH_SOURCE
echo "==> On branch $BRANCH_SOURCE"

# -------------------------
# 2. Build the site
# -------------------------
echo "==> Building the site with Jekyll/Rake..."
bundle install
bundle exec rake generate

# -------------------------
# 3. Verify build output
# -------------------------
if [ ! -d "$BUILD_DIR" ] || [ -z "$(ls -A $BUILD_DIR)" ]; then
    echo "❌ Build failed: $BUILD_DIR is missing or empty"
    exit 1
fi

# -------------------------
# 4. Copy build to temp dir
# -------------------------
echo "==> Saving build output to $TEMP_DIR..."
cp -r $BUILD_DIR/. $TEMP_DIR

# -------------------------
# 5. Checkout or create gh-pages branch
# -------------------------
if git show-ref --verify --quiet refs/heads/$BRANCH_TARGET; then
    echo "==> Branch $BRANCH_TARGET exists, checking out..."
    git checkout $BRANCH_TARGET
else
    echo "==> Branch $BRANCH_TARGET does not exist, creating orphan..."
    git checkout --orphan $BRANCH_TARGET
fi

# Clean old files
git reset --hard
git clean -df

# -------------------------
# 6. Copy build from temp dir
# -------------------------
echo "==> Copying files from temp build folder..."
cp -r $TEMP_DIR/. .

# -------------------------
# 7. Ensure GitHub Pages does not run Jekyll
# -------------------------
touch .nojekyll

# -------------------------
# 8. Commit and push
# -------------------------
echo "==> Committing and pushing to $BRANCH_TARGET..."
git add .
git commit -m "Deploy site on $(date)" || echo "Nothing new to commit"
git push origin $BRANCH_TARGET --force

# -------------------------
# 9. Switch back to source branch
# -------------------------
echo "==> Switching back to $BRANCH_SOURCE..."
git checkout $BRANCH_SOURCE

# -------------------------
# 10. Cleanup
# -------------------------
rm -rf $TEMP_DIR

echo "✅ Deployment completed! Configure GitHub Pages to serve from $BRANCH_TARGET."
echo "Site will be available at https://TU-USUARIO.github.io/home-assistant.io/"

