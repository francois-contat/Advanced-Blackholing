#!/bin/bash
vagrant ssh transit1-good -- 'nohup ping 2.2.1.1 > /dev/null 2>&1 &'
vagrant ssh transit2-bad -- 'nohup ping 2.2.1.1 > /dev/null 2>&1 &'
vagrant ssh transit3-mixed -- 'nohup ping 2.2.1.1 > /dev/null 2>&1 &'
vagrant ssh transit3-mixed -- 'nohup ping 2.2.1.1 -p 48656c6c6f205249504537332021 > /dev/null 2>&1 &'
