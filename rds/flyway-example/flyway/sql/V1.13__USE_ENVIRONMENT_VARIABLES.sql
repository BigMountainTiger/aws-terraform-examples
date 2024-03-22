-- This uses environment variable to pass data into the script
insert into Student(ID, NAME) VALUES(100, '${env_user}')
