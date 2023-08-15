
import sys
import csv
from faker import Faker
import boto3

def generate_csv_data(filename):

  fake = Faker()
  number_of_records = int(sys.argv[1])
  with open(filename, mode='w') as file:
    file_writer = csv.writer(file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    file_writer.writerow(['first_name', 'last_name', 'age'])

    for _ in range(number_of_records):
      file_writer.writerow([fake.first_name(), fake.last_name(), fake.numerify("@#")])
  return filename

def s3_upload_csv(fileName):

  # Connect to AWS s3 using Boto3
  s3 = boto3.client('s3')

  # Connect to AWS SSM Parameter Store using Boto3
  ssm = boto3.client('ssm')
  ssm_BucketName= ssm.get_parameter(Name="/dev/s3BucketName/string")
  bucketName= ssm_BucketName['Parameter']['Value']

  s3.upload_file('/home/ec2-user/' + fileName,bucketName,fileName)


fileName=generate_csv_data("employee-record.csv")
s3_upload_csv(fileName)
