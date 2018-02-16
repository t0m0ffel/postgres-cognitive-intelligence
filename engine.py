from sqlalchemy import create_engine

from postgres_config import postgres_uri

POOL_SIZE = 500
engine = create_engine(postgres_uri, pool_size=POOL_SIZE, max_overflow=0)
execute = engine.execute
