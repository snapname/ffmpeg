#ffmpeg 切片头 片尾

#!/bin/sh
#要切除的开头和结尾 时间秒
beg=5
end=9
path="/var/www/html/uploads/videos/"
for file_a in ${path}/*
do
	#将元数据信息临时保存到 tmp.log 文件中
	filename=`basename $file_a`	
    ffmpeg -i /var/www/html/uploads/videos/$filename > /root/tmp.log 2>&1
    #获取视频的时长，格式为  00:00:10,10 （时：分：秒，微妙）
    time="`cat tmp.log |grep Duration: |awk  '{print $2}'|awk -F "," '{print $1}'|xargs`"
    echo $time
	#求视频的总时长，先分别求出小时、分、秒的值，这里不处理微秒，可以忽略
    hour="`echo $time |awk -F ":" '{print $1}' `"
    min="`echo $time |awk -F ":" '{print $2}' `"
    sec="`echo $time |awk -F ":" '{print $3}'|awk -F "." '{print $1}' `"
    #echo $hour $min $sec
    num1=`expr $hour \* 3600`
    num2=`expr $min \* 60`
    num3=$sec
    #计算出视频的总时长（秒）
	sum=`expr $num1 + $num2 + $num3`  
    echo $sum
    #总时长减去开头和结尾就是截取后的视频时长,并且这里不需要再转回 hour:min:sec 的格式，直接使用结果即可
    newtime=`expr $sum - $beg - $end`
    echo $newtime
    #ffmpeg -ss 00:00:05 -i /var/www/html/$filename -t $newtime -c:v libx264 -movflags faststart -r 25 -b:v 1200k -s 1920x1080  /var/www/html/uploads/$filename 
    ffmpeg -i /var/www/html/uploads/videos/$filename -t $newtime -c:v copy -c:a copy  /var/www/html/uploads/videos/$filename 
done
  
