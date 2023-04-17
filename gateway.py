"""
This module is intended to provision resources in AWS,AZURE and GCP cloud platforms
"""
import os,sys,json
from aws.provision import cloud_provision
utils_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(utils_dir, 'utils'))
from logger import CspLogger as logger

def inputs_data():
    '''
    this function is to take inputs from the user
    '''
    try:
        logger.info("hey this is from Try stmt")
    except:
        logger.info("hey this is from Except stmt")

def cloud_provision():

    if cloud_platform == 'AWS' or cloud_platform == 'aws':
        aws = aws_provision()
    elif cloud_platform == 'AZURE' or cloud_platform == 'AZURE' or cloudplatform == 'Azure':
        azure = azure_provision()
    else cloud_platform == 'GCP' or cloud_platform == 'azure':
        gcp = gcp_provision()

if __name__ == '__main__':
    logger.create()
    inputdata()
    cloud_provision()

    
