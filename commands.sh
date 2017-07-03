* Create the instancedir in ZK
$ cd ~/search
$ solrctl instancedir --create employees employees

* Create collection - employees
$ solrctl collection --create employees -s 1 -r 2 -m 2

* Upload data to HDFS
$ hdfs dfs -mkdir employees
$ hdfs dfs -put data/employees/*.tsv employees

* Collect and set a few bash variables to setup the MRIT command
$ export NN=`grep -A1 "fs.defaultFS" /etc/hadoop/conf/core-site.xml | grep "value" | sed -e 's/<.\?value>//g'` ; export ZK=`grep -A1 zookeeper /etc/hadoop/conf/hdfs-site.xml | grep value | sed -e 's/<.\?value>//g'`

* Run MRIT dry-run (on one input file, 2008.tsv)
$ HADOOP_OPTS="-Djava.security.auth.login.config=/path/to/jaas.conf" hadoop jar /opt/cloudera/parcels/CDH/lib/solr/contrib/mr/search-mr-1.0.0-cdh*-job.jar org.apache.solr.hadoop.MapReduceIndexerTool --zk-host  localhost:2181/solr --collection employees --morphline-file ~/search/morphlines.conf --go-live --dry-run --log4j ~/search/log4j.properties --output-dir NN:8020/tmp/emp_mr_out  NN:8020/user/$USER/employees/2008.tsv
 
* Run go-live (on all data)
$ HADOOP_OPTS="-Djava.security.auth.login.config=/path/to/jaas.conf" hadoop jar /opt/cloudera/parcels/CDH/lib/solr/contrib/mr/search-mr-1.0.0-cdh*-job.jar org.apache.solr.hadoop.MapReduceIndexerTool --zk-host  localhost:2181/solr --collection employees --morphline-file ~/search/morphlines.conf --go-live --log4j ~/search/log4j.properties --output-dir NN:8020/tmp/emp_mr_out  NN:8020/user/$USER/employees
