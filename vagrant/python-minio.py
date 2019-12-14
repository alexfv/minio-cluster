#!/usr/bin/python

from minio import Minio
from minio.error import ResponseError

# Port forwarding "A MinIO node, port 80" -> "Localhost, port 8080"
# should be configured before
minio_node = 'localhost:8080'
minio_access_key = 'minio_rw_user'
minio_secret_key = 'uvcmSQTczZtf4ZnyxUv5RM92F2E3jbjp'
minio_bucket = 'storage'
minio_object = 'test (1).jpg'
minio_object_offset = 1000
output_filename = 'logo.jpg'

minioClient = Minio(minio_node,
                  access_key=minio_access_key,
                  secret_key=minio_secret_key,
                  secure=False)

try:
    data = minioClient.get_partial_object(minio_bucket, minio_object, minio_object_offset)
    with open(output_filename, 'wb') as file_data:
        for d in data:
            file_data.write(d)
except ResponseError as err:
    print(err)
