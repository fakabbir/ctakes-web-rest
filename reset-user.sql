FLUSH PRIVILEGES;
USE mysql;
UPDATE user SET authentication_string=PASSWORD("pass") WHERE User='root';
UPDATE user SET plugin="mysql_native_password" WHERE User='root';
