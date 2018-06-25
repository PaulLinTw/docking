# -*- coding: utf-8 -*-
"""
Created on Sat Mar 31 13:51:10 2018

@author: jimmybow
"""

# -*- coding: utf-8 -*-
"""
Created on Wed Mar 21 13:32:12 2018

@author: jimmybow
"""

from apscheduler.schedulers.blocking import BlockingScheduler 
from datetime import datetime
import subprocess
import os
import sys
from usecase_incl import incl

root = os.path.abspath(os.path.dirname(__file__))
sched = BlockingScheduler() 
def run_cluster(): 
    cmd = ['python', 'cluster.py', incl.charts_datarange ]
    try:   subprocess.run(cmd, timeout = incl.charts_interval-20, cwd = root, check = True, stderr=subprocess.PIPE)
    except subprocess.TimeoutExpired:          print('cluster.py stop for timeout', file = open('log.txt', 'a'))
    except subprocess.CalledProcessError as e: print(e.stderr.decode(), file = open('log.txt', 'a'))
        
def run_apriori(): 
    cmd = ['python', 'apriori.py', incl.charts_datarange ]
    try:   subprocess.run(cmd, timeout = incl.charts_interval-20, cwd = root, check = True, stderr=subprocess.PIPE)
    except subprocess.TimeoutExpired:          print('apriori.py stop for timeout', file = open('log.txt', 'a'))
    except subprocess.CalledProcessError as e: print(e.stderr.decode(), file = open('log.txt', 'a'))
        
sched.add_job(run_cluster, 'interval', seconds = incl.charts_interval, next_run_time = datetime(2018,3,21,0,5))
sched.add_job(run_apriori, 'interval', seconds = incl.charts_interval, next_run_time = datetime(2018,3,21,0,10))
sched.start()
