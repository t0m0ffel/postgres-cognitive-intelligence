CREATE OR REPLACE FUNCTION test(word1 VARCHAR [])
  RETURNS VARCHAR []
AS $$

import os

plpy.notice(os.path.abspath('.'))


def main(word1):
    return [word1]


return word1
$$
LANGUAGE plpythonu;