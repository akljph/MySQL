#!/bin/bash
mysql -u$LC_user -p$LC_pass -e 'USE Employees; INSERT INTO employees (First_Name,Last_Name) VALUES ("Wade","Wilson");'
