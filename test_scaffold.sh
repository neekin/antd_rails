#!/bin/bash

# 测试 Ant Scaffold Generator

echo "=== 测试 Ant Scaffold Generator ==="
echo ""

# 清理之前的测试文件
echo "清理之前的测试文件..."
rm -f app/models/post.rb
rm -f app/controllers/posts_controller.rb
rm -rf app/views/posts
rm -f db/migrate/*_create_posts.rb

echo ""
echo "生成 Post scaffold..."
rails generate ant:scaffold Post title:string content:text published:boolean

echo ""
echo "=== 生成的文件 ==="
echo ""

echo "Model:"
if [ -f "app/models/post.rb" ]; then
  echo "✅ app/models/post.rb"
else
  echo "❌ app/models/post.rb 未生成"
fi

echo ""
echo "Controller:"
if [ -f "app/controllers/posts_controller.rb" ]; then
  echo "✅ app/controllers/posts_controller.rb"
else
  echo "❌ app/controllers/posts_controller.rb 未生成"
fi

echo ""
echo "Views:"
for view in index show new edit _form; do
  if [ -f "app/views/posts/${view}.html.erb" ]; then
    echo "✅ app/views/posts/${view}.html.erb"
  else
    echo "❌ app/views/posts/${view}.html.erb 未生成"
  fi
done

echo ""
echo "Migration:"
if ls db/migrate/*_create_posts.rb 1> /dev/null 2>&1; then
  echo "✅ db/migrate/*_create_posts.rb"
else
  echo "❌ Migration 未生成"
fi

echo ""
echo "=== 测试完成 ==="
