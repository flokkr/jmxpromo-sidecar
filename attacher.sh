#!/usr/bin/env bash

AGENT_PORT=${JMXPROMO_PORT:-28942}
while true; do
    nc -z "localhost" "$AGENT_PORT" > /dev/null 2>&1
    result=$?
    if [ $result -eq 0 ] ; then
      echo "Prometheus agent is running at http://localhost:$AGENT_PORT"
    else
      FIRST_JAVA_PID=$(jps -l | grep -v Jps | awk '{print $1}' | head -n 1)
		if [ "$FIRST_JAVA_PID" ]; then 
         echo "Instrumenting java process $FIRST_JAVA_PID"
			#tmp should be a shared directory
			cp /opt/jmxpromo.jar /tmp/
         java -cp /tmp/jmxpromo.jar:/usr/lib/jvm/default-jvm/lib/tools.jar io.prometheus.jmx.shaded.io.prometheus.jmx.Attach $FIRST_JAVA_PID port=$AGENT_PORT
      else
		   echo "No java process is found."
      fi
    fi
    sleep 5
done

