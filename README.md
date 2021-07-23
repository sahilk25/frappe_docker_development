# frappe_docker_development for bloomstack
This will create 3 container for development{frappe,mariadb,redis}
frappe container contains all the bench depedencies + ohmyzsh + git + nodejs

##  Prerequisites<h2 >
* docker
* vscode

##  How to Start<h2 >
* ``` git clone https://github.com/sahilk25/frappe_docker_development.git```
* ``` cd frappe_docker_development && mkdir development```
* ``` docker build -t bench:latest bench_docker```

* click on reopne in container

## What it will create
* frappe-bench directory in development directory
* get-app frappe erpnect bloomstack_core from bloomstack repo
* set up some bench commands{check [setupbench.sh](https://github.com/sahilk25/frappe_docker_development/blob/main/bench_docker/setupbench.sh) in bench_docker directory}
#### Thnx to frappe_docker
https://github.com/frappe/frappe_docker click for more information

