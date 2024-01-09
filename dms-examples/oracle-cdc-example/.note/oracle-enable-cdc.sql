-- Enable CDC
CALL rdsadmin.rdsadmin_util.set_configuration('archivelog retention hours',24);
CALL rdsadmin.rdsadmin_util.alter_supplemental_logging('ADD');
CALL rdsadmin.rdsadmin_util.alter_supplemental_logging('ADD','PRIMARY KEY');
 
SELECT LOG_MODE FROM "V$DATABASE";