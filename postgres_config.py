# Basic settings for postgres db
# Modify if needed

conf_type = 'postgresql'
conf_driver = 'psycopg2'
conf_dbuser = 'postgres'
conf_dbpassword = 'postgres'
conf_hostname = 'localhost'
conf_dbport = '5432'
conf_dbname = 'imbd'

postgres_uri = '{}+{}://{}:{}@{}:{}/{}'.format(conf_type, conf_driver, conf_dbuser, conf_dbpassword, conf_hostname,
                                               conf_dbport,
                                               conf_dbname)
