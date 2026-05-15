#!/bin/bash
# 批量上传课件图片到 Cloudflare R2 存储桶

# 配置参数
BUCKET_NAME="jumpxai-courses"
COURSE_SLUG="ai-camp"
LESSON_SLUG="week-01-intro"
LOCAL_DIR="draft-assets/week-01"

echo "开始上传图片到 R2 存储桶: $BUCKET_NAME"
echo "目标路径: courses/$COURSE_SLUG/$LESSON_SLUG/"
echo "----------------------------------------"

# 遍历目录下的所有 png 和 jpg 文件
for file in "$LOCAL_DIR"/*.{png,jpg,jpeg}; do
    # 检查文件是否存在（防止通配符未匹配到文件）
    [ -e "$file" ] || continue
    
    filename=$(basename "$file")
    target_path="courses/$COURSE_SLUG/$LESSON_SLUG/$filename"
    
    echo "正在上传: $filename -> $target_path"
    wrangler r2 object put "$BUCKET_NAME/$target_path" --file "$file" --remote
done

echo "----------------------------------------"
echo "上传完成！"
