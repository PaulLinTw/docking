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
def create_model(): 
    i = 'create_model'
    cmd = ['python', 'create_model.py', incl.aptimer_datarange[i] ]
    try:   subprocess.run(cmd, timeout = incl.aptimer_interval[i]-20, cwd = root, check = True, stderr=subprocess.PIPE)
    except subprocess.TimeoutExpired:          print('create_model.py stop for timeout', file = open('log.txt', 'a'))
    except subprocess.CalledProcessError as e: print(e.stderr.decode(), file = open('log.txt', 'a'))

def create_model_MLP(): 
    i = 'create_model_MLP'
    cmd = ['python', 'create_model_MLP.py', incl.aptimer_datarange[i] ]
    try:   subprocess.run(cmd, timeout = incl.aptimer_interval[i]-20, cwd = root, check = True, stderr=subprocess.PIPE)
    except subprocess.TimeoutExpired:          print('create_model_MLP.py stop for timeout', file = open('log.txt', 'a'))
    except subprocess.CalledProcessError as e: print(e.stderr.decode(), file = open('log.txt', 'a'))
    
def create_model_LSTM():
    i = 'create_model_LSTM' 
    cmd = ['python', 'create_model_LSTM.py', incl.aptimer_datarange[i] ]
    try:   subprocess.run(cmd, timeout = incl.aptimer_interval[i]-20, cwd = root, check = True, stderr=subprocess.PIPE)
    except subprocess.TimeoutExpired:          print('create_model_LSTM.py stop for timeout', file = open('log.txt', 'a'))
    except subprocess.CalledProcessError as e: print(e.stderr.decode(), file = open('log.txt', 'a'))    

def create_model_LSTM_seq_to_one(): 
    i = 'create_model_LSTM_seq_to_one'
    cmd = ['python', 'create_model_LSTM_seq_to_one.py', incl.aptimer_datarange[i] ]
    try:   subprocess.run(cmd, timeout = incl.aptimer_interval[i]-20, cwd = root, check = True, stderr=subprocess.PIPE)
    except subprocess.TimeoutExpired:          print('create_model_LSTM_seq_to_one.py stop for timeout', file = open('log.txt', 'a'))
    except subprocess.CalledProcessError as e: print(e.stderr.decode(), file = open('log.txt', 'a'))    
            
for i in incl.aptimer[sys.argv[1]]:
    sched.add_job(eval(i), 'interval', seconds = incl.aptimer_interval[i], next_run_time = eval(incl.aptimer_next_run_time[i]))
sched.start()
