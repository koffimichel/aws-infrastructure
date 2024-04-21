#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from \$(hostname -f)" > /var/www/html/index.html
 # Install AWS CLI
yum install -y aws-cli

# Create a script to upload logs to S3
echo '#!/bin/bash' > /tmp/upload_logs_to_s3.sh
echo 'LOG_DIR="/var/log/httpd"' >> /tmp/upload_logs_to_s3.sh
echo 'S3_BUCKET="your-s3-bucket"' >> /tmp/upload_logs_to_s3.sh
echo 'DATE=$(date +"%Y-%m-%d")' >> /tmp/upload_logs_to_s3.sh
echo 'aws s3 sync ${LOG_DIR} s3://${S3_BUCKET}/${DATE}/ --exclude "*" --include "access_log*" --include "error_log*"' >> /tmp/upload_logs_to_s3.sh
chmod +x /tmp/upload_logs_to_s3.sh

 # Schedule the script to run daily using cron
echo '0 0 * * * /tmp/upload_logs_to_s3.sh' > /tmp/cron_job
crontab /tmp/cron_job