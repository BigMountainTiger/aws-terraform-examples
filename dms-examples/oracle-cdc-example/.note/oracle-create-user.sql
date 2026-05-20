-- https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.Oracle.html#CHAP_Source.Oracle.Amazon-Managed

CREATE USER CDCUSER IDENTIFIED BY "password-123";

-- Basic permissions
GRANT CREATE SESSION to CDCUSER;
GRANT SELECT ANY TRANSACTION to CDCUSER;
GRANT SELECT on DBA_TABLESPACES to CDCUSER;
GRANT EXECUTE on rdsadmin.rdsadmin_util to CDCUSER;
GRANT LOGMINING to CDCUSER;

-- Additional permissions
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_VIEWS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_TAB_PARTITIONS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_INDEXES', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_OBJECTS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_TABLES', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_USERS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_CATALOG', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_CONSTRAINTS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_CONS_COLUMNS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_TAB_COLS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_IND_COLUMNS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_LOG_GROUPS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$ARCHIVED_LOG', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$LOG', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGFILE', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$DATABASE', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$THREAD', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$PARAMETER', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$NLS_PARAMETERS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$TIMEZONE_NAMES', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$TRANSACTION', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$CONTAINERS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('DBA_REGISTRY', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('OBJ$', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('ALL_ENCRYPTED_COLUMNS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_LOGS', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_CONTENTS','CDCUSER','SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('DBMS_LOGMNR', 'CDCUSER', 'EXECUTE');


-- Special permissions
CALL rdsadmin.rdsadmin_util.grant_sys_object('REGISTRY$SQLPATCH', 'CDCUSER', 'SELECT');
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$STANDBY_LOG', 'CDCUSER', 'SELECT'); 
CALL rdsadmin.rdsadmin_util.grant_sys_object('ENC$', 'CDCUSER', 'SELECT'); 
CALL rdsadmin.rdsadmin_util.grant_sys_object('DBMS_CRYPTO', 'CDCUSER', 'EXECUTE');
CALL rdsadmin.rdsadmin_util.grant_sys_object('DBA_DIRECTORIES','CDCUSER','SELECT'); 
CALL rdsadmin.rdsadmin_util.grant_sys_object('V_$DATAGUARD_STATS', 'CDCUSER', 'SELECT');
