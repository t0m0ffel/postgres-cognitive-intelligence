CREATE OR REPLACE FUNCTION test(m movies)
  RETURNS INTEGER
AS $$
keys = []
for key in m:
    keys.append(key)

plpy.notice(keys)
return 1
$$
LANGUAGE plpythonu;
