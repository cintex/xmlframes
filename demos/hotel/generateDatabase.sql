CREATE DATABASE hotel;

USE hotel;


DROP TABLE IF EXISTS city;

CREATE TABLE city (
          city_name VARCHAR(50) ,
          city_province VARCHAR(255) ,
          city_x INT ,
          city_y INT ,
          PRIMARY KEY(city_name))
;

DROP TABLE IF EXISTS client;

CREATE TABLE client (
          client_number INT AUTO_INCREMENT ,
          client_title VARCHAR(1) ,
          client_name VARCHAR(30) ,
          client_firstname VARCHAR(30) ,
          client_address VARCHAR(10) ,
          client_tels LONGTEXT ,
          PRIMARY KEY(client_number))
;

DROP TABLE IF EXISTS address;

CREATE TABLE address (
          address_id INT AUTO_INCREMENT ,
          address_street VARCHAR(30) ,
          address_zipcode VARCHAR(5) ,
          address_city VARCHAR(50) ,
          PRIMARY KEY(address_id))
;

DROP TABLE IF EXISTS manager_client;

CREATE TABLE manager_client (
          client_number VARCHAR(10) NOT NULL ,
          manager_id VARCHAR(255) NOT NULL ,
          PRIMARY KEY(client_number,manager_id))
;

DROP TABLE IF EXISTS reservation;

CREATE TABLE reservation (
          reservation_number INT AUTO_INCREMENT ,
          reservation_state VARCHAR(1) NOT NULL ,
          reservation_date DATETIME ,
          reservation_client VARCHAR(10) ,
          reservation_check_in DATETIME ,
          reservation_check_out DATETIME ,
          reservation_days INT ,
          reservation_establishment VARCHAR(10) ,
          reservation_rooms VARCHAR(11) ,
          reservation_adults TINYINT ,
          reservation_children TINYINT ,
          current_reservation_rooms VARCHAR(11) ,
          PRIMARY KEY(reservation_number))
;

DROP TABLE IF EXISTS establishment;

CREATE TABLE establishment (
          establishment_id INT AUTO_INCREMENT ,
          establishment_name VARCHAR(60) ,
          establishment_category VARCHAR(1) ,
          establishment_manager VARCHAR(255) ,
          establishment_address VARCHAR(10) ,
          establishment_tel VARCHAR(14) ,
          establishment_description VARCHAR(90) ,
          establishment_picture VARCHAR(255) ,
          establishment_rooms VARCHAR(11) ,
          PRIMARY KEY(establishment_id))
;

DROP TABLE IF EXISTS manager;

CREATE TABLE manager (
          manager_id VARCHAR(255) ,
          manager_password VARCHAR(255) ,
          manager_name VARCHAR(255) ,
          manager_firstname VARCHAR(255) ,
          manager_picture VARCHAR(255) ,
          manager_date DATETIME ,
          PRIMARY KEY(manager_id))
;

DROP TABLE IF EXISTS province;

CREATE TABLE province (
          province_id VARCHAR(255) ,
          province_name VARCHAR(255) ,
          PRIMARY KEY(province_id))
;

DROP TABLE IF EXISTS room;

CREATE TABLE room (
          room_id INT AUTO_INCREMENT ,
          room_number INT ,
          room_type VARCHAR(1) ,
          room_rate DOUBLE(25,2) ,
          room_smoking VARCHAR(1) ,
          room_bath VARCHAR(1) ,
          room_equipment VARCHAR(1) ,
          room_picture VARCHAR(255) ,
          PRIMARY KEY(room_id))
;

GRANT ALL ON hotel.* TO 'demo'@'%' IDENTIFIED BY 'vraduser';
