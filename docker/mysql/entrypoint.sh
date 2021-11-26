#!/bin/sh
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE_HISTORY=trade_history
MYSQL_DATABASE_LOG=trade_log
MYSQL_USER=root
MYSQL_PASSWORD=root
SOCKET=/run/mysqld/mysqld.sock

echo "-----------------"

echo 'SET PASSWORD'

/bin/sh -c "${mysql}" <<-EOSQL
	-- What's done in this file shouldn't be replicated
	--  or products like mysql-fabric won't work
	SET @@SESSION.SQL_LOG_BIN=0;
	DELETE FROM mysql.user WHERE user NOT IN ('mysql.session', 'mysql.sys', 'root') OR host NOT IN ('localhost') ;
	SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
	GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;
	DROP DATABASE IF EXISTS test ;
	FLUSH PRIVILEGES ;
	CREATE DATABASE $MYSQL_DATABASE_HISTORY;
	CREATE DATABASE $MYSQL_DATABASE_LOG;
	GRANT ALL ON $MYSQL_DATABASE_HISTORY.* TO '$MYSQL_USER'@'%' ;
	GRANT ALL ON $MYSQL_DATABASE_LOG.* TO '$MYSQL_USER'@'%' ;
	FLUSH PRIVILEGES ;
EOSQL

mysql="mysql --protocol=socket -u${MYSQL_USER} -p${MYSQL_PASSWORD} -hlocalhost --socket=${SOCKET} $MYSQL_DATABASE_HISTORY"
echo "${mysql} < /docker-entrypoint-files/create_trade_history.sql";
/bin/sh -c "${mysql}" < "/docker-entrypoint-files/create_trade_history.sql";

mysql="mysql --protocol=socket -u${MYSQL_USER} -p${MYSQL_PASSWORD} -hlocalhost --socket=${SOCKET} $MYSQL_DATABASE_LOG"
echo "${mysql} < /docker-entrypoint-files/create_trade_log.sql";
/bin/sh -c "${mysql}" < "/docker-entrypoint-files/create_trade_log.sql";

sed -i.bak "s/MYSQL_USER=.*$/MYSQL_USER=\"${MYSQL_USER}\"/" /docker-entrypoint-files/init_trade_history.sh
sed -i.bak "s/MYSQL_PASS=.*$/MYSQL_PASS=\"${MYSQL_PASSWORD}\"/" /docker-entrypoint-files/init_trade_history.sh
sed -i.bak "s/MYSQL_DB=.*$/MYSQL_DB=\"${MYSQL_DATABASE_HISTORY}\"/" /docker-entrypoint-files/init_trade_history.sh
/docker-entrypoint-files/init_trade_history.sh

echo
echo 'MySQL init process done. Ready for start up.'
echo
