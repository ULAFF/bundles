#!/bin/bash
vagrant up;
(sleep 6 && start http://127.0.0.1:8888 &) > /dev/null 2>&1;
vagrant ssh -c "~/LAFF" -- -n
vagrant suspend
