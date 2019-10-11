#export BUILD_ID=dontKillMe这一句很重要，这样指定了，项目启动之后才不会被Jenkins杀掉。
export BUILD_ID=dontKillMe

#指定最后编译好的jar存放的位置 即是发布目录
www_path=/home/pec/www
#Jenkins中编译好的jar位置  即是编译目录
jar_path=/var/lib/jenkins/workspace/demo-test/target
#Jenkins中编译好的jar名称 
jar_name=demo-test-0.0.1-SNAPSHOT.jar

#获取运行编译好的进程ID，便于我们在重新部署项目的时候先杀掉以前的进程
pid=$(cat /home/pec/www/demo-test.pid)

#进入指定的编译好的jar的位置
cd  ${jar_path}
#将编译好的jar复制到最后指定的位置
cp  ${jar_path}/${jar_name} ${www_path}
#进入最后指定存放jar的位置
cd  ${www_path}

if ${pid}; then  #判断进程号id是否存在
    echo "pid is null"
else
    kill -9 ${pid}  #杀掉以前可能启动的项目进程
fi    #if结束标志

#启动jar，指定SpringBoot的profiles为dev,后台启动
#java -jar -Dspring.profiles.active=dev ${jar_name} &
#启动jar，后台执行
java -jar ${jar_name} &

#将进程ID存入到demo-test.pid文件中
echo $! > /home/pec/www/demo-test.pid