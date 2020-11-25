//切割视频第10秒 为封面图 [清晰版]
#!/bin/sh
path="/var/www/html/uploads/videos/"
for file_a in ${path}/*
do
    filename=`basename $file_a`  
	ffmpeg -ss 00:00:10 -i /var/www/html/uploads/videos/$filename -t 1 -s 350x350 -r 1 -q:v 2 -f image2 -y /var/www/html/uploads/photos/$filename.jpg
done

