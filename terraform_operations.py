import os
import subprocess
import time

def provision_cluster(cluster_data):
    print("cluster_data", cluster_data)
    time.sleep(10)
    pwd = os.getcwd() + f"/provider-templates/{cluster_data['cloud_provider']}"
    print("pwd", pwd)
    time.sleep(10)
    cmds = [f"terraform init",f"terraform validate",f"terraform apply -var-file ../../cluster-templates/{cluster_data['cloud_provider']}_dev_cluster.json"]
    for cmd in cmds:
        provision = subprocess.Popen(cmd, shell= True, cwd = pwd)
        print("cmd", cmd)
        time.sleep(5)
        output = str(provision.communicate())
        print(output)
def deprovision_cluster(cluster_data):
    pwd = os.getcwd() + f"/provider-templates/{cluster_data['cloud_provider']}"
    print("pwd", pwd)
    cmds = [f"terraform destroy -var-file ../../cluster-templates/{cluster_data['cloud_provider']}_dev_cluster.json"]
    for cmd in cmds:
        deprovision = subprocess.Popen(cmd, shell= True, cwd = pwd)
        output = str(deprovision.communicate())
        print(output)