DO $$
BEGIN
  if NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'iam_user_1') THEN
      create user iam_user_1 WITH LOGIN;
  END IF;
 
  if NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'iam_user_2') THEN
      create user iam_user_2 WITH LOGIN;
  END IF;
END
$$;

-- We can have multiple IAM users to have different permissions
-- iam_user_1 & iam_user_2, etc.

GRANT rds_iam TO iam_user_1;
grant usage on schema public to iam_user_1;
grant select on table public.student to iam_user_1;

GRANT rds_iam TO iam_user_2;
grant usage on schema public to iam_user_2;
grant select on table public.student to iam_user_2;