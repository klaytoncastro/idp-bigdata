```bash
chmod +x permissions.sh
./permissions.sh
docker exec -it <nome_do_contêiner> /bin/bash
```

```bash
jupyter config password
```

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()
```

```python
spark.stop()
```