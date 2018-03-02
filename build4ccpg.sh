#!/bin/sh

echo "Redash cmdline for ccpg "
echo "you can use -B/b for webpacking , -R/r for restarting , -D/d for restart in node-debugging mode, -S/s to stop the redash"
case $1 in
-s | -S)
      echo "ShutDown redash ...  "
      ps aux|grep redash|awk '{print $2}'|xargs kill -9
      ;;

-b | -B)
    echo "Packing... " 
    if [ ! -d "node_modules" ];then
       echo "node_modules not exist, return"
       exit 1
    fi  
    ps aux|grep redash|awk '{print $2}'|xargs kill -9
    npm run build | tee npm_run_build.log 
    ps aux|grep node|awk '{print $2}'|xargs kill -9
    ;;
-R | -r)
    echo "Run ..."
    echo "to kill the redash related processes..." 
    ps aux|grep redash|awk '{print $2}'|xargs kill -9
    echo "@ to run the celery and server"
    nohup ./bin/run  celery worker --app=redash.worker --beat -Qscheduled_queries,queries,celery -c2  | tee redash_worker.log & nohup ./bin/run ./manage.py runserver -h 0.0.0.0 -p 8080 | tee redash_server.log &
    ;;
-D | -d)
     echo "to kill the redash related process..."
     ps aux|grep redash|awk '{print $2}'|xargs kill -9
   #  ps aux|grep node|awk '{print $2}'|xargs kill -9&
     
     echo "Debug Mode.. you may modify the webpack related files first : webpack.config.js and package.json "
     unset $REDASH_BACKEND
     echo "to run server"
     nohup ./bin/run ./manage.py runserver --debugger --reload | tee redash_server.log & nohup ./bin/run celery worker --app=redash.worker --beat -Qscheduled_queries,queries,celery -c2  | tee redash_worker.log & nohup  npm run start | tee npm_run.log &
      ;;
*)
    echo "illegal command!"  
    ;;
esac

