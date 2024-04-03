--set pgaudit parameter
ALTER SYSTEM SET pgaudit.log_catalog = off;
ALTER SYSTEM SET pgaudit.log = 'all, -misc';
ALTER SYSTEM SET pgaudit.log_relation = 'on';
ALTER SYSTEM SET pgaudit.log_parameter = 'on';

--set audit role
CREATE ROLE auditor;
SET pgaudit.role TO 'auditor';
ALTER SYSTEM SET pgaudit.role = 'auditor';
--restart after init activate changes
--SELECT pg_reload_conf();
