"""
This module is intended to provision resources in AWS,AZURE and GCP cloud platforms
"""
#!/usr/bin/env python3
import sys
import os
import json
import time
# import argparse
from optparse import OptionParser

# parser = argparse.ArgumentParser()
# parser.add_argument('action', )
# from aws.provision import cloud_provision
utils_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(utils_dir, 'utils'))
# from logger import CspLogger as logger
# from utils import cluster_db_handler
from terraform_operations import provision_cluster, deprovision_cluster

def command_options():
    parser = OptionParser(usage=("valid actions"),version="0.1")
    parser.add_option("--cluster_data", action="store", dest="cluster_data")
    parser.add_option("--actions",action="store",dest="actions")
    return parser

# def provision_cluster(cluster_data):
#     print("Started provisioning cluster")
    
#     cluster_db_handler.insert_cluster_info(cluster_data)
#     cluster_db_handler.update_cluster_status_before_provision(cluster_data)
#     cluster_db_handler.update_cluster_status_after_provision(cluster_data)
#     print("Successfully provisioned cluster")
# def deprovision_cluster(cluster_data):
#     print("Started deprovisioning cluster")
#     cluster_db_handler.update_cluster_status_before_deprovision(cluster_data)
#     cluster_db_handler.update_cluster_status_after_deprovision(cluster_data)
#     print("Successfully deprovisioned cluster")

if __name__ == "__main__":
    args_list = sys.argv
    parser = command_options()
    # Parse all arguments and options given
    opts, args = parser.parse_args(args_list)
    options = vars(opts)
    print("options", options)
    with open(options["cluster_data"], 'r') as cd: cluster_data = json.loads(cd.read())
    print("cluster_data", cluster_data)
    
    options_list = options["actions"].split(",")
    if "provision" in options_list:
        provision_cluster(cluster_data)
    elif "deprovision" in options_list:
        deprovision_cluster(cluster_data)
    # cluster_db_handler.retrieve_clusters_info()





