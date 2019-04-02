echo "Starting SQL Server"
service mysql restart
echo "Setting Username and Password"
mysql -u root < reset-user.sql
echo "Restarting Server - SQL"
pkill mysqld
echo ". . . ."
service mysql start

echo"Loading the database ..."
mysql -u root -ppass < create-db.sql
mysql -u root -ppass umls < backup.sql

#/opt/tomcat/apache-tomcat-8.5.34/bin/catalina.sh run

exec supervisord -n
