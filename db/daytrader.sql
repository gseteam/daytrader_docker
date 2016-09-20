create database tradedb;
CREATE USER 'daytrader'@'%' IDENTIFIED BY 'daytrader';
GRANT ALL PRIVILEGES ON tradedb.* TO daytrader;
